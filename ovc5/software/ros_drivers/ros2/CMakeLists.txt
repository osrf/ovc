cmake_minimum_required(VERSION 3.5)
project(ovc_driver_ros2)

# Default to C99
if(NOT CMAKE_C_STANDARD)
  set(CMAKE_C_STANDARD 99)
endif()

# Default to C++14
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 14)
endif()

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic -O3)
endif()

# find dependencies
find_package(ament_cmake QUIET)

if(ament_cmake_FOUND)
  find_package(rclcpp REQUIRED)
  find_package(OpenCV REQUIRED)
  find_package(cv_bridge REQUIRED)
  find_package(sensor_msgs REQUIRED)
  find_package(libovc REQUIRED)

  include_directories(
   ${OpenCV_INCLUDE_DIRS}
   ${cv_bridge_INCLUDE_DIRS}
   ${sensor_msgs_INCLUDE_DIRS}
   ${libovc_INCLUDE_DIRS}
  )

  ## Declare a C++ library
  add_library(${PROJECT_NAME}
    src/ovc_driver.cpp
  )

  ## Declare a C++ executable
  add_executable(${PROJECT_NAME}_node src/ovc_driver.cpp)
  ament_target_dependencies(${PROJECT_NAME}_node rclcpp OpenCV)
  ## Specify libraries to link a library or executable target against
  target_link_libraries(
    ${PROJECT_NAME}_node
    ${OpenCV_LIBRARIES}
    ${cv_bridge_LIBRARIES}
    ${sensor_msgs_LIBRARIES}
    ${libovc_LIBRARIES}
  )

  install(TARGETS ${PROJECT_NAME}_node DESTINATION lib/${PROJECT_NAME})

  if(BUILD_TESTING)
    find_package(ament_lint_auto REQUIRED)
    # the following line skips the linter which checks for copyrights
    # uncomment the line when a copyright and license is not present in all source files
    #set(ament_cmake_copyright_FOUND TRUE)
    # the following line skips cpplint (only works in a git repo)
    # uncomment the line when this package is not in a git repo
    #set(ament_cmake_cpplint_FOUND TRUE)
    ament_lint_auto_find_test_dependencies()
  endif()

  ament_package()
else()
  message("ament_cmake not found so skipping this package")
endif()
