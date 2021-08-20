cmake_minimum_required(VERSION 2.8.3)
project(ovc5_host)

set(CMAKE_CXX_FLAGS "-Wall -Wextra -O3")

find_package(OpenCV REQUIRED)
find_package(libovc REQUIRED)
find_package(jsoncpp REQUIRED)

include_directories(
  include/
  ${OpenCV_INCLUDE_DIRS}
  ${libovc_INCLUDE_DIRS}
)

add_library(ovc5_host
  src/ovc5_host_driver.cpp
)

add_executable(ovc5_host_node src/ovc5_host_driver.cpp)

target_link_libraries(${PROJECT_NAME}_node
  ${PROJECT_NAME}
  ${OpenCV_LIBS}
  ${libovc_LIBRARIES}
  jsoncpp
)
