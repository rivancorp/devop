# Configure Windows Server as an NTP Server for Cisco Devices
# Run PowerShell as Administrator

Write-Host "Configuring Windows Time Service as an NTP Server..."

# Set external NTP sources (you can change these if needed)
w32tm /config /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org time.google.com" /syncfromflags:manual /reliable:yes /update

# Enable NTP Server provider in the registry
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpServer" -Name Enabled -Value 1

# Restart Windows Time Service
Restart-Service w32time -Force

# Force time synchronization
w32tm /resync

# Allow NTP (UDP 123) through Windows Firewall
New-NetFirewallRule -Name "NTP_Server_UDP_123" `
    -DisplayName "Allow NTP Server UDP 123" `
    -Enabled True `
    -Direction Inbound `
    -Protocol UDP `
    -LocalPort 123 `
    -Action Allow

Write-Host "-----------------------------------------"
Write-Host "Windows Server is now configured as an NTP Server."
Write-Host "Use this command on Cisco devices:"
Write-Host "ntp server <Windows_Server_IP>"
Write-Host "-----------------------------------------"

# Show status
w32tm /query /status
w32tm /query /configuration
