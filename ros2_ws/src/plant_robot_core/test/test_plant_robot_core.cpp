#include <gtest/gtest.h>
#include <rclcpp/rclcpp.hpp>

TEST(PlantRobotCoreTest, NodeInitialization) {
  // Ensure rclcpp can initialize and create a node
  rclcpp::init(0, nullptr);
  auto node = rclcpp::Node::make_shared("test_node");
  ASSERT_NE(node, nullptr);
  EXPECT_STREQ(node->get_name(), "test_node");
  rclcpp::shutdown();
}

int main(int argc, char **argv) {
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
