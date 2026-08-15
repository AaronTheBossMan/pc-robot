#!/usr/bin/env bash
set -euo pipefail

# Minimal verification for CI: assume workspace has been built and sourced.
# Verifies packages are discoverable, the executable exists, and the minimal node runs.

ROS_DISTRO="jazzy"
WORKSPACE_DIR="$(pwd)"

echo "[verify_minimal_setup] Sourcing ROS and workspace"
# Temporarily disable nounset to avoid failing when ROS setup references unset vars
set +u
if [ -f "/opt/ros/${ROS_DISTRO}/setup.bash" ]; then
  # shellcheck disable=SC1091
  source /opt/ros/${ROS_DISTRO}/setup.bash
fi
if [ -f install/setup.bash ]; then
  # shellcheck disable=SC1091
  source install/setup.bash
fi
set -u

echo "[verify_minimal_setup] Checking for plant_robot packages"
if ros2 pkg list | grep -E "^plant_robot_(description|bringup|core)$" >/dev/null 2>&1; then
  echo "[verify_minimal_setup] Packages found"
else
  echo "[verify_minimal_setup] ERROR: expected plant_robot packages not found"
  ros2 pkg list | grep plant_robot || true
  exit 1
fi

echo "[verify_minimal_setup] Checking executables for plant_robot_core"
if ros2 pkg executables plant_robot_core >/dev/null 2>&1; then
  echo "[verify_minimal_setup] Executable found"
else
  echo "[verify_minimal_setup] ERROR: executable for plant_robot_core not found"
  ros2 pkg executables plant_robot_core || true
  exit 1
fi

echo "[verify_minimal_setup] Running minimal C++ node"
if ros2 run plant_robot_core plant_robot_node >/dev/null 2>&1; then
  echo "[verify_minimal_setup] Node ran successfully"
else
  echo "[verify_minimal_setup] ERROR: plant_robot_node failed to run"
  exit 1
fi

echo "[verify_minimal_setup] PASS"
exit 0
