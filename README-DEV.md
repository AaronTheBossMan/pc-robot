# Developer Guide

This document is for developers working on the current ROS 2 workspace for the PC Robot project. It covers the active development workflow, build commands, package layout, and the current project boundaries.

## Prerequisites

- Ubuntu 24.04
- ROS 2 Jazzy
- A standard colcon workspace layout
- A shell session with ROS 2 sourced before working in the workspace

Source ROS 2 in the current shell before building or running packages:

```bash
source /opt/ros/jazzy/setup.bash
```

If you are using a Python virtual environment for tooling, activate it only after the ROS 2 environment is sourced.

## Repository Structure

The repository root contains the project code and supporting scripts. The active ROS 2 workspace is:

```text
ros2_ws/
└── src/
```

The workspace source tree contains the foundational packages for this project:

- `plant_robot_description`: robot description package containing a simple URDF and package metadata. It is intentionally limited to describing the robot's structure and coordinate frames.
- `plant_robot_bringup`: launch/configuration package. It does not contain robot application logic or nodes.
- `plant_robot_core`: C++ ROS 2 package using ament_cmake and rclcpp. It currently contains a simple node that initializes ROS 2 and logs an initialization message only.

Core robotics functionality uses C++ because it is suited to performance-sensitive, long-lived system components and ROS 2 node implementations. Launch files and AI/ML tooling are appropriate in Python for faster iteration and tooling convenience.

## Building

From the workspace root:

```bash
cd ~/pc-robot/ros2_ws
colcon build
```

Build a specific package:

```bash
cd ~/pc-robot/ros2_ws
colcon build --packages-select plant_robot_core
```

Rebuild after changes:

```bash
cd ~/pc-robot/ros2_ws
colcon build --symlink-install
```

The symlink-install option is useful during development when you want changes to Python package files and launch files to be visible without a full reinstall step.

## Cleaning

Generated workspace artifacts can be removed safely when needed:

```bash
cd ~/pc-robot/ros2_ws
rm -rf build install log
```

Then rebuild:

```bash
colcon build
```

This removes the generated CMake/colcon output and should not affect the source files in `src/`.

## Sourcing

After building the workspace, source the workspace environment:

```bash
source /opt/ros/jazzy/setup.bash
source install/setup.bash
```

Both commands are needed: the first loads the ROS 2 base environment, and the second loads the workspace overlay created by colcon so the project packages are discoverable.

## Package Discovery

List installed ROS 2 packages:

```bash
ros2 pkg list
```

Filter to the project packages:

```bash
ros2 pkg list | grep plant_robot
```

Inspect a specific package path:

```bash
ros2 pkg prefix plant_robot_core
```

## Running

Launch the bringup package:

```bash
ros2 launch plant_robot_bringup plant_robot_bringup.launch.py
```

Run the core node (scaffold):

```bash
ros2 run plant_robot_core plant_robot_node
```

The current node is a scaffold that initializes ROS 2, logs a startup message, and exits cleanly. It does not implement robot behavior.

## Inspecting ROS Packages

List executables for a package:

```bash
ros2 pkg executables plant_robot_core
```

Print the prefix for a package:

```bash
ros2 pkg prefix plant_robot_description
```

## Testing

At this stage, the project has no substantive application tests. The current verification method is building the workspace and running the package-level checks listed in this guide.

Testing infrastructure for robot behavior, simulation, and integration will be established in future Jira stories.

## Development Workflow

Recommended workflow for day-to-day work:

1. Source ROS 2:
   ```bash
   source /opt/ros/jazzy/setup.bash
   ```
2. Navigate to the workspace:
   ```bash
   cd ~/pc-robot/ros2_ws
   ```
3. Make source changes in the relevant package under `src/`.
4. Build the workspace:
   ```bash
   colcon build
   ```
5. Source the workspace overlay:
   ```bash
   source install/setup.bash
   ```
6. Run the package or launch file you changed.
7. Check the repository status:
   ```bash
   cd ~/pc-robot
   git status --short
   ```
8. Commit the source changes only; do not commit generated build artifacts.

## Troubleshooting

Common issues:

- Package not found: source both ROS 2 and the workspace overlay.
- Command not found: ensure ROS 2 is installed and sourced, and confirm that the package was built successfully.
- Forgetting to source ROS 2: use `source /opt/ros/jazzy/setup.bash`.
- Forgetting to source the workspace: use `source install/setup.bash` after building.
- Stale build output: remove `build/`, `install/`, and `log/`, then rebuild.

## Current Limitations

The following functionality does not exist yet and is intentionally outside the scope of this story:

- no physical hardware
- no sensor implementation
- no motor control
- no navigation
- no AI
- no computer vision
- no Gazebo simulation
- no Nav2 integration
- no SLAM
- no watering logic
- no application behavior in the bringup package

These will be added in future Jira stories as the architecture evolves.
