# ROS-ready OCI images

[![Build Images](https://github.com/ros-tooling/setup-ros-docker/workflows/Build%20Images/badge.svg)](https://github.com/ros-tooling/setup-ros-docker/actions?query=workflow%3A%22Build+Images%22)

This repository creates base OCI (Docker) container images for ROS development and CI workflows.

These images are minimal, ready to build a ROS 2 workspace, but do not have any ROS 2 packages preinstalled.

Created tags:
  - <ghcr.io/ros-tooling/setup-ros-docker/ubuntu:focal>
  - <ghcr.io/ros-tooling/setup-ros-docker/ubuntu:jammy>
  - <ghcr.io/ros-tooling/setup-ros-docker/ubuntu:noble>
  - <ghcr.io/ros-tooling/setup-ros-docker/ubuntu:noble-testing>


## Note: Images with ROS variants

https://github.com/osrf/docker_images provides docker images with ROS variants already installed, but no "base development setup" images

https://github.com/sloretz/ros_oci_images provides the same pre-installed ROS variants, with a faster update cycle

These projects have some similarities, but a different focus from this - which is providing slim CI-focused images with no preinstalled dependencies.
