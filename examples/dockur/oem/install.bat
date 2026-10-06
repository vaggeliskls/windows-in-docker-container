@echo off
rem Runs once, as a local administrator, during the first logon of the unattended install.
rem dockur copies this folder to C:\OEM and writes the output to C:\OEM\install.log.
rem Keep each PowerShell call on a single line.

echo === Installing Chocolatey ===
powershell -NoProfile -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"

rem Packages to preinstall. Uncomment or add your own.
rem call C:\ProgramData\chocolatey\bin\choco.exe install -y git

echo === Enabling OpenSSH server ===
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0; Set-Service sshd -StartupType Automatic; Start-Service sshd"
netsh advfirewall firewall add rule name="OpenSSH" dir=in action=allow protocol=TCP localport=22

echo === Enabling long paths ===
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f

rem The Vagrantfile disables the Windows firewall entirely. Uncomment to match that behaviour.
rem netsh advfirewall set allprofiles state off

echo === install.bat finished ===
