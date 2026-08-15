from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument
from launch.substitutions import LaunchConfiguration


def generate_launch_description():
    return LaunchDescription([
        DeclareLaunchArgument(
            'log_level',
            default_value='info',
            description='Logging level for the bringup launch file.',
        ),
    ])
