#!/usr/bin/env bash

################################################################################
#
# Plant Care Robot - Development Environment Setup
#
# Target:
#   Ubuntu 24.04 LTS (Noble Numbat)
#
# Primary stack:
#   ROS 2 Jazzy
#   Gazebo Harmonic
#   RViz2
#   Nav2
#   SLAM Toolbox
#   C++20
#   Python
#   OpenCV
#   Docker
#   PlatformIO / ESP32
#   Git
#   VS Code
#
# IMPORTANT:
#   This script is designed to be SAFE TO RE-RUN.
#
#   It:
#     - Does not reinstall packages unnecessarily
#     - Does not duplicate .bashrc entries
#     - Does not overwrite your existing workspace
#     - Does not overwrite an existing Python virtual environment
#     - Does not duplicate APT repositories
#
################################################################################

set -euo pipefail


################################################################################
# Configuration
################################################################################

ROS_DISTRO="jazzy"
WORKSPACE="$HOME/plant_robot_ws"
AI_ENV="$HOME/ai_env"

ROS_KEYRING="/usr/share/keyrings/ros-archive-keyring.gpg"
ROS_SOURCE="/etc/apt/sources.list.d/ros2.list"


################################################################################
# Helper Functions
################################################################################

install_packages()
{
    sudo apt install -y "$@"
}


append_if_missing()
{
    local LINE="$1"
    local FILE="$2"

    touch "$FILE"

    if ! grep -qxF "$LINE" "$FILE"; then
        echo "$LINE" >> "$FILE"
    fi
}


command_exists()
{
    command -v "$1" >/dev/null 2>&1
}


################################################################################
# Verify Operating System
################################################################################

echo ""
echo "=============================================="
echo "Checking operating system"
echo "=============================================="

if ! grep -q "Ubuntu 24.04" /etc/os-release; then
    echo ""
    echo "WARNING:"
    echo "This script is intended for Ubuntu 24.04 LTS."
    echo ""
    cat /etc/os-release | grep PRETTY_NAME
    echo ""
fi


################################################################################
# Update Ubuntu
################################################################################

echo ""
echo "=============================================="
echo "Updating Ubuntu"
echo "=============================================="

sudo apt update
sudo apt upgrade -y


################################################################################
# Base Development / Linux Tools
################################################################################

echo ""
echo "=============================================="
echo "Installing base Linux tools"
echo "=============================================="

install_packages \
    curl \
    wget \
    git \
    vim \
    nano \
    htop \
    tree \
    tmux \
    screen \
    net-tools \
    iputils-ping \
    openssh-client \
    unzip \
    zip \
    tar \
    gzip \
    software-properties-common \
    ca-certificates \
    gnupg \
    lsb-release \
    apt-transport-https


################################################################################
# C++ Development Tools
################################################################################

echo ""
echo "=============================================="
echo "Installing C++ development tools"
echo "=============================================="

install_packages \
    build-essential \
    cmake \
    ninja-build \
    gdb \
    lldb \
    clang \
    clang-format \
    clang-tidy \
    cppcheck \
    pkg-config


################################################################################
# Python Development Tools
################################################################################

echo ""
echo "=============================================="
echo "Installing Python development tools"
echo "=============================================="

install_packages \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    python3-numpy \
    python3-opencv


################################################################################
# Git Configuration Tools
################################################################################

echo ""
echo "=============================================="
echo "Installing Git tools"
echo "=============================================="

install_packages \
    git-lfs


################################################################################
# ROS 2 Repository
################################################################################

echo ""
echo "=============================================="
echo "Configuring ROS 2 repository"
echo "=============================================="

sudo mkdir -p /usr/share/keyrings


# Download the ROS signing key only if it doesn't already exist.
if [ ! -f "$ROS_KEYRING" ]; then

    echo "Installing ROS 2 repository key..."

    sudo curl -sSL \
        https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
        -o "$ROS_KEYRING"

fi


# Create ROS repository configuration only if it doesn't already exist.
if [ ! -f "$ROS_SOURCE" ]; then

    echo "Adding ROS 2 repository..."

    echo "deb [arch=$(dpkg --print-architecture) signed-by=$ROS_KEYRING] \
http://packages.ros.org/ros2/ubuntu \
$(. /etc/os-release && echo "$UBUNTU_CODENAME") main" \
        | sudo tee "$ROS_SOURCE" > /dev/null

