cmake_minimum_required(VERSION 2.8.3)
project(ovc2)
find_package(catkin REQUIRED COMPONENTS
  roscpp
  roslib
  image_transport
  camera_info_manager
  cv_bridge
  message_generation
  message_filters
)
find_package(OpenCV REQUIRED core highgui features2d)

add_message_files(FILES
  ImageCornerArray.msg
  ImageCorner.msg
  Metadata.msg
)

generate_messages(DEPENDENCIES geometry_msgs)

catkin_package(
  CATKIN_DEPENDS
    roslib
    sensor_msgs
    geometry_msgs
    roscpp
    message_runtime
    cv_bridge
    image_transport
    camera_info_manager
    message_filters
#  INCLUDE_DIRS include
#  LIBRARIES falcam
#  CATKIN_DEPENDS other_catkin_pkg
  DEPENDS OpenCV
)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall")

include_directories(${catkin_INCLUDE_DIRS})

add_library(ovc2 ovc2.cpp lightweightserial.cpp)
target_link_libraries(ovc2 ${catkin_LIBRARIES})

add_executable(ovc2_node ovc2_node.cpp)
add_dependencies(ovc2_node
  ${ovc2_EXPORTED_TARGETS}
  ${catkin_EXPORTED_TARGETS})
target_link_libraries(ovc2_node ovc2 ${catkin_LIBRARIES})

add_executable(corner_viewer corner_viewer.cpp)
target_link_libraries(corner_viewer ${catkin_LIBRARIES} ${OpenCV_LIBRARIES})
add_dependencies(corner_viewer ${ovc2_EXPORTED_TARGETS})

#############
## Install ##
#############

install(TARGETS ovc2 ovc2_node
  ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)

#install(FILES
#  firmware_blobs/ovc.periph.rbf
#  firmware_blobs/ovc.core.rbf
#  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
#)
