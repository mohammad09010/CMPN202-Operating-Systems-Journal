# Week 4: Initial System Configuration & Security Implementation

## 1. Introduction
Phase​‍​‌‍​‍‌ 4 is about moving from the plans to actually carrying out the security measures. The goal was to install basic security measures on the headless server, in particular, by substituting password-based authentication with cryptographic keys and setting up a tightly controlled firewall policy.

## 2. User Privilege Management
To limit the risk of privilege escalation (Threat T2), I set up a special non-root administrative user `admin_user` and gave him/her limited `sudo` ​‍​‌‍​‍‌privileges.

### Implementation Command:
```bash
sudo adduser admin_user
sudo usermod -aG sudo admin_user
```
<img width="935" height="530" alt="image" src="https://github.com/user-attachments/assets/3740af02-1533-4675-bfd2-1df6bb73e2b3" />

```bash
ssh admin_user@server_ip
```
<img width="903" height="763" alt="image" src="https://github.com/user-attachments/assets/bc891a57-8b56-438c-ab34-e062b177079f" />

**Verification:** The user is now part of the `sudo` group, allowing administrative tasks only when explicitly requested.

## 3. SSH Hardening & Key-Based Authentication
To mitigate Brute Force attacks (Threat T1), I transitioned from password authentication to ED25519 key pairs.

### SSH Access Evidence
The screenshot below demonstrates a successful login from the workstation using the private key. Note the absence of a password prompt.
```bash
ssh-keygen -t ed25519
```
<img width="924" height="512" alt="image" src="https://github.com/user-attachments/assets/5636318d-8c21-41cf-823b-da3c9058a9ed" />

*Successful SSH connection using cryptographic keys.*

### Configuration File Comparison (`/etc/ssh/sshd_config`)
I modified the SSH daemon configuration to strictly enforce the new security policy.

| Setting | Before (Default) | After (Hardened) | Justification |
| :--- | :--- | :--- | :--- |
| `PermitRootLogin` | `yes` | **`no`** | Prevents direct root access. |
| `PasswordAuthentication` | `yes` | **`no`** | Eliminates password guessing attacks. |
| `PubkeyAuthentication` | `yes` | **`yes`** | Enforces the use of cryptographic keys. |

### Configuration Verification
```bash
grep -E "PermitRoot|PasswordAuth" /etc/ssh/sshd_config
```
<img width="850" height="217" alt="image" src="https://github.com/user-attachments/assets/b286f71a-7151-4037-ae34-503363eb42b5" />

*Grep output confirming that PasswordAuthentication and PermitRootLogin are disabled.*

## 4. Firewall Configuration (UFW)
I​‍​‌‍​‍‌ made use of UFW to execute a **Whitelist** policy. Basically, all incoming connections are denied by default. The single allowable exception is **port 22** (SSH) limited to the admin ​‍​‌‍​‍‌workstation..

#### Configure Firewall (UFW)
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow from 192.168.1.84 to any port 22
````
<img width="986" height="184" alt="image" src="https://github.com/user-attachments/assets/89a37a56-51a5-46bb-971b-68695ebeae25" />

### Evidence of Active Firewall

```bash
sudo ufw status verbose
```
<img width="833" height="295" alt="image" src="https://github.com/user-attachments/assets/aad0a82b-3d9c-4455-af02-ae496764628e" />

*Output of `ufw status verbose` confirming the strict access control rules.*

#### 5. Learning Reflection

Risks​‍​‌‍​‍‌ associated with remote administration were brought to my attention this week. While turning off password authentication, it dawned on me that an error in the `sshd_config` file or a misplacement of the private key could make it impossible to gain access to the **headless** server forever. In order to save myself from this fate, I always used one terminal session to keep an eye on the new configuration, which I was testing in a second terminal session, a very important safety measure in system ​‍​‌‍​‍‌administration.

---
[< Previous: Week 3](week3.md) | [Return to Home](index.md) | [Next: Week 5 >](week5.md)