else

    echo "ROS 2 repository already configured."

fi


sudo apt update


################################################################################
# ROS 2 Jazzy
################################################################################

echo ""
echo "=============================================="
echo "Installing ROS 2 Jazzy"
echo "=============================================="

install_packages \
    ros-jazzy-desktop


################################################################################
# ROS 2 Development Tools
################################################################################

echo ""
echo "=============================================="
echo "Installing ROS 2 development tools"
echo "=============================================="

install_packages \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-vcstool \
    python3-argcomplete


################################################################################
# ROS 2 Utilities
################################################################################

echo ""
echo "=============================================="
echo "Installing ROS 2 utilities"
echo "=============================================="

install_packages \
    ros-jazzy-rqt \
    ros-jazzy-rqt-common-plugins \
    ros-jazzy-rqt-graph \
    ros-jazzy-plotjuggler-ros \
    ros-jazzy-rmw-cyclonedds-cpp


################################################################################
# Gazebo
################################################################################

echo ""
echo "=============================================="
echo "Installing Gazebo integration"
echo "=============================================="

install_packages \
    ros-jazzy-ros-gz


################################################################################
# Navigation
################################################################################

echo ""
echo "=============================================="
echo "Installing Nav2"
echo "=============================================="

install_packages \
    ros-jazzy-navigation2 \
    ros-jazzy-nav2-bringup


################################################################################
# SLAM / Mapping
################################################################################

echo ""
echo "=============================================="
echo "Installing SLAM Toolbox"
echo "=============================================="

install_packages \
    ros-jazzy-slam-toolbox


################################################################################
# Robot Description / TF Tools
################################################################################

echo ""
echo "=============================================="
echo "Installing robot description tools"
echo "=============================================="

install_packages \
    ros-jazzy-xacro \
    ros-jazzy-robot-state-publisher \
    ros-jazzy-joint-state-publisher \
    ros-jazzy-joint-state-publisher-gui


################################################################################
# Computer Vision
################################################################################

echo ""
echo "=============================================="
echo "Installing computer vision libraries"
echo "=============================================="

install_packages \
    libopencv-dev


################################################################################
# Docker
################################################################################

echo ""
echo "=============================================="
echo "Installing Docker"
echo "=============================================="

install_packages \
    docker.io \
    docker-compose-v2


# Adding an existing user to an existing group is safe to repeat.
sudo usermod -aG docker "$USER"


################################################################################
# MQTT
################################################################################

echo ""
echo "=============================================="
echo "Installing MQTT"
echo "=============================================="

install_packages \
    mosquitto \
    mosquitto-clients


################################################################################
# Serial / Embedded Development Tools
################################################################################

echo ""
echo "=============================================="
echo "Installing embedded development tools"
echo "=============================================="

install_packages \
    minicom \
    picocom \
    screen


# Required for accessing ESP32/USB serial devices.
sudo usermod -aG dialout "$USER"


################################################################################
# Debugging / Networking Tools
################################################################################

echo ""
echo "=============================================="
echo "Installing debugging and networking tools"
echo "=============================================="

install_packages \
    strace \
    lsof \
    iotop \
    sysstat \
    tcpdump


################################################################################
# VS Code
################################################################################

echo ""
echo "=============================================="
echo "Installing Visual Studio Code"
echo "=============================================="

#
# Microsoft provides an official APT repository for VS Code.
#

VSCODE_KEYRING="/usr/share/keyrings/microsoft.gpg"
VSCODE_SOURCE="/etc/apt/sources.list.d/vscode.list"


if [ ! -f "$VSCODE_KEYRING" ]; then

    echo "Installing Microsoft signing key..."

    wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
        | gpg --dearmor \
        | sudo tee "$VSCODE_KEYRING" > /dev/null

fi


if [ ! -f "$VSCODE_SOURCE" ]; then

    echo "Adding Microsoft VS Code repository..."

    echo "deb [arch=$(dpkg --print-architecture) signed-by=$VSCODE_KEYRING] \
https://packages.microsoft.com/repos/code stable main" \
        | sudo tee "$VSCODE_SOURCE" > /dev/null

fi


sudo apt update

install_packages code


################################################################################
# VS Code Extensions
################################################################################

