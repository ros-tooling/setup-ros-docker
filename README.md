# setup-ros-docker

[![Build Docker image](https://github.com/ros-tooling/setup-ros-docker/workflows/Build%20Docker%20image/badge.svg)](https://github.com/ros-tooling/setup-ros-docker/actions?query=workflow%3A%22Build+Docker+image%22)

:warning: **IMPORTANT NOTE** : These images are no longer published to [Docker Hub](https://hub.docker.com/r/rostooling/setup-ros-docker) and are now only being pushed to [GHCR](https://github.com/orgs/ros-tooling/packages?repo_name=setup-ros-docker)

This repository creates base docker images for ROS development and CI workflows.
The purpose of these images is to provide a ready-to-use base development environment for building ROS projects.

The types of images created are:
* OS Base: has ROS APT repositories setup, and installed development tools to build ROS projects from source. Installs _no_ ROS packages
* [`ros-core`](https://index.ros.org/p/ros_core/github-ros2-variants/): Built on OS Base, contains the `ros-core` variant preinstalled
* [`ros-base`](https://index.ros.org/p/ros_base/github-ros2-variants/): Built on OS Base, contains the `ros-base` variant preinstalled
* [`desktop`](https://index.ros.org/p/desktop/github-ros2-variants/): Built on OS Base, contains the `desktop` variant preinstalled

The tagging structure is `setup-ros-docker/{OS-VERSION}[-{ROS-DISTRO}-{ROS-VARIANT}]`

So for example:
* ghcr.io/ros-tooling/setup-ros-docker/ubuntu-jammy
* ghcr.io/ros-tooling/setup-ros-docker/ubuntu-jammy-ros-humble-ros-base
* ghcr.io/ros-tooling/setup-ros-docker/ubuntu-focal-ros-noetic-ros-desktop

While this repository does provide those ROS variant-preinstalled images, its most useful output is the base OS images which are recommended for CI usage to allow for checking proper dependency specification and minimal-as-possible resulting images.

Note parallel work that provides similar but different environment.
https://github.com/osrf/docker_images also provides docker images with ROS variants already installed, but no "base development setup" images.


## Building ARM images

This repository does not yet provide ARM images for consumption, but it is perfectly easy to build them yourself for use.

```
docker build . \
  --platform=linux/arm64 \
  --build-arg BASE_IMAGE=ubuntu:jammy \
  --build-arg VCS_REF=$(git rev-parse HEAD) \
  --build-arg ROS_DISTRO=none \
  -t ros-tooling/setup-ros-docker/ubuntu-jammy
```
