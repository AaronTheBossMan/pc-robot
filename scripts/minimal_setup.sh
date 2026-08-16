#!/usr/bin/env bash
set -euo pipefail

# Minimal, non-interactive ROS 2 setup for CI and lightweight developer environments
# - Configures ROS 2 apt repository
# - Installs ros-jazzy-ros-base and minimal build tooling
# - Installs rosdep and colcon extensions

ROS_DISTRO="jazzy"

echo "[minimal_setup] Setting up ROS 2 apt repository and installing minimal packages"

sudo apt-get update
sudo apt-get install -y curl gnupg lsb-release ca-certificates
sudo mkdir -p /etc/apt/keyrings

if [ ! -f /etc/apt/keyrings/ros-archive-keyring.gpg ]; then
  curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
    | sudo gpg --dearmor -o /etc/apt/keyrings/ros-archive-keyring.gpg
fi

if [ ! -f /etc/apt/sources.list.d/ros2.list ]; then
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" \
    | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
fi

sudo apt-get update

echo "[minimal_setup] Installing minimal ROS and build tools"
sudo apt-get install -y \
  ros-${ROS_DISTRO}-ros-base \
  python3-rosdep \
  python3-colcon-common-extensions \
  python3-pip \
  build-essential \
  cmake

echo "[minimal_setup] Initializing rosdep"
sudo rosdep init || true
rosdep update

echo "[minimal_setup] Done"
