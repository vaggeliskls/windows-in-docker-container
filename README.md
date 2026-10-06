
<div align="right">
  <details>
    <summary >🌐 Language</summary>
    <div>
      <div align="center">
        <a href="https://openaitx.github.io/view.html?user=vaggeliskls&project=windows-in-docker-container&lang=en">English</a>
        | <a href="https://openaitx.github.io/view.html?user=vaggeliskls&project=windows-in-docker-container&lang=zh-CN">简体中文</a>
        | <a href="https://openaitx.github.io/view.html?user=vaggeliskls&project=windows-in-docker-container&lang=zh-TW">繁體中文</a>
        | <a href="https://openaitx.github.io/view.html?user=vaggeliskls&project=windows-in-docker-container&lang=ja">日本語</a>
        | <a href="https://openaitx.github.io/view.html?user=vaggeliskls&project=windows-in-docker-container&lang=ko">한국어</a>
        | <a href="https://openaitx.github.io/view.html?user=vaggeliskls&project=windows-in-docker-container&lang=hi">हिन्दी</a>
        | <a href="https://openaitx.github.io/view.html?user=vaggeliskls&project=windows-in-docker-container&lang=th">ไทย</a>
        | <a href="https://openaitx.github.io/view.html?user=vaggeliskls&project=windows-in-docker-container&lang=fr">Français</a>
        | <a href="https://openaitx.github.io/view.html?user=vaggeliskls&project=windows-in-docker-container&lang=de">Deutsch</a>
        | <a href="https://openaitx.github.io/view.html?user=vaggeliskls&project=windows-in-docker-container&lang=es">Español</a>
        | <a href="https://openaitx.github.io/view.html?user=vaggeliskls&project=windows-in-docker-container&lang=it">Italiano</a>
        | <a href="https://openaitx.github.io/view.html?user=vaggeliskls&project=windows-in-docker-container&lang=ru">Русский</a>
        | <a href="https://openaitx.github.io/view.html?user=vaggeliskls&project=windows-in-docker-container&lang=pt">Português</a>
        | <a href="https://openaitx.github.io/view.html?user=vaggeliskls&project=windows-in-docker-container&lang=nl">Nederlands</a>
        | <a href="https://openaitx.github.io/view.html?user=vaggeliskls&project=windows-in-docker-container&lang=pl">Polski</a>
        | <a href="https://openaitx.github.io/view.html?user=vaggeliskls&project=windows-in-docker-container&lang=ar">العربية</a>
        | <a href="https://openaitx.github.io/view.html?user=vaggeliskls&project=windows-in-docker-container&lang=fa">فارسی</a>
        | <a href="https://openaitx.github.io/view.html?user=vaggeliskls&project=windows-in-docker-container&lang=tr">Türkçe</a>
        | <a href="https://openaitx.github.io/view.html?user=vaggeliskls&project=windows-in-docker-container&lang=vi">Tiếng Việt</a>
        | <a href="https://openaitx.github.io/view.html?user=vaggeliskls&project=windows-in-docker-container&lang=id">Bahasa Indonesia</a>
        | <a href="https://openaitx.github.io/view.html?user=vaggeliskls&project=windows-in-docker-container&lang=as">অসমীয়া</
      </div>
    </div>
  </details>
</div>

# 💻 Windows in Docker Container
Discover an innovative and efficient method of deploying Windows OS (x64) on your linux system using the power of Vagrant VM, libvirt, and docker-compose. Together, these technologies help you containerize Windows OS, enabling you to manage a Windows instance just as you would any Docker container. This seamless integration into existing workflows significantly enhances convenience and optimizes resource allocation.

⭐ **Don't forget to star the project if it helped you!**

<a id="important-notice"></a>
## ⚠️ Important notice: Vagrant box registry shutting down on 31 December 2026

> [!IMPORTANT]
> HashiCorp is decommissioning the **HCP Vagrant Registry** (vagrantcloud.com, formerly Vagrant Cloud), which hosts the Windows box this image is built from. The published image is not affected. Building the image from source will need a new box location after **31 December 2026**.

| Date | What happens |
|---|---|
| 1 October 2026 | No new boxes or registries can be created |
| 2 November 2026 | End of support and maintenance |
| **31 December 2026** | **Registry decommissioned. Box downloads stop working** |

