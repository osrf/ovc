# Network Bandwidth and Reliability Testing

__NOTE__: Both client and server must have iperf3 installed before continuing.

These scripts are meant to determine the maximum usable bandwidth over a
network connection for a variety of packet sizes. To begin, connect the the
device to be tested to the same network as your host machine. Next, copy over
the `client_test.sh` file.

```shell
scp client_test.sh user@hostname:~/
```

Now run `server.sh` on the host machine and observe the IPs it outputs. On the
client machine, run `SERVER_ADDR=<host ip> ./client_test.sh`. The test should
now run for some time. After the test is concluded, a folder labeled `output`
should be in the client's current directory. Copy this to the host machine.

```shell
scp -r user@hostname:/path/to/output/ .
```

Finally, run the processing script to generate some nice graphs to help
visualize the data!

```shell
./process.py
```
