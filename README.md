# 💻 Windows in Docker Container
A plug-and-play implementation of Windows OS (x64) based on Vagrant VM, libvirt, and docker-compose. The VM is created inside a container using Vagrant and libvirt, making the deployment of Windows OS straightforward and easy.

⭐ **Don't forget to star the project if it helped you!**

# 📋 Prerequisites

- [docker](https://www.docker.com/) >= 24
- [docker-compose](https://www.docker.com/) >= 1.18

# 🚀 Deployment Guide

1. Create/Update the environmental file `.env`
```
# Vagrant image settings
MEMORY=8000 # 8GB
CPU=4
DISK_SIZE=100
```
2. Create `docker-compose.yml`
```yaml
version: "3.9"

services:
  win10:
    image: ghcr.io/vaggeliskls/windows-in-docker-container:latest
    env_file: .env
    stdin_open: true
    tty: true
    privileged: true
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup
    ports:
      - 3389:3389
```
3. Run: `docker-compose up -d`

![windows screenshot](https://github.com/vaggeliskls/windows-in-docker-container/blob/main/images/screen-1.png?raw=true )

# 🌐 Remote Desktop
For debugging purposes or even testing, you can always connect to the VM using remote desktop software.

Software used during development:

1. Linux: rdesktop `rdesktop <ip>:3389` or [remina](https://remmina.org/)
2. MacOS: [Windows remote desktop](https://apps.apple.com/us/app/microsoft-remote-desktop/id1295203466?mt=12)
3. Windows: buildin `Remote Windows Connection` 

# 🔑 User Login
Default users based on the Vagrant image are:

1. Administrator
    - Username: Administrator
    - Password: vagrant
1. User
    - Username: vagrant
    - Password: vagrant

# 📚 References

- [Windows Vagrant Tutorial](https://github.com/SecurityWeekly/vulhub-lab)
- [Vagrant image: peru/windows-server-2022-standard-x64-eval](https://app.vagrantup.com/peru/boxes/windows-server-2022-standard-x64-eval)
- [Vagrant by HashiCorp](https://www.vagrantup.com/)
- [Windows Virtual Machine in a Linux Docker Container](https://medium.com/axon-technologies/installing-a-windows-virtual-machine-in-a-linux-docker-container-c78e4c3f9ba1)
