import launch
import launch.actions
import launch_ros.actions
import launch_testing
import launch_testing.actions
from launch import LaunchDescription


def generate_test_description():
    node = launch_ros.actions.Node(
        package='plant_robot_core',
        executable='plant_robot_node',
        output='screen'
    )

    return LaunchDescription([
        node,
        launch_testing.actions.ReadyToTest()
    ]), {'node': node}


def test_node_process_exit(proc_info, proc_output, node):
    # The C++ node is a short-lived process which should exit cleanly.
    proc_info.assertWaitForShutdown(process=node, timeout=5)
    proc_info.assertExitCodes(process=node)
