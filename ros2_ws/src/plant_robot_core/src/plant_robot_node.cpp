#include <rclcpp/rclcpp.hpp>

int main(int argc, char **argv) {
  rclcpp::init(argc, argv);
  auto node = rclcpp::Node::make_shared("plant_robot_core_node");

  RCLCPP_INFO(node->get_logger(), "plant_robot_core initialized; scaffolding only");

  rclcpp::shutdown();
  return 0;
}