echo ""
echo "=============================================="
echo "Installing VS Code extensions"
echo "=============================================="

#
# C++ development
#

code --install-extension ms-vscode.cpptools


#
# CMake
#

code --install-extension ms-vscode.cmake-tools


#
# Python
#

code --install-extension ms-python.python


#
# Python debugging / IntelliSense
#

code --install-extension ms-python.vscode-pylance


#
# ROS
#

code --install-extension ms-iot.vscode-ros


#
# Docker
#

code --install-extension ms-azuretools.vscode-docker


#
# Git
#

code --install-extension eamodio.gitlens


#
# Embedded / ESP32 development
#

code --install-extension platformio.platformio-ide


################################################################################
# ROS Environment
################################################################################

echo ""
echo "=============================================="
echo "Configuring ROS shell environment"
echo "=============================================="

append_if_missing \
    "source /opt/ros/$ROS_DISTRO/setup.bash" \
    "$HOME/.bashrc"


################################################################################
# ROS Workspace
################################################################################

echo ""
echo "=============================================="
echo "Creating ROS workspace"
echo "=============================================="

mkdir -p "$WORKSPACE/src"

echo "ROS workspace:"
echo "  $WORKSPACE"


################################################################################
# AI Python Virtual Environment
################################################################################

echo ""
echo "=============================================="
echo "Creating AI Python environment"
echo "=============================================="

if [ ! -d "$AI_ENV" ]; then

    python3 -m venv "$AI_ENV"

    echo "Created:"
    echo "  $AI_ENV"

else

    echo "AI environment already exists:"
    echo "  $AI_ENV"

fi


################################################################################
# Optional AI Python Packages
#
# These are intentionally installed here rather than through APT.
#
# The AI environment can be activated with:
#
#     source ~/ai_env/bin/activate
#
# Then install packages as needed.
#
################################################################################

echo ""
echo "AI Python environment is ready."

echo ""
echo "To activate it:"
echo ""
echo "    source ~/ai_env/bin/activate"


################################################################################
# Final Information
################################################################################

echo ""
echo "=============================================="
echo "INSTALLATION COMPLETE"
echo "=============================================="

echo ""
echo "The following development environment has been configured:"
echo ""
echo "  Ubuntu 24.04"
echo "  ROS 2 Jazzy"
echo "  Gazebo"
echo "  RViz2"
echo "  Nav2"
echo "  SLAM Toolbox"
echo "  C++ / CMake / Ninja"
echo "  Python"
echo "  OpenCV"
echo "  Docker"
echo "  MQTT"
echo "  ESP32 serial tools"
echo "  VS Code"
echo "  ROS VS Code extension"
echo "  PlatformIO"
echo "  Git"
echo ""
echo "A reboot or logout/login is recommended."
echo ""
echo "This is required for:"
echo "  - Docker group membership"
echo "  - dialout/USB serial permissions"
echo ""
echo "=============================================="
echo "NEXT STEP"
echo "=============================================="
echo ""
echo "After logging back in, run the validation checklist"
echo "at the bottom of this script."
echo ""


