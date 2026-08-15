#!/usr/bin/env bash

################################################################################
#
# Plant Care Robot - Development Environment Verification
#
# Target:
#   Ubuntu 24.04 LTS
#   ROS 2 Jazzy
#
# Purpose:
#   Verify that the development environment was installed correctly.
#
# IMPORTANT:
#   This script is READ-ONLY.
#   It does not install, modify, or remove anything.
#
# Exit codes:
#   0 = PASS
#   1 = FAIL
#
################################################################################

set -uo pipefail


################################################################################
# Configuration
################################################################################

ROS_DISTRO="jazzy"
WORKSPACE="$HOME/plant_robot_ws"
AI_ENV="$HOME/ai_env"

PASS_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0


################################################################################
# Colors
################################################################################

if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    BOLD='\033[1m'
    RESET='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    BOLD=''
    RESET=''
fi

################################################################################
# Helper Functions
################################################################################

pass()
{
    echo -e "  ${GREEN}[PASS]${RESET} $1"
    ((PASS_COUNT+=1))
}


fail()
{
    echo -e "  ${RED}[FAIL]${RESET} $1"
    ((FAIL_COUNT+=1))
}


warn()
{
    echo -e "  ${YELLOW}[WARN]${RESET} $1"
    ((WARN_COUNT+=1))
}


info()
{
    echo -e "  ${BLUE}[INFO]${RESET} $1"
}


section()
{
    echo ""
    echo "================================================================"
    echo -e "${BOLD}$1${RESET}"
    echo "================================================================"
}


command_exists()
{
    command -v "$1" >/dev/null 2>&1
}


package_installed()
{
    dpkg-query -W -f='${Status}' "$1" 2>/dev/null \
        | grep -q "install ok installed"
}


check_command()
{
    local COMMAND="$1"
    local DESCRIPTION="$2"

    if command_exists "$COMMAND"; then
        pass "$DESCRIPTION"
    else
        fail "$DESCRIPTION"
    fi
}


check_package()
{
    local PACKAGE="$1"
    local DESCRIPTION="$2"

    if package_installed "$PACKAGE"; then
        pass "$DESCRIPTION"
    else
        fail "$DESCRIPTION ($PACKAGE)"
    fi
}


################################################################################
# Run minimal verification (shared) if available
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -x "$SCRIPT_DIR/verify_minimal_setup.sh" ]; then
    echo ""
    echo "================================================================"
    echo "Running minimal verification (shared)"
    echo "================================================================"
    if bash "$SCRIPT_DIR/verify_minimal_setup.sh"; then
        pass "Minimal verification passed"
    else
        fail "Minimal verification failed"
    fi
fi

# Header
################################################################################

echo ""
echo "================================================================"
echo -e "${BOLD} Plant Care Robot Development Environment${RESET}"
echo -e "${BOLD} Verification Script${RESET}"
echo "================================================================"
echo ""
echo "This script checks the development environment."
echo "It does not modify your system."
echo ""


################################################################################
# 1. Operating System
################################################################################

section "1. Operating System"


if grep -q "Ubuntu 24.04" /etc/os-release; then
    pass "Ubuntu 24.04 detected"
else
    fail "Ubuntu 24.04 detected"
fi


if grep -q "VERSION_CODENAME=noble" /etc/os-release; then
    pass "Ubuntu codename is noble"
else
    fail "Ubuntu codename is noble"
fi


################################################################################
# 2. Basic Development Tools
################################################################################

section "2. Basic Development Tools"


check_command "git" "Git installed"
check_command "vim" "Vim installed"
check_command "tree" "Tree installed"
check_command "tmux" "tmux installed"
check_command "curl" "curl installed"
check_command "wget" "wget installed"


################################################################################
# 3. C++ Toolchain
################################################################################

section "3. C++ Development Environment"


check_command "g++" "G++ installed"
check_command "gcc" "GCC installed"
check_command "cmake" "CMake installed"
check_command "ninja" "Ninja installed"
check_command "gdb" "GDB installed"
check_command "clang" "Clang installed"
check_command "clang-format" "clang-format installed"
check_command "clang-tidy" "clang-tidy installed"
check_command "cppcheck" "cppcheck installed"


################################################################################
# 4. Python
################################################################################

section "4. Python Development Environment"


check_command "python3" "Python 3 installed"
check_command "pip3" "pip3 installed"


if python3 -m venv --help >/dev/null 2>&1; then
    pass "Python virtual environment support installed"
else
    fail "Python virtual environment support installed"
fi


################################################################################
# 5. ROS 2
################################################################################

section "5. ROS 2 Jazzy"


if [ -f "/opt/ros/$ROS_DISTRO/setup.bash" ]; then
    pass "ROS 2 Jazzy installation found"
else
    fail "ROS 2 Jazzy installation found"
fi


if command_exists ros2; then
    pass "ros2 command available"
else
    fail "ros2 command available"
fi


