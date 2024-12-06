#!/bin/bash
# dependencies: libcurl4-openssl-dev

# Usage
# generate_boilerplate "$FULL_PATH"
YEAR=2024
DAYNAME=$2

if [[ ${#DAYNAME} -eq 1 ]]; then
  TWODIGITSDAYNAME="0$DAYNAME"
else
  TWODIGITSDAYNAME="$DAYNAME"
fi

generateMainCC() {
  echo '#include "AoCHelper.h"
#include "solutions.h"
#include <iostream>

int main() {
  std::vector<std::string> exampleInput{};
  AoCHelper aocHelper{"'$YEAR'", "'$DAYNAME'"};
  auto result = aocHelper.get_input();

  std::cout << "Puzzle one: " << PartOne(result) << std::endl;
  std::cout << "Puzzle two: " << PartTwo(result) << std::endl;
    }' >>"$1"/main.cc
}

generateCMakeLists() {
  echo 'add_library(day'$TWODIGITSDAYNAME'_lib solutions.cc placeholder.cc)

# Add main executable
add_executable(day'$TWODIGITSDAYNAME' main.cc)
# Specify the directories where the compiler can find the header files
target_include_directories(day'$TWODIGITSDAYNAME' PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

target_link_libraries(day'$TWODIGITSDAYNAME' day'$TWODIGITSDAYNAME'_lib AoCHelper)

# Add test executable
add_executable(day'$TWODIGITSDAYNAME'_test test/unit_tests.cc)

# Specify the directories where the compiler can find the header files for the test
target_include_directories(day'$TWODIGITSDAYNAME'_test PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

# Link test executable with Google Test
target_link_libraries(day'$TWODIGITSDAYNAME'_test GTest::gtest GTest::gtest_main day'$TWODIGITSDAYNAME'_lib)

# Register the test with CTest
add_test(NAME day'$TWODIGITSDAYNAME'_test COMMAND day'$TWODIGITSDAYNAME'_test)' >>"$1"/CMakeLists.txt
}

generateSolutionsH() {
  echo '#pragma once

#include <string>
#include <vector>

int PartOne(const std::vector<std::string>& input);
int PartTwo(const std::vector<std::string>& input);
' >>"$1"/solutions.h
}

generateSolutionsCC() {
  echo '#include "solutions.h"
#include "placeholder.h"

int PartOne(const std::vector<std::string>& input) {
  int answer{};
  for (const auto& row : input) {
  }
  return answer;
}

int PartTwo(const std::vector<std::string>& input) {
  int answer{};
  for (const auto& row : input) {
  }
  return answer;
}' >>"$1"/solutions.cc
}

generatePlaceholderH() {
  echo '#pragma once
#include <string>

void SomeFunction();' >>"$1"/placeholder.h
}

generatePlaceholderCC() {
  echo '#include "placeholder.h"
  
  void SomeFunction() {
    return;
  }' >>"$1"/placeholder.cc
}

generateUnitTests() {
  mkdir -p "$1"/test
  echo '#include "AoCHelper.h"
#include "solutions.h"
#include "gtest/gtest.h"

class Solutions : public ::testing::Test {
protected:
  std::vector<std::string> exampleInputPartOne{};
  std::vector<std::string> exampleInputPartTwo{};

  std::function<std::vector<std::string>()> realInput = []() {
    AoCHelper aocHelper{"'$YEAR'", "'$DAYNAME'"};
    return aocHelper.get_input();
  };
};

TEST_F(Solutions, PartOneExampleData) {
  auto answer{PartOne(exampleInputPartOne)};
  EXPECT_EQ(answer, 142);
}

TEST_F(Solutions, PartOneExampleDataRowforRow) {
  std::vector<int> answers{12, 38, 15, 77};
  for (size_t i = 0; i < exampleInputPartOne.size(); i++) {
    auto answer{PartOne({exampleInputPartOne[i]})};
    EXPECT_EQ(answer, answers[i]);
  }
}
/*
TEST_F(Solutions, PartOneRealData) {
  auto answer{PartOne(realInput())};
  EXPECT_EQ(answer, 55447);
}

TEST_F(Solutions, PartTwoExampleData) {
  auto answer{PartTwo(exampleInputPartTwo)};
  EXPECT_EQ(answer, 281);
}

TEST_F(Solutions, PartTwoExampleDataRowforRow) {
  std::vector<int> answers{29, 83, 13, 24, 42, 14, 76};
  for (size_t i = 0; i < exampleInputPartTwo.size(); i++) {
    auto answer{PartTwo({exampleInputPartTwo[i]})};
    EXPECT_EQ(answer, answers[i]);
  }
}

TEST_F(Solutions, PartTwoRealData) {
  auto answer{PartTwo(realInput())};
  EXPECT_EQ(answer, 72706);
}
*/
int main(int argc, char** argv) {
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}"' >>"$1"/test/unit_tests.cc
}

addToCmakeLists() {
  # check if the build target exists already
  if grep -q "add_subdirectory(day$TWODIGITSDAYNAME)" "$1"/CMakeLists.txt; then
    echo "day$TWODIGITSDAYNAME already exists in CMakeLists.txt. Skipping..."
    return
  fi
  # verify new line at end of file
  if ! [[ $(tail -c 1 "$1"/CMakeLists.txt) == "" ]]; then
    echo "" >>"$1"/CMakeLists.txt
  fi
  echo "Adding day$TWODIGITSDAYNAME to CMakeLists.txt"
  echo "add_subdirectory(day$TWODIGITSDAYNAME)" >>"$1"/CMakeLists.txt
}

if ! [[ -d "$1/day$TWODIGITSDAYNAME" ]]; then
  echo "day$TWODIGITSDAYNAME doesn't exist on your filesystem. Generating boiler plate code..."
  FULL_PATH="$1/day$TWODIGITSDAYNAME"
  mkdir -p "$FULL_PATH"

  generateMainCC "$FULL_PATH"
  generateCMakeLists "$FULL_PATH"
  generateSolutionsH "$FULL_PATH"
  generateSolutionsCC "$FULL_PATH"
  generatePlaceholderH "$FULL_PATH"
  generatePlaceholderCC "$FULL_PATH"
  generateUnitTests "$FULL_PATH"
  addToCmakeLists "$1"

  # run all files through clang-format
  find "$FULL_PATH" -type f -name "*.cc" -exec clang-format -i {} \;
  find "$FULL_PATH" -type f -name "*.h" -exec clang-format -i {} \;
fi
