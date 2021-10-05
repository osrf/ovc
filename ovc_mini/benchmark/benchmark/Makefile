CC=g++
ARM_CC=aarch64-linux-gnu-g++

local:
	mkdir -p build
	${ARM_CC} src/test_server.cpp -lpthread -o build/test_server

arm:
	mkdir -p build
	${ARM_CC} src/test_server.cpp -lpthread -o build/test_server_arm
