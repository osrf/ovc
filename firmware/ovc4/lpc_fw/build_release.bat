cmake -DCMAKE_TOOLCHAIN_FILE="armgcc.cmake" -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=release  .
mingw32-make -j4
IF "%1" == "" ( pause ) 
