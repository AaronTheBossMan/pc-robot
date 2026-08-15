from setuptools import setup

package_name = 'plant_robot_bringup'

setup(
    name=package_name,
    version='0.0.0',
    packages=[package_name],
    data_files=[
        ('share/ament_index/resource_index/packages', ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
        ('share/' + package_name + '/launch', ['launch/plant_robot_bringup.launch.py']),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='Aaron',
    maintainer_email='235968424+AaronTheBossMan@users.noreply.github.com',
    description='ROS 2 bringup package for the PC Robot project.',
    license='Apache-2.0',
    tests_require=['pytest'],
    entry_points={
    },
)
