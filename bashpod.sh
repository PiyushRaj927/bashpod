#!/bin/env bash
# BashPod - Lightweight container runtime in Bash

set -em

# Default values
WORKDIR="/"
ROOTFS=""
CMD=""

# Function to display usage information
usage() {
	echo "Usage: bashpod.sh -r <rootfs> [-w <working_directory> (default: /)] -c <command>"
	exit 1
}

# TODO  make color output only when there is terminal and not in case of a file output redirection
# Color codes for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No color

log() {
	echo -e "[$(date +'%Y-%m-%dT%H:%M:%S%z')] ]:" "$@" >&2
}

err() {
	log "${RED}ERROR:${NC} $*" >&1
}

info() {
	log "${GREEN}INFO:${NC} $*" >&1
}

# Parse options
while getopts "r:w:c:" opt; do
	case $opt in
	r) ROOTFS="$OPTARG" ;;
	w) WORKDIR="$OPTARG" ;;
	c) CMD="$OPTARG" ;;
	*) usage ;;
	esac
done

# Ensure mandatory options are provided
if [[ -z "$ROOTFS" || -z "$CMD" ]]; then
	usage
fi

# Function to set up cgroups for resource limits
setup_cgroups() {
	CGROUP_ROOT="/sys/fs/cgroup"
	CGROUP_PATH="${CGROUP_ROOT}/bashpod"
	if [[ -d "$CGROUP_PATH" ]]; then
		info "Cgroup already exists, skipping setup."
		return 0
	fi

	info "Setting up cgroup for BashPod container..."

	mkdir "$CGROUP_PATH" || {
		err "Failed to create cgroup"
		exit 1
	}

	# Enable cpu, memory, and io controllers
	echo "+cpu +memory +io +cpuset" >"$CGROUP_ROOT/cgroup.subtree_control" || {
		err "Failed to enable cgroup controllers"
		exit 1
	}

	#TODO: currently only support of root containers is being implemented
	# Set ownership of the cgroup to the current user to manage it
	# chown -R "$(id -u):$(id -g)" "$CGROUP_PATH" || {
	#     err "Failed to set cgroup ownership"
	#     exit 1
	# }

	info "Cgroup setup completed."
}

# Function to create and run the pod (container)
create_pod() {
	info "Creating BashPod container with rootfs at $ROOTFS and working directory $WORKDIR..."

	# Check if rootfs exists
	if [[ ! -d "$ROOTFS" ]]; then
		err "Root filesystem directory $ROOTFS does not exist."
		exit 1
	fi

	# Set up the cgroup and move the current process into the cgroup
	setup_cgroups
	echo $$ >"$CGROUP_PATH/cgroup.procs" || {
		err "Failed to add process to cgroup"
		exit 1
	}

	{ unshare --pid --fork --ipc --mount --propagation private --uts --user \
		--mount-proc --mount --map-root-user --root="$ROOTFS" --wd="$WORKDIR" $CMD & } || {
		err 'Failed to create the pod'
		exit 1
	}

	info "Pod created successfully"

	fg >/dev/null
}

create_pod
