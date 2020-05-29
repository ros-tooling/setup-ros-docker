#!/bin/bash
set -euxo pipefail

apt-get update
apt-get install --no-install-recommends --quiet --yes sudo

groupadd -r rosbuild
useradd --no-log-init --create-home -r -g rosbuild rosbuild
echo "rosbuild ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo 'Etc/UTC' > /etc/timezone

apt-get update

apt-get install --no-install-recommends --quiet --yes \
    curl gnupg2 locales lsb-release

locale-gen en_US en_US.UTF-8
export LANG=en_US.UTF-8

ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

apt-get install --no-install-recommends --quiet --yes tzdata

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
    --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" \
    > /etc/apt/sources.list.d/ros-latest.list
echo "deb http://packages.ros.org/ros2/ubuntu $(lsb_release -sc) main" \
    > /etc/apt/sources.list.d/ros2-latest.list

apt-get update

DEBIAN_FRONTEND=noninteractive \
RTI_NC_LICENSE_ACCEPTED=yes \
apt-get install --no-install-recommends --quiet --yes \
    build-essential \
	clang \
	cmake \
	git \
	lcov \
	libasio-dev \
	libc++-dev \
	libc++abi-dev \
	libssl-dev \
	libtinyxml2-dev \
	python3-dev \
	python3-lark-parser \
	python3-pip \
	python3-rosdep \
	python3-vcstool \
	python3-wheel \
	rti-connext-dds-5.3.1 \
	wget

# libopensplice69 does not exist on Ubuntu 20.04, so we're attempting to
# install it, but won't fail if it does not suceed.
apt-get install --no-install-recommends --quiet --yes libopensplice69 || true

pip3 install --upgrade \
	argcomplete \
	catkin_pkg \
	colcon-bash==0.4.1 \
	colcon-cd==0.1.1 \
	colcon-cmake==0.2.16 \
	colcon-common-extensions==0.2.1 \
	colcon-core==0.4.3 \
	colcon-defaults==0.2.2 \
	colcon-lcov-result==0.2.0 \
	colcon-library-path==0.2.1 \
	colcon-metadata==0.2.2 \
	colcon-mixin==0.1.6 \
	colcon-notification==0.2.10 \
	colcon-output==0.2.6 \
	colcon-package-information==0.3.0 \
	colcon-package-selection==0.2.5 \
	colcon-parallel-executor==0.2.4 \
	colcon-pkg-config==0.1.0 \
	colcon-powershell==0.3.6 \
	colcon-python-setup-py==0.2.2 \
	colcon-recursive-crawl==0.2.0 \
	colcon-ros==0.3.13 \
	colcon-test-result==0.3.8 \
	coverage \
	cryptography \
	empy \
	flake8 \
	flake8-blind-except \
	flake8-builtins \
	flake8-class-newline \
	flake8-comprehensions \
	flake8-deprecated \
	flake8-docstrings \
	flake8-import-order \
	flake8-quotes \
	ifcfg \
	lark-parser \
	mock \
	mypy \
	nose \
	pep8 \
	pydocstyle \
	pyparsing \
	pytest \
	pytest-cov \
	pytest-mock \
	pytest-repeat \
	pytest-rerunfailures \
	pytest-runner \
	setuptools \
	wheel

rosdep init

rm -rf "/var/lib/apt/lists/*"
