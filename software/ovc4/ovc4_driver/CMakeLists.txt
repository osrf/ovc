cmake_minimum_required(VERSION 2.8.3)
project(ovc4_driver)

add_compile_options(-std=c++14)

find_package(catkin REQUIRED roscpp sensor_msgs)

find_package(PkgConfig)
pkg_search_module(LIBUSB REQUIRED libusb-1.0)

include_directories(
 include
 ${catkin_INCLUDE_DIRS}
 ${LIBUSB_INCLUDE_DIRS}
)

## Declare a C++ library
add_library(${PROJECT_NAME}
  src/usb_driver.cpp
  src/uio_driver.cpp
)

# Add all the cameras
file(GLOB_RECURSE cameras_srcs "src/cameras/*.cpp")

add_library(ovc4_cameras
  ${cameras_srcs}
)

add_executable(${PROJECT_NAME}_node src/ovc4_driver_node.cpp)

target_link_libraries(${PROJECT_NAME}_node
  ${catkin_LIBRARIES}
  ovc4_driver
  ovc4_cameras
  ${LIBUSB_LIBRARIES}
)
