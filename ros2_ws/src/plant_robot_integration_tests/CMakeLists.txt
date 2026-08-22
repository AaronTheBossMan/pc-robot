cmake_minimum_required(VERSION 3.16)
project(plant_robot_integration_tests LANGUAGES C)

find_package(ament_cmake REQUIRED)

if(BUILD_TESTING)
  find_package(ament_cmake_pytest REQUIRED)
  find_package(launch REQUIRED)
  find_package(launch_ros REQUIRED)
  find_package(launch_testing REQUIRED)
  find_package(launch_testing_ros REQUIRED)

  ament_add_pytest_test(test_integration test test/test_integration.py)
endif()

ament_package()
