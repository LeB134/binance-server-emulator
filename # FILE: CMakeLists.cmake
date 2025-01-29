# FILE: CMakeLists.txt
cmake_minimum_required(VERSION 3.10)
project(FindPackageHandleStandardArgsTests)

include(CTest)

# Include the FindPackageHandleStandardArgs.cmake script
include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)

# Define a function to test the find_package_handle_standard_args function
function(test_find_package_handle_standard_args)
  cmake_parse_arguments(TEST "" "NAME;ARGS;EXPECTED_FOUND" "" ${ARGN})

  # Call the find_package_handle_standard_args function
  find_package_handle_standard_args(${TEST_NAME} ${TEST_ARGS})

  # Check if the package was found as expected
  if(${TEST_NAME}_FOUND)
    set(ACTUAL_FOUND TRUE)
  else()
    set(ACTUAL_FOUND FALSE)
  endif()

  if(NOT ACTUAL_FOUND STREQUAL TEST_EXPECTED_FOUND)
    message(FATAL_ERROR "Test ${TEST_NAME} failed: expected ${TEST_EXPECTED_FOUND}, but got ${ACTUAL_FOUND}")
  endif()
endfunction()

# Test cases
add_test(NAME TestSimpleSignature
  COMMAND ${CMAKE_COMMAND} -DTEST_NAME=LibXml2 -DTEST_ARGS="DEFAULT_MSG;LIBXML2_LIBRARY;LIBXML2_INCLUDE_DIR" -DTEST_EXPECTED_FOUND=TRUE -P ${CMAKE_CURRENT_LIST_DIR}/test_find_package_handle_standard_args.cmake)

add_test(NAME TestFullSignature
  COMMAND ${CMAKE_COMMAND} -DTEST_NAME=LibArchive -DTEST_ARGS="REQUIRED_VARS;LibArchive_LIBRARY;LibArchive_INCLUDE_DIR;VERSION_VAR;LibArchive_VERSION" -DTEST_EXPECTED_FOUND=TRUE -P ${CMAKE_CURRENT_LIST_DIR}/test_find_package_handle_standard_args.cmake)

add_test(NAME TestConfigMode
  COMMAND ${CMAKE_COMMAND} -DTEST_NAME=Automoc4 -DTEST_ARGS="CONFIG_MODE" -DTEST_EXPECTED_FOUND=TRUE -P ${CMAKE_CURRENT_LIST_DIR}/test_find_package_handle_standard_args.cmake)

add_test(NAME TestMissingRequiredVars
  COMMAND ${CMAKE_COMMAND} -DTEST_NAME=MissingPackage -DTEST_ARGS="DEFAULT_MSG;MISSING_VAR" -DTEST_EXPECTED_FOUND=FALSE -P ${CMAKE_CURRENT_LIST_DIR}/test_find_package_handle_standard_args.cmake)

add_test(NAME TestVersionCheck
  COMMAND ${CMAKE_COMMAND} -DTEST_NAME=VersionedPackage -DTEST_ARGS="REQUIRED_VARS;VersionedPackage_LIBRARY;VERSION_VAR;VersionedPackage_VERSION" -DTEST_EXPECTED_FOUND=TRUE -P ${CMAKE_CURRENT_LIST_DIR}/test_find_package_handle_standard_args.cmake)