################################################################################
# VALIDATION CHECKLIST
#
# Run these commands AFTER logging out and back in.
#
################################################################################
#
# ------------------------------------------------------------------------------
# 1. VERIFY UBUNTU
# ------------------------------------------------------------------------------
#
# lsb_release -a
#
# Expected:
#   Ubuntu 24.04.x LTS
#
#
# ------------------------------------------------------------------------------
# 2. VERIFY C++
# ------------------------------------------------------------------------------
#
# g++ --version
#
# cmake --version
#
# ninja --version
#
# clang --version
#
#
# ------------------------------------------------------------------------------
# 3. VERIFY GIT
# ------------------------------------------------------------------------------
#
# git --version
#
#
# ------------------------------------------------------------------------------
# 4. VERIFY ROS 2
# ------------------------------------------------------------------------------
#
# ros2 --help
#
# Expected:
#   ROS 2 command help
#
#
# ------------------------------------------------------------------------------
# 5. VERIFY ROS 2 ENVIRONMENT
# ------------------------------------------------------------------------------
#
# echo $ROS_DISTRO
#
# Expected:
#   jazzy
#
#
# ------------------------------------------------------------------------------
# 6. ROS 2 TALKER / LISTENER TEST
# ------------------------------------------------------------------------------
#
# Terminal 1:
#
# ros2 run demo_nodes_cpp talker
#
# Terminal 2:
#
# ros2 run demo_nodes_py listener
#
# Expected:
#   Messages are continuously exchanged.
#
#
# ------------------------------------------------------------------------------
# 7. VERIFY ROS GRAPH
# ------------------------------------------------------------------------------
#
# ros2 node list
#
# ros2 topic list
#
#
# ------------------------------------------------------------------------------
# 8. VERIFY RVIZ
# ------------------------------------------------------------------------------
#
# rviz2
#
# Expected:
#   RViz2 window opens.
#
#
# ------------------------------------------------------------------------------
# 9. VERIFY GAZEBO
# ------------------------------------------------------------------------------
#
# gz sim
#
# Expected:
#   Gazebo opens.
#
# NOTE:
#   If Gazebo/RViz have graphical issues inside VirtualBox, investigate
#   VirtualBox 3D acceleration and Guest Additions before changing ROS
#   configuration.
#
#
# ------------------------------------------------------------------------------
# 10. VERIFY NAV2
# ------------------------------------------------------------------------------
#
# ros2 pkg list | grep nav2
#
# Expected:
#   Multiple nav2 packages.
#
#
# ------------------------------------------------------------------------------
# 11. VERIFY SLAM TOOLBOX
# ------------------------------------------------------------------------------
#
# ros2 pkg list | grep slam_toolbox
#
# Expected:
#   slam_toolbox
#
#
# ------------------------------------------------------------------------------
# 12. VERIFY DOCKER
# ------------------------------------------------------------------------------
#
# docker --version
#
# docker compose version
#
# docker run hello-world
#
# Expected:
#   Docker hello-world output.
#
#
# If Docker says permission denied:
#
#   Log out and log back in.
#
#
# ------------------------------------------------------------------------------
# 13. VERIFY MQTT
# ------------------------------------------------------------------------------
#
# systemctl status mosquitto
#
# Expected:
#   Mosquitto service is active/running.
#
#
# ------------------------------------------------------------------------------
# 14. VERIFY SERIAL PERMISSIONS
# ------------------------------------------------------------------------------
#
# groups
#
# Expected:
#   dialout appears in the list.
#
#
# When an ESP32 is connected:
#
#   ls -l /dev/ttyUSB*
#
# or:
#
#   ls -l /dev/ttyACM*
#
#
# ------------------------------------------------------------------------------
# 15. VERIFY PYTHON
# ------------------------------------------------------------------------------
#
# python3 --version
#
# python3 -m venv --help
#
#
# ------------------------------------------------------------------------------
# 16. VERIFY AI PYTHON ENVIRONMENT
# ------------------------------------------------------------------------------
#
# source ~/ai_env/bin/activate
#
# python --version
#
# which python
#
# Expected:
#   ~/ai_env/bin/python
#
# Deactivate with:
#
#   deactivate
#
#
# ------------------------------------------------------------------------------
# 17. VERIFY VS CODE
# ------------------------------------------------------------------------------
#
# code --version
#
# Expected:
#   VS Code version information.
#
#
# ------------------------------------------------------------------------------
# 18. VERIFY VS CODE EXTENSIONS
# ------------------------------------------------------------------------------
#
# code --list-extensions
#
# Expected to include:
#
#   ms-vscode.cpptools
#   ms-vscode.cmake-tools
#   ms-python.python
#   ms-python.vscode-pylance
#   ms-iot.vscode-ros
#   ms-azuretools.vscode-docker
#   eamodio.gitlens
#   platformio.platformio-ide
#
#
# ------------------------------------------------------------------------------
# 19. VERIFY ROS WORKSPACE
# ------------------------------------------------------------------------------
#
# cd ~/plant_robot_ws
#
# colcon build
#
# Expected:
#   Summary: 0 packages finished
#
# This is normal because the workspace is currently empty.
#
#
# ------------------------------------------------------------------------------
# 20. VERIFY ROS WORKSPACE STRUCTURE
# ------------------------------------------------------------------------------
#
# tree ~/plant_robot_ws
#
# Expected:
#
#   plant_robot_ws
#   └── src
#
#
################################################################################
# END VALIDATION CHECKLIST
################################################################################