if [ "${ROS_DISTRO:-}" = "$ROS_DISTRO" ]; then
    pass "ROS_DISTRO is set to $ROS_DISTRO"
else
    fail "ROS_DISTRO is set to $ROS_DISTRO"
fi


################################################################################
# 6. ROS 2 Packages
################################################################################

section "6. ROS 2 Packages"


check_package \
    "ros-jazzy-desktop" \
    "ROS 2 Desktop installed"


check_package \
    "python3-colcon-common-extensions" \
    "colcon extensions installed"


check_package \
    "python3-rosdep" \
    "rosdep installed"


check_package \
    "python3-vcstool" \
    "vcstool installed"


check_package \
    "ros-jazzy-rqt" \
    "rqt installed"


check_package \
    "ros-jazzy-rqt-graph" \
    "rqt graph installed"


################################################################################
# 7. Gazebo
################################################################################

section "7. Gazebo"


if command_exists gz; then
    pass "Gazebo command (gz) available"
else
    fail "Gazebo command (gz) available"
fi


check_package \
    "ros-jazzy-ros-gz" \
    "ROS/Gazebo integration installed"


################################################################################
# 8. Navigation
################################################################################

section "8. Navigation / SLAM"


check_package \
    "ros-jazzy-navigation2" \
    "Nav2 installed"


check_package \
    "ros-jazzy-nav2-bringup" \
    "Nav2 bringup installed"


check_package \
    "ros-jazzy-slam-toolbox" \
    "SLAM Toolbox installed"


################################################################################
# 9. Robot Description / TF
################################################################################

section "9. Robot Description"


check_package \
    "ros-jazzy-xacro" \
    "Xacro installed"


check_package \
    "ros-jazzy-robot-state-publisher" \
    "Robot State Publisher installed"


check_package \
    "ros-jazzy-joint-state-publisher" \
    "Joint State Publisher installed"


################################################################################
# 10. OpenCV
################################################################################

section "10. Computer Vision"


check_package \
    "libopencv-dev" \
    "OpenCV development libraries installed"


if python3 -c "import cv2" >/dev/null 2>&1; then
    pass "Python OpenCV available"
else
    fail "Python OpenCV available"
fi


################################################################################
# 11. Docker
################################################################################

section "11. Docker"


check_command "docker" "Docker installed"


if docker info >/dev/null 2>&1; then
    pass "Docker daemon accessible"
else

    if groups "$USER" | grep -qw docker; then
        warn "Docker installed, but current session cannot access Docker"
        info "You may need to log out and log back in."
    else
        fail "Docker daemon accessible"
    fi

fi


if command_exists docker-compose; then
    pass "Docker Compose available"
elif docker compose version >/dev/null 2>&1; then
    pass "Docker Compose available"
else
    fail "Docker Compose available"
fi


################################################################################
# 12. MQTT
################################################################################

section "12. MQTT"


check_package \
    "mosquitto" \
    "Mosquitto installed"


check_package \
    "mosquitto-clients" \
    "Mosquitto client tools installed"


if systemctl is-enabled mosquitto >/dev/null 2>&1; then
    pass "Mosquitto service enabled"
else
    warn "Mosquitto service is not enabled"
fi


################################################################################
# 13. Serial / ESP32 Development
################################################################################

section "13. Embedded / ESP32 Support"


check_command "minicom" "minicom installed"
check_command "picocom" "picocom installed"
check_command "screen" "screen installed"


if groups "$USER" | grep -qw dialout; then
    pass "User belongs to dialout group"
else
    fail "User belongs to dialout group"
fi


################################################################################
# 14. VS Code
################################################################################

section "14. Visual Studio Code"


check_command "code" "VS Code installed"


if command_exists code; then

    EXTENSIONS=(
        "ms-vscode.cpptools"
        "ms-vscode.cmake-tools"
        "ms-python.python"
        "ms-python.vscode-pylance"
        "ms-iot.vscode-ros"
        "ms-azuretools.vscode-docker"
        "eamodio.gitlens"
        "platformio.platformio-ide"
    )

    for EXTENSION in "${EXTENSIONS[@]}"; do

        if code --list-extensions 2>/dev/null \
            | grep -qx "$EXTENSION"; then

            pass "VS Code extension installed: $EXTENSION"

        else

            fail "VS Code extension installed: $EXTENSION"

        fi

    done

fi


################################################################################
# 15. ROS Workspace
################################################################################

section "15. ROS Workspace"


if [ -d "$WORKSPACE" ]; then
    pass "ROS workspace exists: $WORKSPACE"
else
    fail "ROS workspace exists: $WORKSPACE"
fi


if [ -d "$WORKSPACE/src" ]; then
    pass "ROS workspace src directory exists"
else
    fail "ROS workspace src directory exists"
fi


################################################################################
# 16. AI Python Environment
################################################################################

section "16. AI Python Environment"


