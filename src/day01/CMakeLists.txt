add_library(day01_lib solutions.cc)

# Add main executable
add_executable(day01 main.cc)
# Specify the directories where the compiler can find the header files
target_include_directories(day01 PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

target_link_libraries(day01 day01_lib AoCHelper)

# Add test executable
add_executable(day01_test test/unit_tests.cc)

# Specify the directories where the compiler can find the header files for the test
target_include_directories(day01_test PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

# Link test executable with Google Test
target_link_libraries(day01_test GTest::gtest GTest::gtest_main day01_lib)

# Register the test with CTest
add_test(NAME day01_test COMMAND day01_test)

