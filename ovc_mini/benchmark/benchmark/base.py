"""Defines the base test class"""

import numpy as np
import dataclasses
import json
import os
import socket
import subprocess
import time
from typing import Any, Dict, List
from pathlib import Path

from benchmark.ssh_session import SSHSession

FILE_DIR = Path(os.path.dirname(os.path.abspath(__file__)))
# Number of times to retry an unreliable execution before erroring.
RETRY_COUNT = 5


class Benchmark:
    """Base class for benchmark collection."""
    @dataclasses.dataclass
    class Results:
        """Stores data related to general test results."""
        duration: float  # seconds
        interval: float  # seconds
        sample_count: int

    def __init__(self, session: SSHSession, address: str, port: int):
        self._session = session
        self._address = address
        self._port = port


class IperfBench(Benchmark):
    """Manages an iperf3 test on the remote server."""
    @dataclasses.dataclass
    class Results(Benchmark.Results):
        """Stores data related to iperf test results."""
        window_size: int  # Bytes
        parallel_streams: int  # Number of threads sending data
        average_bandwidth: float  # Mbps
        sigma: float  # Mbps
        ci_2: float  # Mbps 95% confidence interval
        ci_3: float  # Mbps 99.7% confidence interval

    def __enter__(self):
        self._session.run(f"iperf3 -s -p {self._port} > /dev/null 2>&1 &")
        return self

    def __exit__(self, exit_type, value, traceback):
        # Close all iperf3 sessions
        self._session.run(f"killall iperf3")

    def run_test(self, duration: float, interval: float, parallel_streams: int,
                 window_size: int) -> Results:
        # Read https://www.cisco.com/c/en/us/support/docs/wireless-mobility/wireless-lan-wlan/212892-802-11ac-wireless-throughput-testing-and.html
        cmd = (
            f"iperf3"
            f" -R"  # Reverses iperf so the server sends to the client
            f" -J"  # Output in JSON format
            f" -c {self._address}"
            f" -p {self._port}"
            f" -i {interval}"
            f" -t {duration}"
            f" -P {parallel_streams}"
            f" -w {window_size}k")
        out = None
        retry = 0
        while out is None:
            try:
                out = subprocess.check_output(cmd, shell=True)
            except subprocess.CalledProcessError as e:
                if retry > RETRY_COUNT:
                    raise e
                retry += 1
                time.sleep(1)

        return self.Results(interval=interval,
                            duration=duration,
                            window_size=window_size,
                            parallel_streams=parallel_streams,
                            **self.process_results(out))

    @staticmethod
    def process_results(iperf_output: str) -> Dict[str, Any]:
        """Processes iperf output."""
        def to_Mbps(bps: float) -> float:
            return round(bps * 1e-6, 2)

        data = json.loads(iperf_output)
        bps = []
        for interval in data['intervals']:
            bps.append(interval['sum']['bits_per_second'])

        samples = len(data['intervals'])
        avg = np.average(bps)
        sigma = np.std(bps)
        ci_2 = max(0, avg - (2 * sigma))
        ci_3 = max(0, avg - (3 * sigma))

        return {
            'sample_count': samples,
            'average_bandwidth': to_Mbps(avg),
            'sigma': to_Mbps(sigma),
            'ci_2': to_Mbps(ci_2),
            'ci_3': to_Mbps(ci_3),
        }


class PayloadBench(Benchmark):
    """
    Run simulated load test.

    This is defined as a fixed size packet queued at a fixed interval.
    We are interested if the packets get backed up (meaning bandwidth is
    not able to keep up with the packet queue).
    """
    TEST_PROGRAM_NAME = 'test_server_arm'

    @dataclasses.dataclass
    class Results(Benchmark.Results):
        """
        Stores data related to iperf test results.

        Attributes:
            start_time: time that the test started. Does not have to be system
                time.
            packet_received: time a packet was received from start of test.
                The data should only be relative to the start time.
        """
        packet_size: int  # Megabytes
        start_time: float
        receive_times: List[float]

    def __enter__(self):
        subprocess.check_output(f"cd {FILE_DIR} && make arm", shell=True)
        self._session.scp(FILE_DIR / 'build' / self.TEST_PROGRAM_NAME,
                          Path('/tmp'))
        return self

    def __exit__(self, exit_type, value, traceback):
        self._session.run(
            f"if [[ ! -z $("
            f"ps aux | grep {self.TEST_PROGRAM_NAME} | grep -v grep)"
            f" ]]; then"
            f" killall {self.TEST_PROGRAM_NAME};"
            f" fi;")
        self._session.run(f"rm /tmp/{self.TEST_PROGRAM_NAME}")

    def run_test(self, packet_size: float, duration: int, interval: float):
        # Read https://stackoverflow.com/a/29172 to understand backgrounding
        # in an ssh command.
        cmd = (f"nohup /tmp/{self.TEST_PROGRAM_NAME}"
               f" -s {packet_size}"
               f" -p {self._port}"
               f" -d {duration}"
               f" -i {interval}"
               f" > /dev/null 2>&1 &")
        self._session.run(cmd)

        packet_bytes = packet_size * 1000000

        time.sleep(1)
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            connected = False
            while not connected:
                try:
                    s.connect((self._address, self._port))
                    connected = True
                except ConnectionRefusedError as e:
                    print(e)
                    time.sleep(1)

            data_count = 0
            start = time.time()
            now = start
            packet_count = 0
            receive_times = []
            while (now - start < duration):
                if data_count >= packet_bytes:
                    receive_times.append(now)
                    packet_count += 1
                    data_count -= packet_bytes
                data_count += len(s.recv(4096))
                now = time.time()

            total_time = now - start

            return self.Results(packet_size=packet_size,
                                interval=interval,
                                duration=total_time,
                                sample_count=packet_count,
                                start_time=start,
                                receive_times=receive_times)
