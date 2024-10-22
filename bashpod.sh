#!/bin/env bash

# set -x

# Default values
ROOTFS=""
WORKDIR="/"
CMD=""

# Function to display usage information
usage() {
    echo "Usage: bashpod.sh -r <rootfs> [-w <working_directory> (default: /)] -c <command>"
    exit 1
}

# Parse options
while getopts "r:u:w:c:" opt; do
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

# Set up a cgroup named "my_cgroup" under /sys/fs/cgroup/
CGROUP_PATH="/sys/fs/cgroup/my_cgroup/"

# Create the new cgroup
if [ ! -d "$CGROUP_PATH" ]; then
    mkdir "$CGROUP_PATH"
fi

# echo $CPU_LIMIT > "$CGROUP_PATH/cpu.max"

echo $$ >"$CGROUP_PATH/cgroup.procs"
echo "10M" >/sys/fs/cgroup/my_cgroup/memory.max

# Execute unshare with the provided options
unshare --pid --fork --ipc --mount --uts --user --kill-child --map-root-user --cgroup --mount-proc --mount \
    --root="$ROOTFS" \
    --wd="$WORKDIR" \
    $CMD
