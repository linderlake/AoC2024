#include "AoCHelper.h"
#include "solutions.h"
#include "gtest/gtest.h"

class Solutions : public ::testing::Test {
protected:
  std::vector<std::string> exampleInputPartOne{};
  std::vector<std::string> exampleInputPartTwo{};

  std::function<std::vector<std::string>()> realInput = []() {
    AoCHelper a1{"2024", "1"};
    return a1.get_input();
  };
};

TEST_F(Solutions, PartOneExampleData) {
  int answer{PartOne(exampleInputPartOne)};
  EXPECT_EQ(answer, 142);
}

TEST_F(Solutions, PartOneExampleDataRowforRow) {
  std::vector<int> answers{12, 38, 15, 77};
  for (size_t i = 0; i < exampleInputPartOne.size(); i++) {
    int answer{PartOne({exampleInputPartOne[i]})};
    EXPECT_EQ(answer, answers[i]);
  }
}

TEST_F(Solutions, PartOneRealData) {
  int answer{PartOne(realInput())};
  EXPECT_EQ(answer, 55447);
}

TEST_F(Solutions, PartTwoExampleData) {
  int answer{PartTwo(exampleInputPartTwo)};
  EXPECT_EQ(answer, 281);
}

TEST_F(Solutions, PartTwoExampleDataRowforRow) {
  std::vector<int> answers{29, 83, 13, 24, 42, 14, 76};
  for (size_t i = 0; i < exampleInputPartTwo.size(); i++) {
    int answer{PartTwo({exampleInputPartTwo[i]})};
    EXPECT_EQ(answer, answers[i]);
  }
}

TEST_F(Solutions, PartTwoRealData) {
  int answer{PartTwo(realInput())};
  EXPECT_EQ(answer, 54706);
}

int main(int argc, char** argv) {
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}