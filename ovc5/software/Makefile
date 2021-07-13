all: ovc host_driver device_driver

ovc:
	mkdir -p libovc/build
	cd libovc/build && cmake ../ && make && sudo make install

host_driver: libovc
	mkdir -p camera_host_driver/build
	cd camera_host_driver/build && cmake ../ && make

device_driver_proprietary: libovc
	mkdir -p camera_device_driver/build
	cd camera_device_driver/build && cmake ../ && make CXX_FLAGS=-DPROPRIETARY_SENSORS=1

device_driver: libovc
	mkdir -p camera_device_driver/build
	cd camera_device_driver/build && cmake ../ && make CXX_FLAGS=-DPROPRIETARY_SENSORS=0

run_host: camera_host_driver
	./camera_host_driver/build/ovc5_host_node

run_device: camera_host_driver
	./camera_device_driver/build/ovc5_driver

clean:
	cd libovc/build && make clean
	cd camera_host_driver/build && make clean
	cd camera_device_driver/build && make clean

format:
	find . -iname *.h -o -iname *.cpp -o -iname *.hpp| xargs clang-format -i
