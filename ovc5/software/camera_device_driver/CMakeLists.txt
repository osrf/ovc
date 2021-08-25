cmake_minimum_required(VERSION 3.10)
project(ovc5_driver)

option(PROPRIETARY_SENSORS "Whether to include proprietary sensors." 0)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -O3")

include_directories(
  include
)

add_library(ovc5_library
  src/gpio_driver.cpp
  src/i2c_driver.cpp
  src/uio_driver.cpp
  src/ethernet_driver.cpp
  src/vdma_driver.cpp
  src/sensor_manager.cpp
  src/timer_driver.cpp
)

target_compile_features(ovc5_library PUBLIC cxx_std_17)
target_compile_options(ovc5_library PUBLIC -Wall -O3)
if(PROPIETARY_SENSORS)
  target_compile_definitions(ovc5_library PUBLIC -DPROPRITARY_SENSORS)
endif()

target_link_libraries(ovc5_library
  i2c
)

# Add all the cameras
file(GLOB_RECURSE cameras_srcs "src/cameras/*.cpp")

add_library(ovc5_cameras
  ${cameras_srcs}
)

target_link_libraries(ovc5_cameras
  ovc5_library
  yaml-cpp
)

add_executable(ovc5_driver src/ovc5_driver.cpp)

target_link_libraries(ovc5_driver
  ovc5_library
  ovc5_cameras
)
