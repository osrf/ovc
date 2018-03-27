cmake_minimum_required(VERSION 3.5)
project(ovc)
if(NOT WIN32)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 -Wall -Wextra -Wpedantic")
endif()
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(sensor_msgs REQUIRED)
#find_package(OpenCV REQUIRED)

add_executable(ovc_node ovc_node.cpp ovc.cpp)
#ament_target_dependencies(v4l2_cam rclcpp sensor_msgs OpenCV)
ament_target_dependencies(ovc_node rclcpp sensor_msgs)

install(TARGETS ovc_node DESTINATION bin)

ament_package()