Sources: [HashiCorp announcement](https://www.hashicorp.com/blog/hcp-vagrant-deprecation-important-dates-and-migration-guidance) and the [HCP Vagrant end-of-life page](https://developer.hashicorp.com/hcp/docs/vagrant/hcp-vagrant-eol).

### What this means for you

- **Using the published image? Nothing changes.** The box `peru/windows-server-2022-standard-x64-eval` is baked into `vaggeliskls/windows-in-docker-container` at build time, and the container never contacts the registry at run time. `docker compose pull` and your existing volumes keep working.
- **Building the image yourself?** The `vagrant box add` step in the [Dockerfile](Dockerfile) downloads the box from the registry. After the shutdown, point it at a copy of the box that you host. The steps are below.

### Keep building this image: host the box yourself

1. Download the box and verify it **before 31 December 2026**:

   ```bash
   curl -L -o windows-server-2022-standard-x64-eval.box \
     "https://vagrantcloud.com/peru/boxes/windows-server-2022-standard-x64-eval/versions/20231201.01/providers/libvirt/amd64/vagrant.box"
   echo "1c9da9766bcfd1fff6b0169582a14d2c8e6397e98719e6824b711db820285301  windows-server-2022-standard-x64-eval.box" | sha256sum -c
   ```

2. Upload the file to storage you control, for example an S3 bucket, a GitHub release, or an internal web server. HashiCorp's [end-of-life page](https://developer.hashicorp.com/hcp/docs/vagrant/hcp-vagrant-eol) describes the S3 layout.

3. In the [Dockerfile](Dockerfile), replace the registry lookup with your URL:

   ```dockerfile
   ARG VAGRANT_BOX_URL=https://your-host/windows-server-2022-standard-x64-eval.box
   RUN vagrant box add --provider libvirt --name "${VAGRANT_BOX}" "${VAGRANT_BOX_URL}" && \
       vagrant init "${VAGRANT_BOX}"
   ```

Everything else, including the [Vagrantfile](Vagrantfile) provisioning and the compose files, stays the same. You can also build your own box with Packer, for example with [rgl/windows-vagrant](https://github.com/rgl/windows-vagrant), and host it the same way.

### Alternative: dockur/windows

If you would rather not host a box, [dockur/windows](https://github.com/dockur/windows) downloads the Windows installer directly from Microsoft, so it has no dependency on the Vagrant registry. The [examples/dockur](examples/dockur/) folder contains a ready-to-use compose file and an `install.bat` that sets up the same things the Vagrantfile provisions today: Chocolatey, an OpenSSH server on port 22, and long path support.

```yaml
services:
  windows:
    image: dockurr/windows
    environment:
      VERSION: "2022"        # Windows Server 2022. Use "11" for Windows 11 Pro.
      USERNAME: "vagrant"
      PASSWORD: "vagrant"
      RAM_SIZE: "8G"
      CPU_CORES: "4"
      DISK_SIZE: "100G"
    devices:
      - /dev/kvm
      - /dev/net/tun
    cap_add:
      - NET_ADMIN
    ports:
      - "8006:8006"            # web viewer, watch the install here
      - "3389:3389/tcp"
      - "3389:3389/udp"
      - "2222:22"              # SSH, enabled by install.bat
    volumes:
      - ./windows:/storage   # installed disk lives here
      - ./oem:/oem           # folder containing install.bat
    restart: always
    stop_grace_period: 2m
```

The first start downloads the ISO and installs Windows unattended, so it takes longer than booting a pre-built box. Later starts boot the installed disk directly.

## 📋 Prerequisites

Ensure your system meets the following requirements:

- **Docker:** Version 20 or higher [(Install Docker)](https://www.docker.com/)

- **Host OS:** Linux

- **Virtualization Enabled:**
  - Check with:
    - `lscpu | grep -i Virtualization`
  - Output indicates:
    - `VT-x` → Intel virtualization is supported & enabled.
    - `AMD-V` → AMD virtualization is supported & enabled.
  - If virtualization is not enabled, enable it in the BIOS/UEFI settings.

- **`cgroup: host`** in the compose file is required: libvirt and the daemons it spawns need full cgroup access, otherwise the container fails to start on cgroup v2 hosts.

## 🚀 Deployment Guide

1. Create/Update the environmental file `.env`
```
# Vagrant image settings
MEMORY=8000     # MiB (~8 GB)
CPU=4
DISK_SIZE=100   # GiB
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
3. Create `docker-compose.override.yml` when you want your VM to be persistent
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

4. Run: `docker compose up -d`

> **First boot takes several minutes** — the Vagrant box is already baked into the image, but the VM still has to boot and run the provisioning script (Chocolatey install, disk resize, registry tweaks). Follow progress with `docker compose logs -f`.

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
2. User
    - Username: vagrant
    - Password: vagrant

## ⚠️ Limitations

- **Box source shutting down** — the Vagrant registry that hosts the box closes on 31 December 2026. See the [important notice](#important-notice) at the top.
- **Linux host only** — depends on `/dev/kvm` and libvirt; macOS and Windows hosts are not supported.
- **Eval license** — the underlying box ships an evaluation copy of Windows Server 2022. Activation expires per Microsoft's eval terms.
- **No synced folders** — `rsync`, `smb`, and `nfs` are all unwired in the [Vagrantfile](Vagrantfile) (rsync needs a Windows-side install before provisioning runs; SMB synced folders aren't supported with a Linux host; in-container NFS hits `no support in current kernel`).
- **Performance** — without nested KVM available to Docker (e.g. on a cloud VM that doesn't expose KVM), the guest falls back to plain QEMU and is several times slower.

## 🔧 Troubleshooting

- **`KVM acceleration is not available`** in logs → the host isn't exposing `/dev/kvm`. Check virtualization is enabled in BIOS, the `kvm` module is loaded (`lsmod | grep kvm`), and `/dev/kvm` exists on the host. The startup script falls back to QEMU automatically; expect a large slowdown.
- **Port 3389 / 2222 already in use** → another RDP/SSH service is bound on the host. Stop it, or change the host-side port mapping in `docker-compose.yml`.
- **Container exits immediately** → almost always a cgroup or privilege problem. Confirm `privileged: true` and `cgroup: host` are set, then check `docker compose logs win10`.
- **`vagrant up` hangs at "Waiting for domain to get an IP address"** → libvirt's default NAT network isn't running. Restart the container, or run `virsh net-start default` from inside it.

## 📚 Further Reading and Resources

- [Windows Vagrant Tutorial](https://github.com/SecurityWeekly/vulhub-lab)
- [Vagrant image: peru/windows-server-2022-standard-x64-eval](https://app.vagrantup.com/peru/boxes/windows-server-2022-standard-x64-eval)
- [Vagrant by HashiCorp](https://www.vagrantup.com/)
- [Windows Virtual Machine in a Linux Docker Container](https://medium.com/axon-technologies/installing-a-windows-virtual-machine-in-a-linux-docker-container-c78e4c3f9ba1)
- [GPU inside a container](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
