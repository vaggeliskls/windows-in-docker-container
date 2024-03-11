Vagrant.configure("2") do |config|

    config.vm.box = "peru/windows-server-2022-standard-x64-eval"
    config.vm.network "private_network", ip: "192.168.121.10"
    config.vm.network "forwarded_port", guest: 445, host: 445
    config.vm.provision "shell", inline: "Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False"
    config.vm.provider "libvirt" do |libvirt|
        libvirt.memory = ${MEMORY}
        libvirt.cpus = ${CPU}
        libvirt.machine_virtual_size = ${DISK_SIZE}
        
        # GPU passthrough prerequisites
        # 1. sudo dmesg | grep -e DMAR -e IOMMU
        # 2. virt-host-validate
        # example docker run --privileged ghcr.io/vaggeliskls/windows-in-docker-container:latest virt-host-validate
        # IOMMU appears to be disabled in kernel. Add intel_iommu=on to kernel cmdline arguments
        # https://serverfault.com/questions/1119853/error-starting-domain-unsupported-configuration-host-doesnt-support-passthrou
        # GPU passthrough
        libvirt.cpu_mode = "host-passthrough"
        libvirt.kvm_hidden = true
        # https://vagrant-libvirt.github.io/vagrant-libvirt/configuration.html#pci-device-passthrough
        # Setup for multiple GPUs if necessary
        # Replace the domain, bus, slot, and function numbers with your own by run lspci | grep NVIDIA
        # Format: [bus]:[device].[function]
        # GPU 1
        libvirt.pci :bus => '0xaf', :slot => '0x00', :function => '0x0' # VGA compatible controller
        libvirt.pci :bus => '0xaf', :slot => '0x00', :function => '0x1' # Audio device for GPU 1

    end
    config.winrm.max_tries = 300 # default is 20
    config.winrm.retry_delay = 5 #seconds. This is the defaul value and just here for documentation.
    config.vm.provision "shell", powershell_elevated_interactive: ${INTERACTIVE}, privileged: ${PRIVILEGED}, inline: <<-SHELL
        # Install Chocolatey
        Invoke-Expression "& { $(Invoke-RestMethod 'https://aka.ms/install-powershell.ps1') } -AddToPath"
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        # Resize disk
        Resize-Partition -DriveLetter "C" -Size (Get-PartitionSupportedSize -DriveLetter "C").SizeMax
        # Enable too long paths
        New-ItemProperty -Path "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force
    SHELL
end
  