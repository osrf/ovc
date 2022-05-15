"""Manages running commands on a remote machine"""

import subprocess
from pathlib import Path

class SSHSession():
    """
    Manages a remote shell session with another machine.

    Implements a way to run commands on another machine via SSH. This does not
    circumvent security as it still requires the user to enter the system's
    credentials at runtime.
    """
    STARTUP_MSG = ("Establishing a connection with the remote machine to "
                   "collect system information and start test.")

    def __init__(self, address: str, hostname: str, port: int,
                 socket_path: Path):
        self._connection = f"{hostname}@{address}"
        self._base_ssh_command = (
            f"ssh {self._connection} -p {port} -S {socket_path}")
        self._base_scp_command = (f"scp -o ControlPath={socket_path}")

    def __enter__(self):
        # Begin master shell session when entering context.
        print(self.STARTUP_MSG)
        self.run(args=(
            f" -M"  # Set up master connection
            f" -fNT"  # Starts the socket in the background
        ))
        return self

    def __exit__(self, exit_type, value, traceback):
        # Close master session
        self.run(args=" -O exit")

    def scp(self, local_path: Path, remote_path: Path):
        cmd = (self._base_scp_command +
               f" {str(local_path)} {self._connection}:{str(remote_path)}")
        return subprocess.check_output(cmd, shell=True)

    def run(self, cmd: str = "", args: str = "") -> str:
        # If no arguments, do nothing and warn.
        if cmd == "" and args == "":
            print("SSHSession: run called with no arguments")
            return ""

        final_cmd = self._base_ssh_command
        if args != "":
            final_cmd += args

        if cmd != "":
            final_cmd += f" '{cmd}'"

        # rstrip removes the trailing newline on a command's output.
        return subprocess.check_output(final_cmd,
                                       shell=True).decode('utf-8').rstrip()

    def check_installed(self, program: str):
        return "1" in self.run(
            cmd=f"if [[ ! -z $(which {program}) ]]; then echo \"1\"; fi;")
