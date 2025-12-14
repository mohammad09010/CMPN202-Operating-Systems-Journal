# Week 7: Security Audit and System Evaluation

## 1. Introduction
Phase 7 concludes the project with a comprehensive security audit. Using industry-standard tools (`Lynis` and `Nmap`), I evaluated the security posture of the server, remediated identified vulnerabilities, and documented the final system configuration.

## 2. Infrastructure Security Assessment (Lynis)
I performed a system auditing scan using **Lynis**.

### Initial Scan (Before Remediation)
The initial scan identified several warnings, primarily related to missing legal banners and filesystem hardening.
* **Initial Hardening Index:** 64
```bash
sudo apt update
sudo apt install -y lynis nmap net-tools
sudo lynis audit system --quick
```
<img width="727" height="557" alt="image" src="https://github.com/user-attachments/assets/f67a4819-e119-4cd6-92ae-b943aa0e47f0" />

### Remediation Actions
Based on the Lynis suggestions, I implemented high-impact hardening measures:
1.  **File Integrity Monitoring:** Installed `debsums` to verify package checksums and detect unauthorized file modifications.
   
2.  **Hardware Hardening:** Disabled the `usb-storage` kernel module to prevent physical data exfiltration, as this is a headless cloud server.

```bash
sudo apt install -y debsums libpam-tmpdir
echo "blacklist usb-storage" | sudo tee /etc/modprobe.d/usb-storage.conf
```
<img width="772" height="817" alt="image" src="https://github.com/user-attachments/assets/93fdb8ea-33c0-4530-abda-cd4c62e09ee3" />

3.  **Legal Banners:** Configured `/etc/issue.net` to display authorized access warnings.

```bash
sudo update-initramfs -u
```
<img width="541" height="53" alt="image" src="https://github.com/user-attachments/assets/5c867ab4-2b0d-4cc3-9f8d-bf7a835ba4c6" />

### Final Scan (After Remediation)
After applying the fixes, the hardening index improved, demonstrating a tangible increase in system security.
* **Final Hardening Index:** 65
<img width="940" height="672" alt="image" src="https://github.com/user-attachments/assets/9fad46c1-0beb-4433-812b-b93260441971" />

*Improved Lynis security score following remediation.*

## 3. Network Security Assessment (Nmap)
I conducted a port scan to verify the effectiveness of the UFW firewall rules.

 ```bash
 nmap -v -A localhost
```
<img width="867" height="798" alt="image" src="https://github.com/user-attachments/assets/b908c86d-00b4-4ec4-8326-580c45589be6" />

*Nmap scan results confirming that only Port 22 (SSH) is open.*

**Analysis:**
The scan confirms that the attack surface is minimized. Only the SSH service is reachable, and the version info is consistent with OpenSSH on Ubuntu.

## 4. Service Inventory & Justification
The following services were found running on the system. All are necessary for the server's function.
 ```bash
systemctl list-units --type=service --state=running
```
<img width="895" height="529" alt="image" src="https://github.com/user-attachments/assets/350c9f32-b9a0-4c1f-9f1e-348fbd657451" />

*List of active systemd services.*

| Service | Status | Justification |
| :--- | :--- | :--- |
| **ssh.service** | Active | **Critical.** Required for remote administration in a headless environment. |
| **fail2ban.service** | Active | **Security.** Protects SSH from brute-force attacks. |
| **unattended-upgrades** | Active | **Security.** Automates the installation of security patches. |
| **systemd-journald** | Active | **System.** Required for system logging. |
| **cron.service** | Active | **System.** Required for scheduled tasks. |

## 5. Remaining Risk Assessment
Despite hardening, some risks remain and must be managed.

| Risk | Impact | Mitigation Strategy |
| :--- | :--- | :--- |
| **Zero-Day SSH Exploits** | Critical | If a vulnerability is found in OpenSSH itself, the server is exposed. **Mitigation:** Rely on `unattended-upgrades` to patch immediately upon release. |
| **Insider Threat** | High | An admin with the private key can do anything. **Mitigation:** In a real production environment, we would implement key rotation and multi-factor authentication (MFA). |
| **Virtualization Escape** | High | An attacker escaping the VM to the Host. **Mitigation:** Keep VirtualBox patched and use the restricted Host-Only network. |

## 6. Project Reflection
This coursework simulated the full lifecycle of a Linux server deployment. Starting from a raw ISO, I successfully deployed a headless server, secured it with industry-standard controls (UFW, AppArmor, Fail2Ban), automated its maintenance, and validated its performance with quantitative data.

The most significant learning outcome was **LO5 (Trade-offs)**. Every security decision (like disabling passwords or restricting network traffic) added complexity to the administration process. Security is not a product but a process of balancing usability with protection.

---
[< Previous: Week 6](week6.md) | [Return to Home](index.md)
