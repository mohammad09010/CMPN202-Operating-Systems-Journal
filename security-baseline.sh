#!/bin/bash
# Script Name: security-baseline.sh
# Purpose: Verifies security configurations (SSH, Firewall, Users, Fail2Ban, AppArmor)
# Author: ALAM

echo "Starting Security Baseline Verification..."

# Function to print PASS/FAIL status
# Arguments: $1 = Test Name, $2 = Exit Code (0 is Pass, anything else is Fail)
check_status() {
    if [ $2 -eq 0 ]; then
        echo -e "[PASS] $1"
    else
        echo -e "[FAIL] $1"
    fi
}

# 1. VERIFY FIREWALL (UFW)
# Check if UFW is active. 'quiet' suppresses output, returning only exit code.
sudo ufw status | grep -q "Status: active"
check_status "Firewall is active" $?

# 2. VERIFY SSH HARDENING
# Check if PasswordAuthentication is disabled in sshd_config
sudo grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config
check_status "SSH Password Auth Disabled" $?

# Check if Root Login is disabled
sudo grep -q "^PermitRootLogin no" /etc/ssh/sshd_config
check_status "SSH Root Login Disabled" $?

# 3. VERIFY FAIL2BAN
# Check if the fail2ban server process is running
pgrep -x "fail2ban-server" > /dev/null
check_status "Fail2Ban Service Running" $?

# 4. VERIFY APPARMOR
# Check if AppArmor module is loaded
sudo aa-status --enabled
check_status "AppArmor Access Control Enabled" $?

# 5. VERIFY AUTO-UPDATES
# Check if the unattended-upgrades service is active
systemctl is-active --quiet unattended-upgrades
check_status "Automatic Updates Service Active" $?

echo "Verification Complete."
