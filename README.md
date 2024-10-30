# BashPod

BashPod is designed to run containers using Linux primitives like namespaces and cgroups. It is written in Bash with no dependencies.


> [!WARNING]  
> BashPod is a container runtime developed for experimentation with Linux primitives. It lacks many of the security features required for production environments.

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
- [util-linux package](https://github.com/util-linux/util-linux)

## Roadmap
- Add cgroup and limits support
- Internet support 
- Persistent containers
- Support for pulling images from OCI registries 

## Resources
- [Liz Rice’s Containers from Scratch](https://www.youtube.com/watch?v=8fi7uSYlOdc)
- [Cgroup v2 Documentation](https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html)
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html#s1.1-which-shell-to-use)
