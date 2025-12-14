# Week 5: Advanced Security and Monitoring Infrastructure

## 1. Introduction
Phase​‍​‌‍​‍‌ 5 is about automation of security verification and setting up continuous observability. I have set up sophisticated access controls (AppArmor), intrusion detection (Fail2Ban), and automatic patching. Additionally, I have written some scripts for automation of checking these controls and also for remote monitoring of system performance.

## 2. Advanced Security Implementation

### Access Control (AppArmor)
I made sure that AppArmor was running to provide **Mandatory Access Control (MAC)** enforcement. In this way, the different programs are limited to using only a small number of resources, thus lessening the possibility of damage if a particular service has been ​‍​‌‍​‍‌attacked.

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
I​‍​‌‍​‍‌ set up **Fail2Ban** to make my **SSH** service secure. **Fail2Ban** scans log files for situations where the same username or **IP** address makes a failed login attempt, and in such cases, it dynamically changes the firewall rules to forbid the IP address that caused the trouble.

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
Network isolation and cross-platform administration caused a lot of issues this week.

**1. Managing Isolated Networks:**

I run into a major mistake in the course of Fail2Ban installation: `Failed to enable unit: Unit file fail2ban.service does not exist`. The error was due to the fact that the Host-Only network, although it provides security, does not give the server the way to the package repositories. This brought out the critical point of a secure infrastructure design: strict isolation makes the system hard to maintain. To sort this out, I temporarily attached a NAT interface to perform updates and realized that maintenance windows demand dynamic network reconfiguration.

**2. The Value of Automated Auditing:**

The creation of `security-baseline.sh` file made me aware of the huge difference between manual configuration of the system and automated verification thereof. Manual checking of `ufw status` in a real-life scenario that comprises dozens of servers is not possible. The scripting of these checks by me resulted in a fully-fledged and repeatable auditing process that eliminates human error and guarantees that security baseline will always stay at the same level.

**3. Cross-Platform Administration:**

The main issue was the limitation of "Headless Administration." I work on Windows, which cannot directly run the Bash script `monitor-server.sh`. To solve this problem, I rewrote the logic in a PowerShell script (`monitor-server.ps1`). The takeaway from this incident is that system administrators must be adaptable as the server may be Linux but the management tools might need to interact with different client ​‍​‌‍​‍‌OSs..

---
[< Previous: Week 4](week4.md) | [Return to Home](index.md) | [Next: Week 6 >](week6.md)
