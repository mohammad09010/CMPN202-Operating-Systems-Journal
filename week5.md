# Week 5: Advanced Security and Monitoring Infrastructure

## 1. Introduction
Phase 5 focuses on automating security verification and establishing continuous observability. I implemented advanced access controls (AppArmor), intrusion detection (Fail2Ban), and automatic patching. Furthermore, I developed custom scripts to automate the verification of these controls and to monitor system performance remotely.

## 2. Advanced Security Implementation

### Access Control (AppArmor)
I verified that AppArmor is active to enforce Mandatory Access Control (MAC). This restricts programs to a limited set of resources, mitigating the impact if a specific service is compromised.

# Update package lists
```bash
sudo apt update
# Install AppArmor utils
sudo apt install -y apparmor-utils
# Check status (Take Screenshot 1 here)
sudo aa-status
```
<img width="539" height="863" alt="image" src="https://github.com/user-attachments/assets/58696b20-ee30-46a2-b6b3-3697fdc9a9ab" />
*Verification that the AppArmor module is loaded and enforcing profiles.*

### Automatic Security Updates
To address Threat T3 (Unpatched Vulnerabilities), I configured `unattended-upgrades`. This ensures the server automatically installs critical security patches without manual intervention.

# Install the package
`sudo apt install -y unattended-upgrades`

# Enable it
```bash
sudo dpkg-reconfigure --priority=low unattended-upgrades
```
<img width="1831" height="249" alt="Screenshot 2025-12-14 085300" src="https://github.com/user-attachments/assets/ad915c56-5005-4090-a9d5-a2c9bdf2fde4" />

```bash
systemctl status unattended-upgrades --no-pager
```
<img width="919" height="193" alt="image" src="https://github.com/user-attachments/assets/ded29715-1df9-431a-a2d5-cb96c6a5f233" />
*Service status showing unattended-upgrades is active and running.*

### Intrusion Detection (Fail2Ban)
I installed Fail2Ban to protect the SSH service. It monitors log files for repeated failed login attempts and bans the offending IP address by updating firewall rules dynamically.


```bash
sudo apt install -y fail2ban
# Start and Enable the service
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```
<img width="909" height="56" alt="image" src="https://github.com/user-attachments/assets/ac046daf-f40a-493b-9787-2141ea01afa3" />

# Check status 
```bash
sudo fail2ban-client status
```
<img width="438" height="59" alt="image" src="https://github.com/user-attachments/assets/b0b05aeb-9693-437c-a2c1-4aa3bb4237ee" />
*Fail2Ban client status showing the 'sshd' jail is active.*

## 3. Automation Scripts

### Security Baseline Verification (`security-baseline.sh`)
This script resides on the server and performs a self-audit of all security configurations implemented in Weeks 4 and 5.

 ```bash
 nano security-baseline.sh
```
<img width="921" height="904" alt="image" src="https://github.com/user-attachments/assets/d5a65417-8c0a-49a1-b6fd-6c2929f8b069" />

```bash
./monitor-server.sh
```
<img width="664" height="200" alt="image" src="https://github.com/user-attachments/assets/051b21bf-a1de-4a82-b54d-6b38c2bdea72" />

## 4. Learning Reflection
This week presented significant challenges regarding network isolation and cross-platform administration.

**1. Managing Isolated Networks:**
I encountered a critical error when attempting to install Fail2Ban: `Failed to enable unit: Unit file fail2ban.service does not exist`. This occurred because the Host-Only network, while secure, prevented the server from reaching package repositories. This highlighted a key trade-off in secure infrastructure design: strict isolation complicates maintenance. I resolved this by temporarily attaching a NAT interface to perform updates, learning that maintenance windows require dynamic network reconfiguration.

**2. The Value of Automated Auditing:**
Developing the `security-baseline.sh` script shifted my perspective from "manual configuration" to "automated verification." In a professional environment with dozens of servers, manually checking `ufw status` is unscalable. By scripting these checks, I established a repeatable audit process that eliminates human error and ensures the security baseline remains consistent over time.

**3. Cross-Platform Administration:**
A major hurdle was the "Headless Administration" constraint. My workstation runs Windows, which cannot natively execute the Bash-based `monitor-server.sh` script. To overcome this, I adapted the logic into a PowerShell script (`monitor-server.ps1`). This experience demonstrated the importance of adaptability in system administration—while the server is Linux, the tools used to manage it must often interface with different client operating systems.

---
[< Previous: Week 4](week4.md) | [Return to Home](index.md) | [Next: Week 6 >](week6.md)
