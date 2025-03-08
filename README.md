# 💻 Windows in Docker Container
Discover an innovative and efficient method of deploying Windows OS (x64) on your linux system using the power of Vagrant VM, libvirt, and docker-compose. Together, these technologies help you containerize Windows OS, enabling you to manage a Windows instance just as you would any Docker container. This seamless integration into existing workflows significantly enhances convenience and optimizes resource allocation.

⭐ **Don't forget to star the project if it helped you!**

## 📋 Prerequisites

Ensure your system meets the following requirements:

- **Docker:** Version 20 or higher [(Install Docker)](https://www.docker.com/)

- **Host OS:** Linux

- **Virtualization Enabled:**
  - Check with:
    - `grep -E -o 'vmx|svm' /proc/cpuinfo`
  - Output indicates:
    - `vmx` → Intel VT-x is supported & enabled.
    - `svm` → AMD-V is supported & enabled.
  - If virtualization is not enabled, enable it in the BIOS/UEFI settings.

## 🚀 Deployment Guide

1. Create/Update the environmental file `.env`
```
# Vagrant image settings
MEMORY=8000 # 8GB
CPU=4
DISK_SIZE=100
```
2. Create `docker-compose.yml`
```yaml
services:
  win10:
    image: docker.io/vaggeliskls/windows-in-docker-container:latest
    platform: linux/amd64
    env_file: .env
    stdin_open: true
    tty: true
    privileged: true
    cgroup: host
    restart: always
    ports:
      - 3389:3389
      - 2222:2222
```
4. Create `docker-compose.override.yml` when you want your VM to be persistent
```yaml
services:
  win10:
    volumes:
      - libvirt_data:/var/lib/libvirt
      - vagrant_data:/root/.vagrant.d
      - vagrant_project:/app/.vagrant
      - libvirt_config:/etc/libvirt

volumes:
  libvirt_data:
    name: libvirt_data
  vagrant_data:
    name: vagrant_data
  vagrant_project:
    name: vagrant_project
  libvirt_config:
    name: libvirt_config
```

5. Run: `docker compose up -d`

> When you want to destroy everything `docker compose down -v`

![windows screenshot](https://github.com/vaggeliskls/windows-in-docker-container/blob/main/images/screen-1.png?raw=true )

## 🌐 Access  

### Remote Desktop (RDP)  
For debugging or testing, you can connect to the VM using **Remote Desktop** on port `3389`.  

#### Software for Remote Desktop Access  
| OS       | Software |
|----------|----------------|
| **Linux**   | [`rdesktop`](https://github.com/rdesktop/rdesktop) → `rdesktop <ip>:3389` or [`Remmina`](https://remmina.org/) |
| **MacOS**   | [Microsoft Remote Desktop](https://apps.apple.com/us/app/microsoft-remote-desktop/id1295203466?mt=12) |
| **Windows** | Built-in **Remote Desktop Connection** |

---

### SSH   
You can connect via SSH using either the **administrator** or **Vagrant** user credentials.  
```bash
ssh <user>@<host> -p 2222
```

## 🔑 User Login
Default users based on the Vagrant image are:

1. Administrator
    - Username: Administrator
    - Password: vagrant
1. User
    - Username: vagrant
    - Password: vagrant

## 📚 Further Reading and Resources

- [Windows Vagrant Tutorial](https://github.com/SecurityWeekly/vulhub-lab)
- [Vagrant image: peru/windows-server-2022-standard-x64-eval](https://app.vagrantup.com/peru/boxes/windows-server-2022-standard-x64-eval)
- [Vagrant by HashiCorp](https://www.vagrantup.com/)
- [Windows Virtual Machine in a Linux Docker Container](https://medium.com/axon-technologies/installing-a-windows-virtual-machine-in-a-linux-docker-container-c78e4c3f9ba1)
- [GPU inside a container](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)