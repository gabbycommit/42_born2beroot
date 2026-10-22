*This project has been created as part of the 42 curriculum by &lt;hukhaw&gt;.*

<div align="center">

# Born2beRoot

A System Administration project from the 42 curriculum: set up a Debian virtual machine in VirtualBox with an encrypted LVM partition, strict sudo and password policies, SSH on port 4242, UFW firewall and a monitoring script run by cron.

<p align="center">
  <img src="https://img.shields.io/badge/42-Born2beRoot-000000?style=for-the-badge&logo=42&logoColor=white" alt="42 Born2beRoot">
  <img src="https://img.shields.io/badge/Debian-A81D33?style=for-the-badge&logo=debian&logoColor=white" alt="Debian">
  <img src="https://img.shields.io/badge/VirtualBox-183A61?style=for-the-badge&logo=virtualbox&logoColor=white" alt="VirtualBox">
  <img src="https://img.shields.io/badge/Shell_Script-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white" alt="Shell Script">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/LVM-Encrypted-555555?style=flat-square" alt="LVM Encrypted">
  <img src="https://img.shields.io/badge/SSH-Port_4242-555555?style=flat-square&logo=openssh&logoColor=white" alt="SSH">
  <img src="https://img.shields.io/badge/UFW-Firewall-555555?style=flat-square" alt="UFW">
  <img src="https://img.shields.io/badge/AppArmor-Enabled-555555?style=flat-square" alt="AppArmor">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Lighttpd-Bonus-FF6F00?style=flat-square" alt="Lighttpd">
  <img src="https://img.shields.io/badge/MariaDB-Bonus-003545?style=flat-square&logo=mariadb&logoColor=white" alt="MariaDB">
  <img src="https://img.shields.io/badge/PHP-Bonus-777BB4?style=flat-square&logo=php&logoColor=white" alt="PHP">
  <img src="https://img.shields.io/badge/WordPress-Bonus-21759B?style=flat-square&logo=wordpress&logoColor=white" alt="WordPress">
  <img src="https://img.shields.io/badge/Fail2ban-Bonus-CC0000?style=flat-square" alt="Fail2ban">
</p>

</div>

