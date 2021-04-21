all: ovc host_driver

ovc:
	mkdir -p libovc/build
	cd libovc/build && cmake ../ && make && sudo make install

host_driver: libovc
	mkdir -p camera_host_driver/build
	cd camera_host_driver/build && cmake ../ && make

run_host: camera_host_driver
	./camera_host_driver/build/ovc5_host_node
