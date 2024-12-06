cmake_minimum_required(VERSION 3.18)

set(CMAKE_TOOLCHAIN_FILE /usr/local/vcpkg/scripts/buildsystems/vcpkg.cmake)

project(aoc2024)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
add_compile_options(-Wall -Wextra -Wpedantic -Werror)

execute_process(COMMAND bash /workspaces/AoC2024/tools/update_aochelper.sh)

# enable ctest
include(CTest)
enable_testing()
# find Google Test
find_package(GTest CONFIG REQUIRED)

# find curlpp packages
find_package(unofficial-curlpp CONFIG REQUIRED)

# add_library AoCHelper
add_library(AoCHelper STATIC IMPORTED)
set_target_properties(AoCHelper PROPERTIES IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/../lib/AocHelper/libAoCHelper.a)
include_directories(${CMAKE_SOURCE_DIR}/../lib/AocHelper/include/)

link_libraries(AoCHelper unofficial::curlpp::curlpp)

add_subdirectory(day01)
