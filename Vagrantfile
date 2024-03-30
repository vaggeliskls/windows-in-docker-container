Vagrant.configure("2") do |config|
    config.vm.box = "${VAGRANT_BOX}"
    config.vm.network "private_network", ip: "192.168.121.10"
    config.vm.network "forwarded_port", guest: 445, host: 445
    config.vm.provision "shell", inline: "Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False"
    config.vm.provider "libvirt" do |libvirt|
        libvirt.memory = ${MEMORY}
        libvirt.cpus = ${CPU}
        libvirt.machine_virtual_size = ${DISK_SIZE}
        libvirt.forward_ssh_port = true
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
  