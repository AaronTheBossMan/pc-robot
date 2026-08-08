# Plant Care Robot

An autonomous robotic system designed to monitor and care for household plants.

## Goals

The robot will:

- Monitor soil moisture
- Monitor environmental conditions
- Identify plants that need attention
- Navigate between plants
- Determine when watering is necessary
- Eventually autonomously water plants

## Technology

### Software

- Ubuntu 24.04
- ROS 2 Jazzy
- Gazebo
- C++
- Python
- OpenCV
- Docker
- MQTT

### Hardware

Planned:

- ESP32
- Soil moisture sensors
- Environmental sensors
- Camera
- Mobile robot platform
- Water pump

## Architecture

The system will use ROS 2 to communicate between sensors, perception,
decision-making, and robot control components.

## Project Status

🚧 Development environment setup

Currently working on:

- [x] Ubuntu development environment
- [x] ROS 2 Jazzy
- [x] Gazebo
- [x] Nav2
- [x] SLAM Toolbox
- [x] VS Code development environment
- [ ] Simulated plant
- [ ] Soil moisture sensor
- [ ] Plant monitoring node
- [ ] Autonomous watering
- [ ] Mobile robot