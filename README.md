# setup-ros-docker

[![Build Docker image](https://github.com/ros-tooling/setup-ros-docker/workflows/Build%20Docker%20image/badge.svg)](https://github.com/ros-tooling/setup-ros-docker/actions?query=workflow%3A%22Build+Docker+image%22)

This repository creates base Docker images for ROS development and CI workflows.

The purpose of these images is to provide a ready-to-use base development environment for building ROS projects.

The types of images created are:
* OS Base: "ready to install ROS and build a workspace" - has ROS APT repositories setup and build tools installed, but no actual ROS packages installed yet
* [`ros-core`](https://index.ros.org/p/ros_core/): Built on OS Base, contains the `ros-core` variant preinstalled
* [`ros-base`](https://index.ros.org/p/ros_base/): Built on OS Base, contains the `ros-base` variant preinstalled
* [`desktop`](https://index.ros.org/p/desktop/): Built on OS Base, contains the `desktop` variant preinstalled

The tagging structure is `setup-ros-docker/{OS-VERSION}[-{ROS-DISTRO}-{ROS-VARIANT}]`

So for example:
* <ghcr.io/ros-tooling/setup-ros-docker/ubuntu-jammy>
* <ghcr.io/ros-tooling/setup-ros-docker/ubuntu-jammy-ros-humble-ros-base>
* <ghcr.io/ros-tooling/setup-ros-docker/ubuntu-focal-ros-noetic-ros-desktop>
* <ghcr.io/ros-tooling/setup-ros-docker/ubuntu-noble-testing>

While this repository does provide ROS variant-preinstalled images, its most useful output is the base OS images which are recommended for CI usage to allow for checking proper dependency specification and minimal-as-possible resulting images.

## Note: Parallel and Prior Work

https://github.com/osrf/docker_images provides docker images with ROS variants already installed, but no "base development setup" images

https://github.com/sloretz/ros_oci_images provides the same pre-installed ROS variants, with a faster update cycle

These projects have some similarities, but a different focus from this - which is providing slim CI-focused images with no preinstalled dependencies.
