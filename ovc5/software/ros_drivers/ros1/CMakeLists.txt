cmake_minimum_required(VERSION 3.0.2)
project(ovc_driver)

## Compile as C++11, supported in ROS Kinetic and newer
add_compile_options(-std=c++11 -Wall -Wextra -Wpedantic -O3)

if (catkin_FOUND)
  ## Find catkin macros and libraries
  find_package(catkin REQUIRED COMPONENTS
    roscpp
    std_msgs
    sensor_msgs
    cv_bridge
    dynamic_reconfigure
  )

  ## System dependencies are found with CMake's conventions
  find_package(OpenCV)
  find_package(libovc)

  ################################################
  ## Declare ROS dynamic reconfigure parameters ##
  ################################################

  ## To declare and build dynamic reconfigure parameters within this
  ## package, follow these steps:
  ## * In the file package.xml:
  ##   * add a build_depend and a exec_depend tag for "dynamic_reconfigure"
  ## * In this file (CMakeLists.txt):
  ##   * add "dynamic_reconfigure" to
  ##     find_package(catkin REQUIRED COMPONENTS ...)
  ##   * uncomment the "generate_dynamic_reconfigure_options" section below
  ##     and list every .cfg file to be processed

  ## Generate dynamic reconfigure parameters in the 'cfg' folder
  generate_dynamic_reconfigure_options(
    cfg/Params.cfg
  )

  ###################################
  ## catkin specific configuration ##
  ###################################
  ## The catkin_package macro generates cmake config files for your package
  ## Declare things to be passed to dependent projects
  ## INCLUDE_DIRS: uncomment this if your package contains header files
  ## LIBRARIES: libraries you create in this project that dependent projects also need
  ## CATKIN_DEPENDS: catkin_packages dependent projects also need
  ## DEPENDS: system dependencies of this project that dependent projects also need
  catkin_package(
    LIBRARIES ovc_driver
    CATKIN_DEPENDS roscpp sensor_msgs cv_bridge dynamic_reconfigure
    #DEPENDS system_lib
  )

  ###########
  ## Build ##
  ###########

  include_directories(
   ${catkin_INCLUDE_DIRS}
   ${OpenCV_INCLUDE_DIRS}
   ${libovc_INCLUDE_DIRS}
  )

  ## Declare a C++ library
  add_library(${PROJECT_NAME}
    src/ovc_driver.cpp
  )

  ## Declare a C++ executable
  add_executable(${PROJECT_NAME}_node src/ovc_driver.cpp)

  ## Rename C++ executable without prefix
  ## The above recommended prefix causes long target names, the following renames the
  ## target back to the shorter version for ease of user use
  ## e.g. "rosrun someones_pkg node" instead of "rosrun someones_pkg someones_pkg_node"
  set_target_properties(${PROJECT_NAME}_node PROPERTIES OUTPUT_NAME node PREFIX "")

  ## Add cmake target dependencies of the executable
  ## same as for the library above
  add_dependencies(
    ${PROJECT_NAME}_node
    ${PROJECT_NAME}_gencfg
    ${${PROJECT_NAME}_EXPORTED_TARGETS}
    ${catkin_EXPORTED_TARGETS}
    ${OpenCV_LIBRARIES}
    ${libovc_LIBRARIES}
  )

  ## Specify libraries to link a library or executable target against
  target_link_libraries(${PROJECT_NAME}_node
    ${PROJECT_NAME}
    ${catkin_LIBRARIES}
    ${OpenCV_LIBRARIES}
    ${libovc_LIBRARIES}
  )

  #############
  ## Install ##
  #############

  # all install targets should use catkin DESTINATION variables
  # See http://ros.org/doc/api/catkin/html/adv_user_guide/variables.html

  ## Mark executable scripts (Python etc.) for installation
  ## in contrast to setup.py, you can choose the destination
  # catkin_install_python(PROGRAMS
  #   scripts/my_python_script
  #   DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
  # )

  ## Mark executables for installation
  ## See http://docs.ros.org/melodic/api/catkin/html/howto/format1/building_executables.html
  # install(TARGETS ${PROJECT_NAME}_node
  #   RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
  # )

  ## Mark libraries for installation
  ## See http://docs.ros.org/melodic/api/catkin/html/howto/format1/building_libraries.html
  # install(TARGETS ${PROJECT_NAME}
  #   ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  #   LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  #   RUNTIME DESTINATION ${CATKIN_GLOBAL_BIN_DESTINATION}
  # )

  ## Mark cpp header files for installation
  # install(DIRECTORY include/${PROJECT_NAME}/
  #   DESTINATION ${CATKIN_PACKAGE_INCLUDE_DESTINATION}
  #   FILES_MATCHING PATTERN "*.h"
  #   PATTERN ".svn" EXCLUDE
  # )

  ## Mark other files for installation (e.g. launch and bag files, etc.)
  # install(FILES
  #   # myfile1
  #   # myfile2
  #   DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
  # )

  #############
  ## Testing ##
  #############

  ## Add gtest based cpp test target and link libraries
  # catkin_add_gtest(${PROJECT_NAME}-test test/test_ovc_driver.cpp)
  # if(TARGET ${PROJECT_NAME}-test)
  #   target_link_libraries(${PROJECT_NAME}-test ${PROJECT_NAME})
  # endif()

  ## Add folders to be run by python nosetests
  # catkin_add_nosetests(test)
else()
  message("catkin not found so skipping this package")
endif()
