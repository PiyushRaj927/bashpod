# BashPod

BashPod is designed to run containers using Linux primitives such as namespaces and cgroups. It is written in Bash with no dependencies.

## Features
- Process isolation using Linux namespaces.
- Resource control through cgroups.
- Minimal dependencies, leveraging standard Linux tools.

## Usage

```bash
bashpod -r <rootfs> [-w <working_directory>] -c <command>
```

- **`-r <rootfs>`**: Specifies the root filesystem for the container.
- **`-w <working_directory>`**: (Optional) Set the working directory. Default is `/`.
- **`-c <command>`**: Command to run inside the container.

## Example

```bash
bashpod -r /path/to/rootfs -c "/bin/bash"
```

This runs a Bash shell in an isolated environment using the specified root filesystem.

## Requirements
- Bash
- Linux with support for namespaces and cgroups
