# Network Bandwidth and Reliability Testing

__NOTE__: Both client and server must have iperf3 installed before continuing.

These scripts are meant to determine the maximum usable bandwidth over a
network connection for a variety of packet sizes. To begin, connect the the
device to be tested to the same network as your host machine. Next, copy over
the `server.sh` file.

```shell
scp server.sh user@hostname:~/
```

Now run `server.sh` on the remote machine and observe the IPs it outputs. On 
the host machine, `./test.py <host ip>`. The test should now run for some time. 
After the test is concluded, a folder labeled `output` should be in the host's 
current directory.

__NOTE__: `process.py` is not yet implemented.

Finally, run the processing script to generate some nice graphs to help
visualize the data!

```shell
./process.py
```
