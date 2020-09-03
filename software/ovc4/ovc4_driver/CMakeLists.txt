cmake_minimum_required(VERSION 2.8.3)
project(ovc4_driver)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
set( CMAKE_EXPORT_COMPILE_COMMANDS ON )

#set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize=address")

find_package(catkin REQUIRED roscpp sensor_msgs image_transport cv_bridge)
find_package(OpenCV REQUIRED)

find_package(PkgConfig)
pkg_search_module(LIBUSB REQUIRED libusb-1.0)

find_package(ignition-msgs1 REQUIRED)
find_package(ignition-transport4 REQUIRED)

find_package(Argus REQUIRED)

include_directories(
 include
 ${OpenCV_INCLUDE_DIRS}
 ${catkin_INCLUDE_DIRS}
 ${ARGUS_INCLUDE_DIRS}
 ${LIBUSB_INCLUDE_DIRS}
 ${ignition-msgs1_INCLUDE_DIRS}
 ${ignition-transport4_INCLUDE_DIRS}
)

add_library(ovc4_driver
  src/camera.cpp
  src/usb_driver.cpp
  src/uio_driver.cpp
  src/sensor_manager.cpp
)

target_link_libraries(ovc4_driver
  ${ARGUS_LIBRARIES}
  ${LIBUSB_LIBRARIES}
  ${OpenCV_LIBRARIES}
)

# Add all the cameras
file(GLOB_RECURSE cameras_srcs "src/cameras/*.cpp")

add_library(ovc4_cameras
  ${cameras_srcs}
)

add_executable(ovc4_driver_node src/ovc4_driver_node.cpp)

target_compile_features(ovc4_driver_node PUBLIC cxx_std_17)
target_compile_features(ovc4_driver PRIVATE cxx_std_17)

target_link_libraries(ovc4_driver_node
  ${catkin_LIBRARIES}
  ${OpenCV_LIBRARIES}
  ovc4_driver
  ovc4_cameras
  ${ignition-msgs1_LIBRARIES}
  ${ignition-transport4_LIBRARIES}
)