# Table of Content
- [Description](#description)
  - [Overview](#overview)
- [Project description](#project-description)
  - [Choice of Operating System](#choice-of-operating-system)
  - [Main Design Choices](#main-design-choices)
    - [Partitioning](#partitioning)
    - [Security Policies](#security-policies)
    - [User Management](#user-management)
    - [Services Installed](#services-installed)
  - [Comparisons](#comparisons)
    - [Debian vs Rocky Linux](#debian-vs-rocky-linux)
    - [AppArmor vs SELinux](#apparmor-vs-selinux)
    - [UFW vs firewalld](#ufw-vs-firewalld)
    - [VirtualBox vs UTM](#virtualbox-vs-utm)
- [Useful Commands in This Project](#useful-commands-in-this-project)
  - [Commands That Help in Disk and Partition Checking](#commands-that-help-in-disk-and-partition-checking)
  - [Commands to Check AppArmor](#commands-to-check-apparmor)
  - [Commands That View / Change Your Hostname](#commands-that-view--change-your-hostname)
  - [Commands Used in Sudo](#commands-used-in-sudo)
    - [Rules in the Config File](#rules-in-the-config-file)
  - [Commands Used in User](#commands-used-in-user)
  - [Commands Used in Groups](#commands-used-in-groups)
  - [Commands Used in Password Aging Config and Password Aging Changing](#commands-used-in-password-aging-config-and-password-aging-changing)
    - [Setting to Change in /etc/login.defs](#setting-to-change-in-etclogindefs)
  - [Commands Used in Password Rules - libpam-pwquality and Password Changing](#commands-used-in-password-rules---libpam-pwquality-and-password-changing)
    - [Setting to Change in /etc/security/pwquality.conf](#setting-to-change-in-etcsecuritypwqualityconf)
  - [Commands Used in SSH](#commands-used-in-ssh)
    - [Setting to Change in /etc/ssh/sshd_config.d/sshd.conf](#setting-to-change-in-etcsshsshd_configdsshdconf)
  - [Commands Used in UFW](#commands-used-in-ufw)
  - [Commands Used in Cron](#commands-used-in-cron)
    - [Setting to Change in crontab](#setting-to-change-in-crontab)
  - [Commands Used in lighttpd](#commands-used-in-lighttpd)
  - [Commands Used in PHP](#commands-used-in-php)
  - [Commands Used in MariaDB](#commands-used-in-mariadb)
  - [Commands Used in WordPress](#commands-used-in-wordpress)
    - [Setting to Change in wp-config.php](#setting-to-change-in-wp-configphp)
  - [Commands Used in fail2ban](#commands-used-in-fail2ban)
    - [Config fail2ban](#config-fail2ban)
    - [Safe Ban Test](#safe-ban-test)
- [Instructions](#instructions)
  - [Requirements](#requirements)
  - [1. Verify the Signature](#1-verify-the-signature)
  - [2. Start the VM](#2-start-the-vm)
  - [3. Connect with SSH](#3-connect-with-ssh)
  - [4. Check the Configuration](#4-check-the-configuration)
  - [5. Run monitoring.sh](#5-run-monitoringsh)
  - [6. Bonus: Open the WordPress Website](#6-bonus-open-the-wordpress-website)
- [Resources](#resources)
  - [References](#references)
  - [AI Usage](#ai-usage)

---

# Description

**Born2beRoot** is a System Administration project from the 42 curriculum that introduces the world of **virtualization**. The goal is to build a first server from scratch inside a virtual machine (VirtualBox or UTM), following strict rules. Along the way you learn how a Linux system is installed, partitioned, secured and monitored, and you have to be able to explain every choice during the peer evaluation.

The server runs the latest stable version of **Debian** (or Rocky Linux), with no graphical interface: installing X.org, Wayland or any other graphics server is forbidden.

### Overview

- **Mandatory part**: a Debian server with encrypted LVM partitions, AppArmor, SSH on port 4242, a UFW firewall, strict password and sudo policies, and a `monitoring.sh` script that `cron` broadcasts every 10 minutes.
- **Bonus part**: the bonus partition layout, a WordPress website running on lighttpd, MariaDB and PHP, and Fail2ban as an extra service.

---

# Project description

## Choice of Operating System

I chose **Debian** (small andlatest stable release). The subject recommends it for people new to system administration, and it fits a small server that should be easy to learn and maintain.

| | Advantages | Disadvantages |
|---|---|---|
| **Debian** | Very stable, run by a non-profit community, beginner-friendly, huge amount of documentation and tutorials, simple tools (`apt`, AppArmor, UFW) | Packages are older because stable releases come out only about every two years, and it is less common in enterprises that require RHEL |
| **Rocky Linux** | Binary-compatible with RHEL, long enterprise support, the same tools used in many companies (`dnf`, SELinux, firewalld) | Steeper learning curve, especially SELinux, and a more complex setup (the subject even skips KDump for it) |

## Main Design Choices

### Partitioning

The disk uses the bonus layout: `/boot` is a normal, unencrypted partition, and everything else sits inside one encrypted partition (LUKS) that holds an **LVM** volume group.

```
sda
├─ sda1  →  /boot                (not encrypted)
└─ sda5  →  encrypted (LUKS)
      └─ LVM volume group
            ├─ root      →  /
            ├─ swap      →  [SWAP]
            ├─ home      →  /home
            ├─ var       →  /var
            ├─ srv       →  /srv
            ├─ tmp       →  /tmp
            └─ var-log   →  /var/log
```

- `/boot` stays unencrypted because the kernel and initramfs inside it must be read **before** the passphrase can be asked to unlock the rest of the disk.
- **LVM** lets logical volumes be resized later (`lvextend`) without moving other partitions.
- `/var`, `/var/log`, `/tmp` and `/home` are separate so that, for example, runaway logs fill only `/var/log` instead of freezing the whole system.
- **Sizes**: after installing, I measured the real usage with `df -h` and `lsblk`. With about 20–30% headroom, these sizes are enough:

| Partition | Size |
|---|---|
| `/boot` | 500M |
| `/` | 4G |
| swap | 1G |
| `/home` | 2G |
| `/var` | 2G |
| `/var/log` | 1G |
| `/srv` | 1G |
| `/tmp` | 1G |

### Security Policies

- **AppArmor** is enabled and starts at boot (`sudo aa-status`).
- **SSH** is configured in `/etc/ssh/sshd_config.d/sshd.conf` with `Port 4242` and `PermitRootLogin no`.
- **UFW** denies all incoming traffic by default, and port 4242 is the only port allowed. Port 80 is opened for the WordPress bonus.
- **Password policy**:
  - Password aging is set in `/etc/login.defs` (`PASS_MAX_DAYS 30`, `PASS_MIN_DAYS 2`, `PASS_WARN_AGE 7`). It is applied to existing accounts with `chage`.
  - Password strength is enforced with `libpam-pwquality` in `/etc/security/pwquality.conf`: `minlen = 10`, `ucredit`, `lcredit` and `dcredit = -1`, `maxrepeat = 3`, `usercheck = 1`, `difok = 7` and `enforce_for_root`.
- **sudo** is configured in `/etc/sudoers.d/sudo_config` (edited with `visudo`):
  - `passwd_tries=3` and a custom `badpass_message`
  - `log_input` and `log_output`, with logs in `/var/log/sudo`
  - `requiretty`
  - a restricted `secure_path`

### User Management

- Besides `root`, there is a user `hukhaw`, which belongs to the `sudo` and `user42` groups (`usermod -aG`).
- New users are created with `adduser`, which creates the home directory and asks for a password straight away.
- After the policies were configured, every password, including root's, was changed so that it follows the new rules.

### Services Installed

| Service | Purpose |
|---|---|
| `sudo` | Run administrative commands with strict rules and full logging |
| `openssh-server` | Remote administration on port 4242 |
| `ufw` | Firewall |
| `libpam-pwquality` | Password strength rules |
| `cron` | Runs `monitoring.sh` at `@reboot` and `*/10 * * * *` from root's crontab |
| `lighttpd`, `php`, `mariadb-server`, WordPress | Bonus: the WordPress website |
| `fail2ban` | Bonus: bans IP addresses that fail SSH logins too many times |

**Why Fail2ban?** SSH is the only service exposed by default, so it is the main target for brute-force password guessing. Fail2ban watches the SSH logs and adds a firewall rule that bans an address after repeated failures. Its `sshd` jail is changed to port 4242 in `/etc/fail2ban/jail.d/custom.local`.

## Comparisons

### Debian vs Rocky Linux

| | Debian | Rocky Linux |
|---|---|---|
| Family | Debian (Ubuntu, Mint, Kali) | Red Hat (RHEL, AlmaLinux, Fedora) |
| Maintained by | Volunteer community, non-profit | Rocky Enterprise Software Foundation |
| Packages | `.deb` with `apt` and `dpkg` | `.rpm` with `dnf` and `rpm` |
| Security module | AppArmor | SELinux |
| Firewall | UFW | firewalld |
| Release cycle | When ready, about every two years | Follows RHEL |
| Best for | Beginners, individuals, hosting | Enterprises that need RHEL compatibility |

### AppArmor vs SELinux

Both are Mandatory Access Control (MAC) systems built into the Linux kernel, so they can block a program even when its user would normally be allowed.

| | AppArmor | SELinux |
|---|---|---|
| Default on | Debian, Ubuntu | Rocky, RHEL, Fedora |
| How it identifies resources | File **paths** | **Labels** (security contexts) attached to every file and process |
| Rules | A profile for each program, easy to read and write | A system-wide policy, detailed but complex |
| Modes | enforce / complain | enforcing / permissive / disabled |
| Learning curve | Gentle | Steep |
| Strength | Simple and quick to set up | Finer-grained, stronger isolation |


### UFW vs firewalld

Both are front ends for the kernel's packet filter (netfilter, through iptables or nftables).

| | UFW | firewalld |
|---|---|---|
| Default on | Debian, Ubuntu | Rocky, RHEL, Fedora |
| Model | A simple list of allow and deny rules | **Zones**, each with its own trust level and rules |
| Commands | `ufw allow 4242` | `firewall-cmd --permanent --add-port=4242/tcp` |
| Applying changes | Applied immediately | Runtime and permanent configs are separate, and `--reload` applies permanent changes |
| Best for | Simple single servers | Complex or changing networks |

### VirtualBox vs UTM

| | VirtualBox | UTM |
|---|---|---|
| Developer | Oracle (open source, GPL) | Open-source project for Apple devices |
| Platforms | Windows, Linux, macOS (Intel) | macOS (Intel and Apple Silicon), iOS |
| Engine | Its own hypervisor | QEMU, plus Apple's Hypervisor framework for native speed on Apple Silicon |
| Disk format | `.vdi` | `.qcow2` |
| Strength | Mature, many features, lots of documentation | The best option on Apple Silicon (M1 and later), and it can emulate other CPU architectures |
| Weakness | Limited support on Apple Silicon | Fewer advanced features, and emulating another architecture is slow |

I used **VirtualBox** because it runs natively on my Linux host and is the tool the subject recommends.

---

# Useful Commands in This Project

## Commands That Help in Disk and Partition Checking
| Command | Shows |
|---|---|
| `lsblk` | Partitions and logical volumes, and their sizes |
| `df -h` | For each mounted partition: size, used, available, and % used |

## Commands to Check AppArmor
| Command | Shows |
|---|---|
| `sudo aa-status` | Whether AppArmor is loaded, how many profiles exist, and which are in enforce or complain mode |
| `sudo systemctl status apparmor` | Whether the AppArmor service is running |
| `systemctl is-enabled apparmor` | Whether it will start at boot |
| `sudo journalctl -k \| grep -i apparmor` | AppArmor messages in the kernel log, including blocked actions (look for `DENIED`) |

## Commands That View / Change Your Hostname
 Command | Shows |
|---|---|
| `hostname` | The current hostname |
| `hostnamectl` | The static, transient and pretty names, plus OS, kernel and virtualization info |
| `cat /etc/hostname` | The static name stored on disk |
| `cat /etc/hosts` | The local name-to-address table |
| `sudo hostnamectl hostname <name>` | Change the hostname in Pretty, static, transient |

> After changing the hostname, also update it in `/etc/hosts`. Otherwise, `sudo` will show the warning "unable to resolve host", and host-based rules could be affected. However, the warning is harmless, and the command still runs.

## Commands Used in Sudo
 Command | What it does |
|---|---|
| `apt install sudo` | install sudo |
| `sudo visudo /etc/sudoers.d/sudo_config` | to edit the sudo config |

### Rules in the Config File
```
Defaults    requiretty
Defaults    secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
Defaults    passwd_tries=3
Defaults    badpass_message="Bad password, try again."
Defaults    log_input, log_output
Defaults    iolog_dir="/var/log/sudo"
```
> `Defaults logfile="/var/log/sudo/sudo_log"` is an optional setting that makes it easier to count the log entries in monitoring.sh.

> After saving the configuration file, check it with `visudo -c` and `sudo -l`.

## Commands Used in User
 Command | What it does |
|---|---|
| `adduser <username>` | to add a user, home directory, add for a password |
| `deluser --remove-home <username>` | delete the user and their home directory |
| `deluser <username>` | delete user and keep their home directory |
| `cat /etc/passwd` | check all user (readerable by everyone) |

## Commands Used in Groups
 Command | What it does |
|---|---|
| `groups` | show the groups **you** belong to|
| `groups <username>` | show the groups of another user belong to |
| `sudo groupadd <groupname>` | create a group |
| `sudo groupdel <groupname>` | delete a group |
| `sudo usermod -aG <groupname> <username>` | add a user to a group (keeps thier other group) |
| `sudo usermod -d <groupname> <username>` | delete a user from a group |

## Commands Used in Password Aging Config and Password Aging Changing
 Command | What it does |
|---|---|
| `sudo nano /etc/login.defs` | edit login config |
| `sudo chage -M 30 -m 2 -W 7 <username>` | change the password aging, M=max, m=min, W=warning |
| `sudo chage -l <username>` | show the password aging of the user |

### Setting to Change in /etc/login.defs
*Scroll down to the Password aging controls section and change:*
```
PASS_MAX_DAYS   30
PASS_MIN_DAYS   2
PASS
```

## Commands Used in Password Rules - libpam-pwquality and Password Changing
 Command | What it does |
|---|---|
| `sudo apt install libpam-pwquality` | install pwquality |
| `sudo nano /etc/security/pwquality.conf` | edit the pwqualit config |
| `sudo passwd <username>` | change the user's password |

### Setting to Change in /etc/security/pwquality.conf
```
difok = 7       // At least 7 characters different from the old password
minlen = 10     // At least 10 characters
dcredit = -1    // Must contain a digit
ucredit = -1    // Must contain an uppercase letter
lcredit = -1    // Must contain a lowercase letter
maxrepeat = 3   // No more than 3 identical characters in a row
usercheck = 1   // Must not contain the user’s name
enforce_for_root // The rules must apply to root too
```

## Commands Used in SSH
 Command | What it does |
|---|---|
| `sudo nano /etc/ssh/sshd_config.d/sshd.conf` | edit the sshd config |
| `sudo sshd -t` | test config file syntax error |
| `sudo sshd -T` | Extended test mode and dumps the final, active configuration to the terminal. |
| `sudo systemctl status ssh` | check the status of ssh |
| `sudo systemctl is-enabled ssh` | check whether the ssh active in startup |
| `ssh -p <host port> <username>@localhost` | connect vm ssh in localhost |

### Setting to Change in /etc/ssh/sshd_config.d/sshd.conf
```
Port 4242
PermitRootLogin no
```

## Commands Used in UFW
 Command | What it does |
|---|---|
| `sudo apt install ufw` | install ufw |
| `sudo ufw status` | checking ufw status, active or inactive |
| `sudo ufw allow <port>` | allowing port |
| `sudo ufw enbale` | activate ufw and enable it on system startup |
| `sudo ufw status verbose` | check the ufw status in details |
| `sudo ufw status numbered` | check the rule with numbered |
| `sudo ufw delete <number>` | delete rule by number |
| `sudo ufw delete allow <port>` | delete rule |
| `sudo ufw delete allow <port>/tcp` | delete rule by its definition |
| `sudo ss -tunlp` | check whether the port really listen |

## Commands Used in Cron
 Command | What it does |
|---|---|
| `man cron` | the cron manual |
| `man crontab` | the `crontab` command (edit, list, remove) |
| `sudo crontab -e` or `sudo nano /etc/crontab` or `sudo nano /etc/cron.d`| edit crontab rules |
| `systemctl status cron` | checking cron status |
| `sudo journalctl -u cron -n 20` | check did cron actually run it |

### Setting to Change in crontab
```
@reboot           /home/<username>/monitoring.sh
*/10 * * * *      /home/<username>/monitoring.sh
```

## Commands Used in lighttpd
 Command | What it does |
|---|---|
| `sudo apt install lighttpd` | install lighttpd |
| `systemctl status lighttpd` | checking status lighttpd |
| `sudo ss -tupln` | checking 80 port is listened |
| Test in browser with `localhost:enter your host port`| see the lighttpd is listened or not |

## Commands Used in PHP
 Command | What it does |
|---|---|
| `sudo apt instal php-cgi php-mysql` | install the PHP package that lighttpd can call and the package that let PHP use mysql to talk with MariaDB |
| `sudo lighty-enable-mod fastcgi fastcgi-php` | swithes lighttpd module on, ask lighttp to use fastcgi protocol, use PHP to talk |
| `sudo lighttpd -t -f /etc/lighttpd/lighttpd.conf` | checking syntax of lighttpd syntax |
| `sudo systemctl restart lighttpd` | restart the lighttpd, and should no error output |
| `systemctl status lighttpd` | checking status of lighttpd |

## Commands Used in MariaDB
 Command | What it does |
|---|---|
| `sudo apt install mariadb-server` | install mariadb |
| `systemctl status mariadb` | checking status mariadb |
| `sudo ss -tunlp \| grep -E "mariadb\|sql"` | checking port is listened (127.0.0.1:3306) |
| `sudo mariadb-secure-installation` | running mariadb secure installation |
| `sudo mariadb -e "SHOW DATABASES";` | show all databases in mariadb |
| `sudo mariadb -e "SELECT user, host FROM mysql.user;"` | used to view a list of all database users and the hosts allowed to connect from in your MariaDB or MySQL database server  |
| `sudo mariadb -e "SHOW GRANTS FOR '<user name>'@'localhost';"` | show grants of the user|
| `sudo mariadb` | open mariadb database shell |
| `CREATE DATABASES <database name>` | create an empty database |
| `CREATE USER '<username>'@'localhost' IDENTIFIED BY '<your_password>';`| Makes an account that can only connect from this VM |
| `GRANT ALL PRIVILEGES ON <database name>.* TO '<user name>'@'localhost';`| Gives that account full rights on **this one database only** |
| `FLUSH PRIVILEGES;`| Makes the server re-read permissions |
| `EXIT;` or `ctrl + d` | exist mariadb database shell |
| `mariadb -u wp_user -p wordpress_db` | used to log into an interactive MariaDB database session as a specific user, targeting a specific database. |

## Commands Used in WordPress
| `wget https://wordpress.org/latest.tar.gz` | download the compressed WordPress installation file |
| `sudo tar -xzf latest.tar.gz -C /var/www/html --strip-components=1` | unzip the file into `/var/www/html` directory |
| `sudo chown -R www-data:www-data /var/www/html` | changing owner and group belong to www-data |
| `sudo -u www-data cp wp-config-sample.php wp-config.php` | copying and rename the wordpress config |

### Setting to Change in wp-config.php
| Setting | Value |
|---|---|
| `DB_NAME` | `wordpress_db` |
| `DB_USER` | `wp_user` |
| `DB_PASSWORD` | the password you set for `wp_user` |
| `DB_HOST` | `localhost` (probably already set) |

> Retricting who can read it, since this contain database password: `sudo chmod 640 /var/www/html/wp-config.php`

> Remove the `/var/www/html/index.lighttpd.html`. This is lighttpd’s default placeholder page, installed by the package so you’d see something right after installing. It has nothing to do with WordPress, and your site doesn’t need it.

> Testing in browser with localhost:"host port".

## Commands Used in fail2ban
 Command | What it does |
|---|---|
| `sudo apt install fail2ban` |  |
| `systemctl status fail2ban `|  |
| `sudo fail2ban-client status` |  |
| `sudo nano /etc/fail2ban/jail.d/custom.local` |  |
| `sudo fail2ban-client -t` | config test |
| `sudo systemctl restart fail2ban` | restart fail2ban |
| `sudo fail2ban-client status sshd` | check the jail status |
| `sudo fail2ban-client get sshd maxretry` | 5 (5 times) |
| `sudo fail2ban-client get sshd findtime` | 600 (600 seconds) |
| `sudo fail2ban-client get sshd bantime` | 600 (600 seconds) |

### Config fail2ban
```
[sshd]
port = 4242

// optional config: changing the maxretry, findtime and bantime
maxretry = 3
findtime = 600 (or 10m / 15m)
bantime = 900 (or 15m / 20m)
```

### Safe Ban Test
```
sudo fail2ban-client set sshd banip 203.0.113.5
sudo nft list ruleset | grep -i -B2 -A2 4242
sudo fail2ban-client status sshd
sudo fail2ban-client set sshd unbanip 203.0.113.5
```

---

# Instructions

> This repository does not contain the virtual machine itself (the subject forbids it). It only contains this `README.md`, `signature.txt` (the SHA-1 signature of the VM's virtual disk) and `monitoring.sh`.

## Requirements

- [VirtualBox](https://www.virtualbox.org/) (or UTM on Apple Silicon)
- The virtual disk of the VM (`.vdi`)
- An SSH client on the host

## 1. Verify the Signature

Before starting the VM, check that its disk matches `signature.txt`:

```
cd ~/VirtualBox\ VMs/<vm_name>/
sha1sum <vm_name>.vdi       // must be the same as the content of signature.txt
```

> Starting the VM changes its signature. To keep it valid for every evaluation, take a snapshot or work on a copy of the `.vdi` file.

## 2. Start the VM

1. Open VirtualBox, select the VM, and click **Start**.
2. Enter the **encryption passphrase** to unlock the disk.
3. Log in as `hukhaw` (there is no graphical interface, only a TTY).

## 3. Connect with SSH

1. In VirtualBox, open **Settings > Network > Adapter 1 (NAT) > Advanced > Port Forwarding**, and add this rule:

   | Name | Protocol | Host IP | Host Port | Guest IP | Guest Port |
   |---|---|---|---|---|---|
   | ssh | TCP | | 8080 | | 4242 |

2. Connect from the host:
   ```
   ssh -p 8080 hukhaw@localhost
   ```
   Logging in as `root` is refused (`PermitRootLogin no`).

## 4. Check the Configuration

| Check | Command |
|---|---|
| OS version | `cat /etc/os-release` |
| No graphical interface | `ls /usr/bin/*session` |
| Hostname | `hostnamectl` |
| Partitions and LVM | `lsblk` |
| AppArmor | `sudo aa-status` |
| SSH | `sudo systemctl status ssh` |
| UFW | `sudo ufw status verbose` |
| User groups | `groups hukhaw` |
| Password aging | `sudo chage -l hukhaw` |
| Password rules | `cat /etc/security/pwquality.conf` |
| sudo rules | `sudo cat /etc/sudoers.d/sudo_config` |
| sudo logs | `sudo ls /var/log/sudo/` |
| cron jobs | `sudo crontab -l` |

## 5. Run `monitoring.sh`

The script is in `/home/hukhaw/monitoring.sh`, and root's crontab runs it at boot and every 10 minutes:

```
@reboot           /home/hukhaw/monitoring.sh
*/10 * * * *      /home/hukhaw/monitoring.sh
```

To run it by hand:

```
sudo bash /home/hukhaw/monitoring.sh
```

To stop it without changing the script:

```
sudo systemctl stop cron        // stop cron
sudo systemctl start cron       // start it again
```

## 6. Bonus: Open the WordPress Website

1. Add a second port forwarding rule:

   | Name | Protocol | Host IP | Host Port | Guest IP | Guest Port |
   |---|---|---|---|---|---|
   | http | TCP | | 8081 | | 80 |

2. Open `http://localhost:8081` in the host's browser.
3. Check the Fail2ban jail for SSH:
   ```
   sudo fail2ban-client status sshd
   ```

---

# Resources

## References

- [Sudoers Manual](https://www.sudo.ws/docs/man/sudoers.man/): the options used in `/etc/sudoers.d/sudo_config` (`passwd_tries`, `badpass_message`, `log_input`, `log_output`, `iolog_dir`, `requiretty`, `secure_path`)
- [Debian](https://www.debian.org/): installation, packages and system administration documentation
- [pam_pwquality(8)](https://linux.die.net/man/8/pam_pwquality): the password quality options used in `/etc/security/pwquality.conf`

## AI Usage

AI was used as a learning assistant throughout the project:

- **Understanding concepts**: what LVM is and how its layers work, and what GRUB does in the boot process.
- **Setting up Debian**: the installation steps, including the encrypted LVM partitioning.
- **Configuration**: how to configure sudo and the other services step by step.
- **README**: drafting and structuring this `README.md`.

Every command and configuration was tested on my own VM.