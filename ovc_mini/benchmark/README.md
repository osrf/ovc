# Network Bandwidth and Reliability Testing

__NOTE__: Both client and server must have iperf3 installed before continuing.

These scripts are meant to determine the maximum usable bandwidth over a 
network connection for a variety of packet sizes. To begin, connect the 
device to be tested to the same network as your host machine. Next, run the 
following command:

```shell
./test.py username ip_address
```

The test should now run for some time. A help menu is available for more 
detailed control of the test (`./test.py -h`).

After the test is concluded, a folder labeled `output` should be in the host's 
current directory. Finally, run the processing script to generate some nice 
graphs to help visualize the data!

```shell
./process.py
```

The graphs generate one at a time for results of a given test. Close a graph 
to see results of the next test.

## Reference Material

MCS Table: https://semfionetworks.com/blog/mcs-table-updated-with-80211ax-data-rates/
