CC=aarch64-linux-gnu-g++

SRCS= \
	src/main.cpp \
	src/ar0234.cpp \
	src/i2c_driver.cpp

SYSROOT=../firmware/bsp/build-ovc/tmp/sysroots/qsxp-ml81-ovc

main:
	mkdir -p build
	${CC} ${SRCS} --sysroot=${SYSROOT} \
		-I include/ -o build/test --std=c++17 -li2c
