all: ovc host_driver device_driver

ovc:
	mkdir -p libovc/build
	cd libovc/build && cmake ../ && make && sudo make install

host_driver: libovc
	mkdir -p camera_host_driver/build
	cd camera_host_driver/build && cmake ../ && make

device_driver: libovc
	mkdir -p camera_device_driver/build
	cd camera_device_driver/build && cmake ../ && make

run_host: camera_host_driver
	./camera_host_driver/build/ovc5_host_node

clean:
	cd libovc/build && make clean
	cd camera_host_driver/build && make clean
	cd camera_device_driver/build && make clean