if [ -f "$AI_ENV/bin/python" ]; then

    pass "AI Python virtual environment exists"

    AI_VERSION=$("$AI_ENV/bin/python" --version 2>&1)

    info "AI environment Python: $AI_VERSION"

else

    fail "AI Python virtual environment exists"

fi


################################################################################
# 17. ROS Functional Test
################################################################################

section "17. ROS Functional Test"


if command_exists ros2; then

    info "Starting ROS 2 demo publisher..."

    TEMP_DIR=$(mktemp -d)
    TALKER_LOG="$TEMP_DIR/talker.log"

    timeout 5s ros2 run demo_nodes_cpp talker \
        > "$TALKER_LOG" 2>&1 || true

    if grep -q "Publishing" "$TALKER_LOG"; then
        pass "ROS 2 C++ publisher successfully executed"
    else
        fail "ROS 2 C++ publisher successfully executed"
        info "Output:"
        cat "$TALKER_LOG"
    fi

    rm -rf "$TEMP_DIR"

else

    fail "ROS functional test skipped because ros2 is unavailable"

fi


################################################################################
# 18. ROS Environment in .bashrc
################################################################################

section "18. Shell Configuration"


if grep -q "source /opt/ros/jazzy/setup.bash" "$HOME/.bashrc"; then
    pass "ROS 2 is configured in .bashrc"
else
    fail "ROS 2 is configured in .bashrc"
fi

if grep -q "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" "$HOME/.bashrc"; then
    pass "colcon bash completion is configured in .bashrc"
else
    fail "colcon bash completion is configured in .bashrc"
fi

if grep -q "source /usr/share/colcon_cd/function/colcon_cd.sh" "$HOME/.bashrc"; then
    pass "colcon_cd is configured in .bashrc"
else
    fail "colcon_cd is configured in .bashrc"
fi

if grep -Eq 'export _colcon_cd_root=.*plant_robot_ws' "$HOME/.bashrc"; then
    pass "colcon_cd workspace root is configured in .bashrc"
else
    fail "colcon_cd workspace root is configured in .bashrc"
fi


################################################################################
# 19. colcon shell functionality
################################################################################

section "19. colcon shell functionality"

if [ -f "/usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" ] \
    && [ -f "/usr/share/colcon_cd/function/colcon_cd.sh" ]; then

    if bash -lc 'source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash >/dev/null 2>&1; source /usr/share/colcon_cd/function/colcon_cd.sh >/dev/null 2>&1; complete -p colcon >/dev/null 2>&1 && command -v colcon_cd >/dev/null 2>&1'; then
        pass "colcon completion and colcon_cd are active in bash"
    else
        fail "colcon completion and colcon_cd are active in bash"
    fi

else
    fail "colcon completion and colcon_cd are active in bash"
fi

################################################################################
# 20. ROS Package Discovery
################################################################################

section "20. ROS Package Discovery"


if command_exists ros2; then

    #
    # Use `ros2 pkg prefix` rather than grep against `ros2 pkg list`.
    #
    # This asks the ROS package system itself to locate the package.
    #

    if ros2 pkg prefix nav2_bringup >/dev/null 2>&1; then
        pass "ROS can discover Nav2"
    else
        fail "ROS can discover Nav2"
    fi


    if ros2 pkg prefix slam_toolbox >/dev/null 2>&1; then
        pass "ROS can discover SLAM Toolbox"
    else
        fail "ROS can discover SLAM Toolbox"
    fi


    if ros2 pkg prefix robot_state_publisher >/dev/null 2>&1; then
        pass "ROS can discover Robot State Publisher"
    else
        fail "ROS can discover Robot State Publisher"
    fi


else

    fail "ROS package discovery skipped because ros2 is unavailable"

fi

################################################################################
# Summary
################################################################################

section "VERIFICATION SUMMARY"


TOTAL=$((PASS_COUNT + FAIL_COUNT))

echo ""
echo -e "  ${GREEN}PASSED:${RESET}   $PASS_COUNT"
echo -e "  ${RED}FAILED:${RESET}   $FAIL_COUNT"
echo -e "  ${YELLOW}WARNINGS:${RESET} $WARN_COUNT"
echo ""


if [ "$FAIL_COUNT" -eq 0 ]; then

    echo "================================================================"
    echo -e "${GREEN}${BOLD}                         PASS${RESET}"
    echo "================================================================"
    echo ""
    echo "Your Plant Care Robot development environment"
    echo "passed all required verification checks."
    echo ""

    if [ "$WARN_COUNT" -gt 0 ]; then
        echo "There are $WARN_COUNT warning(s), but no required"
        echo "components failed verification."
        echo ""
    fi

    echo "You are ready to begin development."
    echo ""

    exit 0

else

    echo "================================================================"
    echo -e "${RED}${BOLD}                         FAIL${RESET}"
    echo "================================================================"
    echo ""
    echo "$FAIL_COUNT verification check(s) failed."
    echo ""
    echo "Review the [FAIL] entries above."
    echo ""

    exit 1

fi

