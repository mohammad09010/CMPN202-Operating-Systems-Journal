# Week 5: Advanced Security and Monitoring Infrastructure

## 1. Introduction
Phase 5 focuses on automating security verification and establishing continuous observability. I implemented advanced access controls (AppArmor), intrusion detection (Fail2Ban), and automatic patching. Furthermore, I developed custom scripts to automate the verification of these controls and to monitor system performance remotely.

## 2. Advanced Security Implementation

### Access Control (AppArmor)
I verified that AppArmor is active to enforce Mandatory Access Control (MAC). This restricts programs to a limited set of resources, mitigating the impact if a specific service is compromised.

![AppArmor Status](apparmor_status.png)
*Figure 1: Verification that the AppArmor module is loaded and enforcing profiles.*

### Automatic Security Updates
To address Threat T3 (Unpatched Vulnerabilities), I configured `unattended-upgrades`. This ensures the server automatically installs critical security patches without manual intervention.

![Auto Updates](auto_updates.png)
*Figure 2: Service status showing unattended-upgrades is active and running.*

### Intrusion Detection (Fail2Ban)
I installed Fail2Ban to protect the SSH service. It monitors log files for repeated failed login attempts and bans the offending IP address by updating firewall rules dynamically.

![Fail2Ban Status](fail2ban_status.png)
*Figure 3: Fail2Ban client status showing the 'sshd' jail is active.*

## 3. Automation Scripts

### Security Baseline Verification (`security-baseline.sh`)
This script resides on the server and performs a self-audit of all security configurations implemented in Weeks 4 and 5.

```bash
#!/bin/bash
# Script: security-baseline.sh
# Purpose: Verifies security configurations
# ... (See full script in repo) ...

# 1. VERIFY FIREWALL (UFW)
sudo ufw status | grep -q "Status: active"
check_status "Firewall is active" $?

# 2. VERIFY SSH HARDENING
sudo grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config
check_status "SSH Password Auth Disabled" $?
