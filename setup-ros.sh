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

case $(lsb_release -sc) in
    "bionic")
        ROSDEP_APT_PACKAGE="python-rosdep"
        ;;
    *)
        ROSDEP_APT_PACKAGE="python3-rosdep"
        ;;
esac

ROS_VERSION="ros"
RTI_CONNEXT_DDS=""
case ${ROS_DISTRO} in
    "none")
		case $(lsb_release -sc) in
			"bionic")
				ROS_VERSION="ros"
				;;
			*)
				ROS_VERSION="ros2"
				;;
		esac
		;;
    "melodic" | "noetic")
		ROS_VERSION="ros"
        ;;
    *)
        RTI_CONNEXT_DDS="rti-connext-dds-6.0.1"
		ROS_VERSION="ros2"
        ;;
esac
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/${ROS_VERSION}/ubuntu $(lsb_release -sc) main" |\
  tee /etc/apt/sources.list.d/${ROS_VERSION}.list > /dev/null

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
	python3-pip \
	python3-vcstool \
	python3-wheel \
	${ROSDEP_APT_PACKAGE} \
	${RTI_CONNEXT_DDS} \
	wget

# libopensplice69 does not exist on Ubuntu 20.04, so we're attempting to
# install it, but won't fail if it does not suceed.
apt-get install --no-install-recommends --quiet --yes libopensplice69 || true

# Get the latest version of pip before installing dependencies,
# the version from apt can be very out of date (v8.0 on xenial)
# The latest version of pip doesn't support Python3.5 as of v21,
# but pip 8 doesn't understand the metadata that states this, so we must first
# make an intermediate upgrade to pip 20, which does understand that information
python3 -m pip install --upgrade pip==20.*
python3 -m pip install --upgrade pip

pip3 install --upgrade \
	argcomplete \
	catkin_pkg \
	colcon-bash==0.4.2 \
	colcon-cd==0.1.1 \
	colcon-cmake==0.2.22 \
	colcon-common-extensions==0.2.1 \
	colcon-core==0.5.9 \
	colcon-coveragepy-result==0.0.8 \
	colcon-defaults==0.2.5 \
	colcon-lcov-result==0.4.0 \
	colcon-library-path==0.2.1 \
	colcon-metadata==0.2.4 \
	colcon-mixin==0.1.8 \
	colcon-notification==0.2.13 \
	colcon-output==0.2.9 \
	colcon-package-information==0.3.3 \
	colcon-package-selection==0.2.6 \
	colcon-parallel-executor==0.2.4 \
	colcon-pkg-config==0.1.0 \
	colcon-powershell==0.3.6 \
	colcon-python-setup-py==0.2.5 \
	colcon-recursive-crawl==0.2.1 \
	colcon-ros==0.3.17 \
	colcon-test-result==0.3.8 \
	coverage \
	cryptography \
	empy \
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
