cmake_minimum_required(VERSION 2.8.3)
project(ovc)
find_package(catkin REQUIRED COMPONENTS
  roscpp
  roslib
  image_transport
  cv_bridge
  dynamic_reconfigure
  message_generation
  message_filters
)
find_package(OpenCV REQUIRED core highgui features2d)

generate_dynamic_reconfigure_options(cfg/ovc.cfg)

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
    message_filters
#  INCLUDE_DIRS include
#  LIBRARIES falcam
#  CATKIN_DEPENDS other_catkin_pkg
  DEPENDS OpenCV
)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall")

include_directories(${catkin_INCLUDE_DIRS})

add_library(ovc ovc.cpp)
target_link_libraries(ovc ${catkin_LIBRARIES})

add_library(ovc_c ovc_c.cpp)
target_link_libraries(ovc_c ovc)

add_executable(ovc_node ovc_node.cpp)
add_dependencies(ovc_node
  ovc_gencfg 
  ${ovc_EXPORTED_TARGETS}
  ${catkin_EXPORTED_TARGETS})
target_link_libraries(ovc_node ovc ${catkin_LIBRARIES})

add_executable(test_signature test_signature.cpp)
target_link_libraries(test_signature ovc)

add_executable(corner_viewer corner_viewer.cpp)
target_link_libraries(corner_viewer ${catkin_LIBRARIES} ${OpenCV_LIBRARIES})
add_dependencies(corner_viewer ${ovc_EXPORTED_TARGETS})

add_executable(software_corner_detector software_corner_detector.cpp)
target_link_libraries(software_corner_detector ${catkin_LIBRARIES} ${OpenCV_LIBRARIES})
add_dependencies(software_corner_detector ${ovc_EXPORTED_TARGETS})

#############
## Install ##
#############

install(TARGETS ovc ovc_node
  ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)

#install(FILES
#  firmware_blobs/ovc.periph.rbf
#  firmware_blobs/ovc.core.rbf
#  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
#)
