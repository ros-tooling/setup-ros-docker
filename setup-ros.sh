#!/bin/bash
set -euxo pipefail

readonly ROS_DISTRO=$1

apt-get update
apt-get install --no-install-recommends --quiet --yes sudo

# NOTE: this user is added for backward compatibility.
# Before the resolution of ros-tooling/setup-ros-docker#7 we used `USER rosbuild:rosbuild`
# and recommended that users of these containers run the following step in their workflow
# - run: sudo chown -R rosbuild:rosbuild "$HOME" .
# For repositories that still have this command in their workflow, they would fail if the user
# did not still exist. This user is no longer used but is just present so that command succeeds.
groupadd -r rosbuild
useradd --no-log-init --create-home -r -g rosbuild rosbuild
echo "rosbuild ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo 'Etc/UTC' > /etc/timezone

apt-get update

apt-get install --no-install-recommends --quiet --yes \
	ca-certificates curl gnupg2 locales lsb-release

locale-gen en_US en_US.UTF-8
export LANG=en_US.UTF-8

ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

apt-get install --no-install-recommends --quiet --yes tzdata

update-ca-certificates
curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

RTI_CONNEXT_DDS=""

ROS_VERSION='ros2'
case ${ROS_DISTRO} in
	"noetic")
		ROS_VERSION="ros"
		;;
	*)
		RTI_CONNEXT_DDS="rti-connext-dds-6.0.1"
		ROS_VERSION="ros2"
		;;
esac
if [ "${ROS_TESTING}" = "true" ]; then
	ROS_VERSION="${ROS_VERSION}-testing"
fi

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/${ROS_VERSION}/ubuntu $(lsb_release -sc) main" |\
	tee /etc/apt/sources.list.d/${ROS_VERSION}.list > /dev/null

apt-get update

# Required to install pip packages outside a venv with pip >=23.0.1 (older versions will ignore it)
export PIP_BREAK_SYSTEM_PACKAGES=1
UBUNTU_VERSION=$(lsb_release -cs)
case ${UBUNTU_VERSION} in
	"noble" | "jammy")
		# For 24.04 and 22.04, install using apt only
		# Basics
		apt-get install --no-install-recommends --quiet --yes \
			clang \
			lcov \
			libssl-dev \
			python3-dev
		# Core, including some extra colcon packages and flake8 plugins
		apt-get install --no-install-recommends --quiet --yes \
			ros-dev-tools \
			python3-pip \
			python3-pytest-cov \
			python3-flake8-blind-except \
			python3-flake8-class-newline \
			python3-flake8-deprecated \
			python3-pytest-repeat \
			python3-pytest-rerunfailures \
			python3-flake8-docstrings \
			python3-flake8-builtins \
			python3-flake8-comprehensions \
			python3-flake8-import-order \
			python3-flake8-quotes \
			python3-colcon-coveragepy-result \
			python3-colcon-lcov-result \
			python3-colcon-meson \
			python3-colcon-mixin
		# Fast DDS dependencies
		apt-get install --no-install-recommends --quiet --yes \
			libasio-dev \
			libtinyxml2-dev
		# RTI Connext
		DEBIAN_FRONTEND=noninteractive RTI_NC_LICENSE_ACCEPTED=yes \
			apt-get install --no-install-recommends --quiet --yes \
				${RTI_CONNEXT_DDS}
		;;
	"focal")
		# For 20.04, install with a mix of apt and pip
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
			python3-pip \
			python3-vcstool \
			python3-wheel \
			python3-rosdep \
			wget
		pip3 install --upgrade \
			argcomplete \
			catkin_pkg \
			colcon-bash==0.4.2 \
			colcon-cd==0.1.1 \
			colcon-cmake==0.2.22 \
			colcon-common-extensions==0.2.1 \
			colcon-core==0.15.1 \
			colcon-coveragepy-result==0.0.8 \
			colcon-defaults==0.2.7 \
			colcon-lcov-result==0.5.0 \
			colcon-library-path==0.2.1 \
			colcon-metadata==0.2.5 \
			colcon-mixin==0.2.2 \
			colcon-notification==0.2.15 \
			colcon-output==0.2.12 \
			colcon-package-information==0.3.3 \
			colcon-package-selection==0.2.10 \
			colcon-parallel-executor==0.2.4 \
			colcon-pkg-config==0.1.0 \
			colcon-powershell==0.3.7 \
			colcon-python-setup-py==0.2.7 \
			colcon-recursive-crawl==0.2.1 \
			colcon-ros==0.3.23 \
			colcon-test-result==0.3.8 \
			coverage \
			cryptography \
			"empy<4" \
			"flake8<3.8" \
			flake8-blind-except \
			flake8-builtins \
			flake8-class-newline \
			flake8-comprehensions \
			flake8-deprecated \
			flake8-docstrings \
			flake8-import-order \
			flake8-quotes \
			ifcfg \
			importlib-metadata==2.* \
			lark-parser \
			mock \
			mypy \
			nose \
			pep8 \
			pydocstyle \
			pytest \
			pytest-cov \
			pytest-mock \
			pytest-repeat \
			pytest-rerunfailures \
			pytest-runner \
			setuptools==58.2.0 \
			pyparsing \
			wheel
		;;
	*)
		echo "${UBUNTU_VERSION} not supported"
		exit 1
		;;
esac

rosdep init

rm -rf "/var/lib/apt/lists/*"
