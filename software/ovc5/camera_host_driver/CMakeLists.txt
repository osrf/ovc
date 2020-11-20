cmake_minimum_required(VERSION 2.8.3)
project(ovc5_host)

find_package(OpenCV REQUIRED)
find_package(Threads REQUIRED)

include_directories(
  include/
  ${OpenCV_INCLUDE_DIRS}
)

add_library(ovc5_host
  src/subscriber.cpp
)

target_link_libraries(ovc5_host ${OpenCV_LIBS})

add_executable(ovc5_host_node src/ovc5_host_driver.cpp)

target_link_libraries(ovc5_host_node
  Threads::Threads
  ${OpenCV_LIBS}
  ovc5_host
  )
