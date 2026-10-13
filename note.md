# Table of content

# What Is Virtual Machine
A VM is a pretend computer running as a program inside a real computer. It has its own virtual CPU, RAM, disk and network card, and its own OS, but all of these are carved out of the real hardware.

- *Host*: the real physical computer (your real computer).
- *Guest*: the VM running inside it (your Debian/ Rocky/ other server).
- *Hypervisor*: the software that creates and manages VMs. It divides the host’s real resources among them and keeps them isolated from each other.

## Why Virtual Machine
- *Cost and efficiency*: One powerful physical server can run 10-50 VMs.
- *Isolation*: If one VM crashes or gets hacked, the others are not directly affected.
- *Flexibility*: You can create a VM in minutes, clone it, move it between physical machines, or delete it.
- *Safe testing*: You can break things freely, then use a snapshot (a saved state) to roll back.
- *Cloud computing*: When you rent a server from AWS, Google Cloud or Azure, you are renting a VM.

## Are Virtual Machine use for Long or Short term
| Use case | Lifespan |
|---|---|
| Production servers (websites, databases, company apps) | Months to years, running 24/7 |
| Development and testing environments | Days to weeks |
| Learning and training (like Born2beRoot) | Short term |
| Security testing, malware analysis | Hours to days, then deleted |
| Auto-scaling cloud servers | Minutes to hours, created and destroyed automatically |

> One caveat on current practice: for many modern applications, companies now use containers (Docker, Kubernetes), which are lighter than VMs. VMs are still very widely used, and containers often run inside VMs, so VMs remain a core skill.

---

# Disk Size
## How Does the Industry Decide Disk Size
- *Know the workload*: small web server needs far less than a database holding millions of records.
- *Add up the parts*: OS footprint + applications + data + logs + temporary files + swap.
- *Estimate growth*: How much will data and logs grow per month? Plan for 1-3 years, not just today.
- *Add headroom*: A common rule of thumb is to keep 20-30% free. A disk that hits 100% can crash services.
- *Separate by purpose*: This is why the bonus asks for /var, /var/log, /tmp and /home as separate partitions. If logs fill up, they only fill their own partition instead of freezing the whole system.
- *Monitor and adjust*: Teams use monitoring tools with alerts (for example at 80% full), then expand when needed.

## What Should We Do
1. *Install first, measure second*. Do a trial install and run df -h. The “Used” column tells you what the system needs, instead of a guess.
2. *Add the services*. Use `apt-get install -s` on your bonus packages (lighttpd, mariadb-server, php) to see their size.
3. *Add expected data*. For example, how large will the WordPress site and database get?
4. *Add headroom*. Keep roughly *20-30% free*, because a full partition can break services.
5. *Check the total fits your disk*. The partition sizes must add up to your disk size, minus /boot.

## Command That Help in Disk adn Partition Checking
| Command | What it shows |
|---|---|
| `lsblk` | Partitions and logical volumes, and their sizes |
| `df -h` | For each mounted partition: size, used, available, and % used |
| `du -sh /*` | How big each top-level folder is (run as root, ignore errors) |
| `du -sh /var/* \| sort -h` | What is eating space inside `/var` |
| `apt-get install -s <package>` | A simulation that shows how much extra disk a package would use, without installing it |

## The Directory Needed
Each directory holds a different kind of data. Sizing depends on what goes in it and how fast it grows.
| Directory | What it holds | Grows over time? | How to decide the size |
|---|---|---|---|
| `/boot` | Files needed to start the OS (kernel, bootloader). Unencrypted. | Slowly, as kernel updates add files | About 500 MB is the standard. Too small and kernel updates fail. |
| `/` (root) | The OS itself: programs, libraries, configuration | Slowly | System size (see above) plus apps you install, plus headroom |
| `/home` | Each user's personal files | Depends on users | Number of users × expected data each. For a server with 1-2 users, a few GB is plenty. |
| `/var` | Data that changes constantly: package database, apt cache, mail, **databases (MariaDB stores data in `/var/lib/mysql`)** | Yes | Depends on what services run. WordPress with MariaDB needs far more than a bare server. |
| `/var/log` | Log files recording what the system does | Yes, steadily | Sized for how many days of logs you want to keep. Separate so runaway logs can't fill the whole system. |
| `/srv` | Data served by your services (for example website files) | Depends | Size of the content you plan to host |
| `/tmp` | Temporary files, usually cleared on reboot | Spikes | Small is fine, 1-3 GB |
| `/root` | The **root user's** home folder | Barely | Normally **not a separate partition**. It lives inside `/`, so the PDF layouts have no `/root` entry. |
| `swap` | Overflow space used when RAM is full | No | A common rule for small VMs is about equal to RAM |

## The Difference Between SI units and IEC units
Both measure amounts of data, but they count in different ways:
- `GB`, `MB`, `KB` *(SI units)*: count in powers of 10. Each step is ×1000.
- `GiB`, `MiB`, `KiB` *(IEC units)*: count in powers of 2. Each step is ×1024.

---

# Hostname
A hostname is the name of a computer on a network. An IP address like 10.0.2.15 is for machines, but names are easier for people to remember and tell apart. Your laptop, your VM and a server in a data center each have their own hostname.

You see it in several places:

- The shell prompt: in hukhaw@debian:~$, the part after the @ is the hostname.
- Networking tools, such as when a machine announces itself on a network.

> `man hostname` to check more info.

## Naming rules
| Rule | Detail |
|---|---|
| Allowed characters | Letters, digits and hyphens (`-`) |
| Not allowed | Spaces, underscores, and most symbols |
| Hyphen position | Not at the start or the end |
| Case | Use **lowercase**. Hostnames are not case-sensitive in networking, but lowercase avoids confusion. |
| Length | Keep it short. A single name component in DNS may be at most 63 characters. |

## How to view your hostname
| Command | Shows |
|---|---|
| `hostname` | The current hostname |
| `hostnamectl` | The static, transient and pretty names, plus OS, kernel and virtualization info |
| `cat /etc/hostname` | The static name stored on disk |
| `cat /etc/hosts` | The local name-to-address table |

## What is the difference for static, transiet and pretty in hostname
| Type | What it is | Where it lives | Survives reboot? | Rules |
|---|---|---|---|---|
| **Static** | The "official" name the system sets at boot | `/etc/hostname` | **Yes** | Strict: lowercase ASCII letters, digits, hyphens, no spaces |
| **Transient** | The name the kernel is using **right now**. This is what the plain `hostname` command prints. | In memory (the running kernel) | **No** | Same strict rules as static |
| **Pretty** | A friendly display name for humans, for example "Hukhaw's Test Server" | `/etc/machine-info` (as far as I know) | Yes | Free-form: capitals, spaces and symbols are allowed |

> Analogy: your name on your ID card is the static hostname. A nickname someone gives you for one evening is transient. The fancy title on your business card is pretty.

## How to chnage hostname
| Method | Command | Changes | Permanent? |
|---|---|---|---|
| **Recommended** | `sudo hostnamectl hostname <name>` | Pretty + static + transient | **Yes** |
| Older form of the above | `sudo hostnamectl set-hostname <name>` | Same as above (documented in older man pages, may be only an alias on newer versions) | **Yes** |
| Permanent name only | `sudo hostnamectl hostname --static <name>` | Static only (`/etc/hostname`) | **Yes**, but the live name stays old until reboot or until applied |
| Live name only | `sudo hostnamectl hostname --transient <name>` | Transient only | **No**, lost at reboot |
| Display name only | `sudo hostnamectl hostname --pretty "<Name>"` | Pretty only | Yes |
| Temporary quick change | `sudo hostname <name>` | Transient only | **No**, lost at reboot |
| Edit the file by hand | `sudo nano /etc/hostname`, then `sudo hostname -F /etc/hostname` | Static (file), then live (second command) | **Yes** |

> After changing hostname, have to change the hostname in `/etc/hots`. Othervise, the sudo will be have warning "unable to resolve host", and host-base rulues could be affected. However, the warning is harmless, and the command still run.

---

# What is Logical Volume Manager(LVM)?
It is a layer of software (built into Linux) that sits between the physical disk and your filesystems. It lets you treat storage like a flexible pool instead of fixed slices.

## The Problem LVM Solves
A disk is one big block of storage. To use it, you cut it into partitions (separate sections), put a filesystem on each (the structure that organizes files, such as ext4), and attach each one to a folder, which is called mounting (for example, one partition mounted at /home).

The old way has a *painful limitation*. Partitions are fixed, and they sit next to each other like rooms separated by walls.

Imagine an 8 GB disk cut into three partitions:
- `/` = 3 GB (2.9 GB used, almost full)
- `/home` = 4 GB (only 0.5 GB used)
- `swap` = 1 GB

`/` is nearly full and `/home` has 3.5 GB sitting empty. You can’t just hand that empty space to `/`. You would have to shrink `/home`, move it, and enlarge `/`. With old-style partitions this is risky, often needs the system turned off, and can destroy data if something goes wrong. Partitions also can’t easily span two disks.

> So LVM help to solve this painpoint. It makes volumes can use space from anywhere in the volume group, so you can extend `/` without moving anything (`lvextend` + resize the filesystem). This is why many modern installs use LVM.

## The 3 Layers of LVM
| Term | Abbreviation | What it is | Analogy |
|---|---|---|---|
| **Physical Volume** | PV | A real disk or partition handed to LVM to use | Raw material (a bag of cement) |
| **Volume Group** | VG | A pool made by combining one or more PVs | A big tank holding all that material |
| **Logical Volume** | LV | A slice you carve out of the pool. You put a filesystem on it and mount it (`/`, `/home`, ...) | The usable "rooms" you build from the tank |

```
Physical disk (sda)
   └── Physical Volume (PV)      ← disk given to LVM
         └── Volume Group (VG)   ← the pool
               ├── Logical Volume: root  → mounted at /
               ├── Logical Volume: swap  → used as swap
               └── Logical Volume: home  → mounted at /home
```

## Usefull Command for LVM Checking
| Command | Shows |
|---|---|
| `sudo pvs` | Physical volumes (short summary) |
| `sudo vgs` | Volume groups, with total and free space |
| `sudo lvs` | Logical volumes and their sizes |
| `sudo pvdisplay`, `vgdisplay`, `lvdisplay` | Longer, detailed versions of the above |

---

# Linux Boot Process
What happens when you press the power button:
| Step | Who does it | What it does |
|---|---|---|
| 1 | **Firmware** (BIOS or UEFI) | Small software stored on the motherboard. It checks the hardware and looks for a disk to boot from. |
| 1.5 | **MBR** (first 512 bytes of the disk) | Contains a tiny piece of GRUB code. It is too small to do much, so it just loads the next part of GRUB. |
| 2 | **Bootloader** (**GRUB** on Debian) | A small program that knows where the OS is. It shows the boot menu and loads the kernel. |
| 3 | **Kernel** (`vmlinuz`) | The core of the OS. It controls the CPU, RAM and devices. It is loaded into RAM. |
| 4 | **initramfs** (`initrd.img`) | A tiny temporary mini-system loaded together with the kernel. Its job is to prepare the real disk (for you: ask for the encryption passphrase, unlock it, activate LVM). |
| 5 | **Init / systemd** | The first program the kernel runs. It starts all services (SSH, firewall, and so on). |

## What is Master Boot Record (MBR)
The very first sector of a disk (a sector is the smallest unit a disk reads, traditionally 512 bytes).

*What is inside those 512 bytes:*
| Part | Size | Purpose |
|---|---|---|
| Boot code | 446 bytes | A tiny program the BIOS runs. For you, this is GRUB's first stage. |
| Partition table | 64 bytes | 4 entries × 16 bytes. Each entry says where a partition starts, how big it is, and whether it is bootable. |
| Boot signature | 2 bytes | The value `0x55AA`. The BIOS checks for it to know the sector is a valid boot sector. |

![image](./image/mbr_extended_logical_partitions.png)

1. The *BIOS* reads the *MBR* (the top box). Its partition table has only 4 slots.
2. Entry 1 points to *sda1*, a normal primary partition (/boot).
3. Entry 2 points to *sda2*, the extended partition. It uses up one of the 4 slots, but inside it you can fit as many logical partitions as you like.
4. Entries 3 and 4 are empty. Debian’s installer doesn’t use them here.
5. Inside the extended partition, each logical partition is preceded by an *EBR*. The *EBR* is a small record that describes that logical partition and points to the next *EBR*, forming a chain. With only one logical partition *(sda5)*, the chain is just one link.

## What is `/boot`
`/boot` is the folder that holds the files for steps 2, 3 and 4.

*Inside `/boot` contains:*
| File or folder | What it is |
|---|---|
| `vmlinuz-<version>` | The compressed kernel itself |
| `initrd.img-<version>` | The initramfs (the temporary mini-system) |
| `grub/` | GRUB's configuration and files, including the menu |
| `config-<version>` | The settings the kernel was built with |
| `System.map-<version>` | A lookup table used for kernel debugging |

### Why `/boot` is a separate partition from encrypted partition
Look at the stack from the previous lesson. Everything else (`/`, `/home`, `swap`) is inside an encrypted layer. Think about the problem:

- The encryption passphrase prompt is shown by the initramfs.
- The initramfs and kernel are files stored in /boot.
- So the computer must read /boot before it can unlock anything.

If `/boot` were locked inside the encrypted layer, the machine couldn’t read the files needed to ask you for the passphrase. That’s a chicken-and-egg problem. So the standard solution is:
```
Disk sda
├─ sda1  → /boot        (NOT encrypted, readable at startup)
└─ sda5  → encrypted    (unlocked later by the initramfs)
     └─ LVM → /, swap, /home ...
```

>this is the traditional, safest setup, because older bootloaders could not read LVM volumes. A fair caveat: modern GRUB can actually read some encrypted setups, so a separate /boot is not an absolute law of computing. It is, however, the standard layout of Debian’s installer for encrypted LVM, and it’s what the subject’s example shows.

###  Useful Command related to `/boot`
| Command | Shows |
|---|---|
| `df -h /boot` | Size, used and free space of `/boot` |
| `ls -lh /boot` | The files inside and their sizes |
| `uname -r` | The kernel version you are running right now |
| `lsblk` | Confirms `/boot` sits on its own partition (`sda1`) |
| `findmnt /boot` | Shows what is mounted on `/boot` |

---

# Debian Vs Rocky
They both are distributor of Linux (distro).

| | **Debian** | **Rocky Linux** |
|---|---|---|
| Family | Debian family (Ubuntu, Mint, Kali...) | Red Hat family (RHEL, AlmaLinux, Fedora, Oracle Linux...) |
| Who runs it | Volunteer community, non-profit | Rocky Enterprise Software Foundation (community, with corporate sponsors) |
| Based on | Itself | RHEL's source code |
| Package format | `.deb` | `.rpm` |
| Package tool | `apt`, `dpkg` | `dnf`, `rpm` |
| Security module | AppArmor | SELinux |
| Firewall tool | UFW (a simple front end) | firewalld |
| Release style | When ready, roughly every two years | Follows RHEL's schedule, with minor releases several times a year |
| Philosophy | Free software, stability, community | Enterprise compatibility, long support |
| Beginner friendliness | Gentler, with a huge amount of tutorials | Steeper, especially because of SELinux |
| Typical users | Individuals, startups, many hosting providers | Companies that run or must match RHEL environments |

---

# `apt` Vs `aptitude`
Both are package managers: tools that install, update and remove software on Debian. They use the same repositories and the same low-level engine `dpkg`, so they can do the same jobs. The difference is how they work and how you interact with them:

- `apt` is a simple command-line tool. It is the *standard*, *built-in* way on Debian.
- `aptitude` is a separate, older program with an *extra interactive text-screen interface* and a more thorough dependency resolver. It is usually *not installed* on a minimal Debian, so you add it yourself by `sudo apt install aptitude`.

## Main Differences Between `apt` and `aptitude`

| | **apt** | **aptitude** |
|---|---|---|
| Installed by default on Debian | Yes | Usually not (check with `which aptitude`) |
| Interface | Command line only | Command line **and** a full-screen text menu (just type `aptitude`) |
| Origin | Command-line tool from the APT project, introduced around 2014 to combine the most used features of `apt-get` and `apt-cache` | A separate program, written as its own front end to APT |
| Dependency conflicts | Reports the problem and stops, or follows its solver's choice | Can propose **alternative solutions** and ask you to accept or reject them |
| Removing a package | Leaves unused dependencies until you run `apt autoremove` | Tracks and removes dependencies that nothing else needs |
| Searching | Simple name and description search | Powerful search patterns (for example, only installed packages) |
| "Why is this installed?" | Limited | `aptitude why <package>` explains the chain |
| Best for | Everyday use, and the standard recommended in Debian docs | Complex dependency problems, browsing packages interactively |

---

# AppArmor
AppArmor (short for “Application Armor”) is a Linux Security Module(LSM) built into the Linux kernel. It gives each program its own rulebook (called a profile) listing exactly what that program is allowed to do. Anything not in the rulebook is blocked, even if the user running it would normally have permission.

- AppArmor is the default Mandatory Access Contro(MAC) system on Debian (the Red Hat family, including Rocky, uses SELinux instead, which is the next comparison).
- On a Debian install, AppArmor has been enabled by default for several releases, but always confirm it on your own machine rather than assuming.

## Useful Command to check AppArmor
| Command | Shows |
|---|---|
| `sudo aa-status` | Whether AppArmor is loaded, how many profiles exist, and which are in enforce or complain mode |
| `sudo systemctl status apparmor` | Whether the AppArmor service is running |
| `systemctl is-enabled apparmor` | Whether it will start at boot |
| `ls /etc/apparmor.d/` | The folder where profiles are stored |
| `sudo journalctl -k \| grep -i apparmor` | AppArmor messages in the kernel log, including blocked actions (look for `DENIED`) |

---

# Sudo
`sudo` stands for “superuser do” (some also read it as “substitute user do”). It is a program that lets a normal user run one command with the privileges of another user, by default root.
Details in `man sudoers`

## Sudo Installation
```
su - // change to root
apt install sudo // install sudo
```

## Configure sudoers

### Path to configure
- *Path to edit*: `/etc/sudoers.d/sudo_config`.
- use *visudo* to edit the file.
- the name of the file must not contain "." or end with "~".

```
// sudo added if sudo-user or no sudo if execute as root
visudo -f /etc/sudoers.d/sudo_config
```

### Rules to configure
```
Defaults    requiretty
Defaults    secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
Defaults    passwd_tries=3
Defaults    badpass_message="Bad password, try again."
Defaults    log_input, log_output
Defaults    iolog_dir="/var/log/sudo"
```
> `Defaults logfile="/var/log/sudo/sudo_log"` is an option for ease to count the log number in monitoring.sh 

> After save the configure file, check with `visudo -c` and `sudo -l`.

| File | What it controls | How to edit | In practice |
|---|---|---|---|
| **`/etc/sudoers`** | **Policy (main file)**: who may use sudo, what they may run, and how sudo behaves (password attempts, logging, PATH, etc.). It ships with the OS as the default rulebook. | Only with `sudo visudo`, never a plain editor like `nano`. Avoid changing it directly: its header says to put local content in `/etc/sudoers.d/` instead. | Treated as the package's default file, mostly left as it is |
| **`/etc/sudoers.d/<file name>`** | **Policy (local files)**: the same rules and syntax as `sudoers`, in separate files that the main file includes. File names must not contain a `.` or end with `~`, or sudo skips them. | `sudo visudo -f /etc/sudoers.d/<file name>` | The usual place for admin-written rules and settings |
| **`/etc/sudo.conf`** | **Program settings**: how the `sudo` program itself loads, such as which plugins to use and debug options. It does not decide who may run what. | Edit as root with a normal editor. It is not checked by `visudo`. | Rarely edited on most systems |

---

# User
A user is an account on the system: a named identity that owns files, runs programs and has permissions. Every program that runs does so as some user, which is how Linux decides what it may touch.

## Where user information is stored
| File | Holds |
|---|---|
| `/etc/passwd` | The list of users (readable by everyone, **no passwords** despite the name) |
| `/etc/shadow` | Password hashes and aging info (root only) |
| `/etc/group` | The list of groups and their members |

There are three kinds:
| Kind | UID range (typical) | Purpose | Can log in? |
|---|---|---|---|
| **root** | 0 | The administrator | Yes (but SSH login is disabled in your project) |
| **System users** | 1 to 999 | Accounts for services (for example the web server, or `sshd`) | No, usually have no shell |
| **Regular users** | 1000 and up | Real people, like `hukhaw` | Yes |

## How to add user
> `man adduser` for more details.

Debian has two tools, and they behave differently:

| | **`adduser`** | **`useradd`** |
|---|---|---|
| Style | Friendly, interactive script (Debian-specific) | Low-level program, found on all Linux distros |
| Creates home directory | **Yes** | **No**, unless you add `-m` (or the system default says so) |
| Copies starter files from `/etc/skel` | Yes | Only with `-m` |
| Asks for a password | **Yes**, right away | No: the account has no usable password until you run `passwd` |
| Creates a matching group | Yes | Depends on the system setting |
| Default shell | A proper login shell | May default to a basic `sh`, unless you give `-s` |
| Good for | Typing at the terminal | Scripts and automation |

## How to delete a user
| Goal | Command |
|---|---|
| Delete the user, keep the home folder | `sudo deluser <username>` |
| Delete the user **and** their home directory | `sudo deluser --remove-home <username>` |

---

# groups
Every file on Linux has an owner. Imagine a server with 20 users. You want 5 of them (the web team) to edit the website files, and the other 15 to have no access.

- Giving each file to one user doesn’t work, because the others need access too.
- Setting permissions for all 20 individually is slow and easy to get wrong.
- Giving everyone access is unsafe.

A group solves this. You put the 5 users in one group, give the group access to the files once, and you’re done. When someone joins or leaves the team, you change their group membership and nothing else.

## Where groups are stored
| File | What it holds |
|---|---|
| `/etc/group` | The list of groups, their GIDs, and their members |
| `/etc/passwd` | The list of users, including each user's **primary** group number |

## Commands to look at groups
| Command | Shows |
|---|---|
| `groups` | The groups **you** belong to |
| `groups <username>` | The groups of another user |
| `id` | Your UID, primary GID, and all groups, with their numbers |
| `getent group <groupname>` | One group's line, with its members |
| `getent group` | All groups |
| `cat /etc/group` | The raw group file |

## Commands to change groups
| Task | Command |
|---|---|
| Create a group | `sudo groupadd <groupname>` |
| Add a user to a group (**keeps** their other groups) | `sudo usermod -aG <groupname> <username>` |
| Change a user's **primary** group | `sudo usermod -g <groupname> <username>` |
| Remove a user from a group | `sudo gpasswd -d <username> <groupname>` |
| Delete a group | `sudo groupdel <groupname>` |

## To add group user42
```
sudo groupadd user42
```

## Assign user to sudo and user42 group
```
sudo usermod -aG hukhaw user42
usermod -aG hukhaw sudo // must in root mode
```

---

# User Password

## /etc/login.defs
The name means "login_defaults"./etc/login.defs is a plain text configuration file that holds system-wide default settings for user accounts and passwords: how long passwords last, the range of numbers given to new users, the default permissions of new home folders, and so on.

### configure Password aging controls Rules
*sudo to edit the path:*

```
sudo nano /etc/login.defs
```

*configure to change: scroll down until Password aging controls part:*
```
PASS_MAX_DAYS   30
PASS_MIN_DAYS   2
PASS_WARN_AGE   7
```
> These configure will only affect new users but not existing users. For existing users, use `chage`.

### Change Password aging controls to existing user
Since the sstep above only affect new user, we need to use `chage` to change the password 
aging to existing users.

*To change password aging for user hukhaw and root:*
```
sudo chage -M 30 -m 2 -W 7 hukhaw
sudo chage -M 30 -m 2 -W 7 root
```

*Check user's password aging*
```
sudo chage -l hukhaw
sudo chage -l root
```

## libpaw-pwquality
- *PAM* (Pluggable Authentication Modules). Many programs on Linux need to check who you are or decide whether to accept a password: login, sudo, ssh, passwd. Instead of each program having its own checking code, they all call PAM, which runs a configurable chain of small modules.
- *pwquality* (password quality). A library called libpwquality that judges whether a new password is good enough: long enough, varied enough, not too simple, and so on.
- *libpam-pwquality* is the Debian package that connects the two.

### libpaw-pwquality Installation
```
sudo apt install libpaw-pwquality
```

### Configure Password Rules
- *Path to edit:* /etc/security/pwquality.conf.
- `man pwquality.conf` to check the config details.

*Things to configure:*
```
difok = 7       // At least 7 characters different from the old password
minlen = 10     // At least 10 characters
dcredit = -1    // Must contain a digit
ucredit = -1    // Must contain an uppercase letter
lcredit = -1    // Must contain a lowercase letter
maxrepeat = 3   // No more than 3 identical characters in a row
usercheck = 1   // Must not contain the user’s name
enfore_for_root // The rules must apply to root too
```

### Change current user's password
```
man passwd          // details usage of passwd
passwd hukhaw       // change user hukhaw password
sudo passwd root    // change root password
```
---

# Network

## Port
Our computer has one network address (called an IP address), but it may run many network programs at the same time: a web server, an SSH server, a database. When a message arrives from the network, how does the computer know which program it is for?

That is what a port answers. A port is a number attached to every network message that says which program should receive it.

### Terms
| Term | Meaning |
|---|---|
| **IP address** | The network address of a machine (for example `10.0.2.15`) |
| **Port** | A number from **0 to 65535** that identifies one service on that machine |
| **Service** | A program that offers something over the network (SSH, web server, database) |
| **Listening** | A service is "listening" on a port when it is waiting for incoming connections there |
| **Open port** | A port with a service listening **and** nothing blocking it |
| **Closed port** | A port where no service is listening |
| **Protocol** | The rules a connection follows. The main two are **TCP** and **UDP** (below). |
| **Connection** | An ongoing conversation between two machines |

### The ranges of Port
The ranges, as defined by IANA (the body that coordinates port numbers):

| Range | Name | Use |
|---|---|---|
| 0 to 1023 | **Well-known ports** | Standard services (SSH, web, mail). On Linux, programs need special privileges to listen on these, traditionally root. |
| 1024 to 49151 | **Registered ports** | Applications registered for specific uses. 4242 is in this range. |
| 49152 to 65535 | **Dynamic / ephemeral ports** | Temporary ports for the **client** side of connections |

### Common ports worth recognizing
| Port | Service | Relevance to you |
|---|---|---|
| 22 | SSH (default) | The one you're moving to 4242 |
| 80 | HTTP (web, unencrypted) | Your bonus lighttpd web server would use this by default |
| 443 | HTTPS (web, encrypted) | Secure websites |
| 53 | DNS (name lookups) | Your machine uses it constantly as a client |
| 25 | SMTP (sending email) | Mail servers |
| 3306 | MariaDB / MySQL | Your bonus database's default |

> On Linux, a file called `/etc/services` lists many of these name-to-number mappings, so you can look them up yourself with `grep -w 22 /etc/services`.

### Command to see port
`sudo ss -tunlp`

| Flag | Meaning |
|---|---|
| `-t` | Show **TCP** sockets |
| `-u` | Show **UDP** sockets |
| `-n` | Show **numbers** instead of translating them to names |
| `-l` | Show only **listening** ones |
| `-p` | Show which **process** owns each port (needs `sudo`) |

## TCP and UDP
| | **TCP** | **UDP** |
|---|---|---|
| Style | Careful: sets up a connection first, confirms delivery, resends lost pieces | Fast and simple: just sends, with no confirmation |
| Analogy | A phone call (both sides confirm they're connected) | Dropping postcards in the mail |
| Used for | SSH, web pages, email, file transfer | Video calls, games, DNS lookups |

## IPv4 & IPv6
Every device on a network needs an address, like a postal address, so data knows where to go. This address is called an IP address (IP = Internet Protocol). IPv4 and IPv6 are two versions of the same idea, with different formats and sizes. The “v” stands for version.

### IPv4
- Four numbers from 0 to 255, separated by dots (dotted decimal).
- Example: 10.0.2.15. This is the address in the subject’s example output, and I believe it’s the default address VirtualBox gives a VM in NAT mode.
- Under the hood it’s a 32-bit number, which gives about 4.3 billion possible addresses.

### IPv6
- Eight groups of hexadecimal digits, separated by colons.
- Example: 2001:0db8:0000:0000:0000:ff00:0042:8329
- Under the hood it’s a 128-bit number, which gives roughly 3.4 × 10^38 addresses (a number so large that running out is not a realistic worry).

## NAT
NAT stands for Network Address Translation. It lets many devices share one address by having a middleman translate between the private side and the outside world.

### Terms related to NAT
| Term | Meaning |
|---|---|
| **Private address** | An address that only works inside a local network (for example `10.0.2.15`). We saw the ranges in the IPv4 lesson. |
| **Public address** | An address reachable on the open internet |
| **Translation** | The middleman rewrites the address on each packet as it passes through |
| **Port forwarding** | A rule: "traffic arriving at this port on the outside goes to that port on this inside machine" |
| **Host** | Your real computer |
| **Guest** | The VM inside it |

---

# SSH
Your Debian VM is a server, and you want to control it from another computer, typing commands as if you were sitting in front of it. That is called remote administration, and real servers in data centers are managed this way because nobody walks up to them with a keyboard.

Before SSH, the common tool was Telnet. Telnet sends everything, including your password, as plain readable text. Anyone on the network path between you and the server could read it.

SSH (Secure Shell) does the same job, but encrypts everything. SSH was created in the mid-1990s as a secure replacement for Telnet and similar tools, and the version used today is SSH-2.

## Configure SSH

### Differences between SSHD config files
| Path | Type | Configures | Used by |
|---|---|---|---|
| `/etc/ssh/ssh_config` | File | **Client** defaults for everyone on this machine | The `ssh` command |
| `/etc/ssh/ssh_config.d/` | Folder | Extra client settings, included by the file above | The `ssh` command |
| `/etc/ssh/sshd_config` | File | **Server** settings: port, who may log in, authentication rules | The `sshd` service |
| `/etc/ssh/sshd_config.d/` | Folder | Extra server settings, included by the file above | The `sshd` service |

### Config SSHD
- `man sshd_config` for more details.
- config files under `/etc/ssh/sshd_config.d` must *end with .conf*.

*Editing the config:*
```
sudo nano /etc/ssh/sshd_config.d/sshd.conf
```

*Things to config:*
```
Port 4242
PermitRootLogin no
```
> Before restart SSH, checking the config error with command `sudo sshd -t`. Otherwise, SSH may be crashed and will lock from VM.

### Checking SSHD config
| Command                                       | Core Function                                                                | Common Use Case                                                |
| --------------------------------------------- | ---------------------------------------------------------------------------- | -------------------------------------------------------------- |
| `sudo sshd -t`                                | Test configuration file syntax for errors                                    | Before restarting the SSH service after editing configurations |
| `sudo sshd -T`                                | Dump all fully parsed and active settings                                    | When verifying which parameters are currently applied          |
| `sudo sshd -T \| grep -E "port|permitrootlogin"` | Filter parsed settings to check specific options (Port, PermitRootLogin)     | Quickly verifying specific SSH security configurations         |
| `sudo systemctl status ssh`                   | Check the current runtime state, active status, PID, and recent service logs | To verify if the SSH service is running correctly after a change |

## Connect to VM SSH
How they connect to VM SSH:
```
B or A  --->  Host IP : Host Port  --->  VirtualBox  --->  Guest IP : Guest Port (sshd in the VM)
```
### The Meaning VirtualBox port forwarding fields

| Field | Meaning | Required? | Value for your project |
|---|---|---|---|
| **Protocol** | The type of connection. SSH uses **TCP**. | Yes | `TCP` |
| **Host IP** | Which address on computer A the rule listens on | No | Blank (B or others can connect) or `127.0.0.1` (only A itself) |
| **Host Port** | The port on computer A that you connect to | Yes | Any free port, for example `8080`, `4242` |
| **Guest IP** | The address of the VM that receives the traffic | No | Blank (simplest) |
| **Guest Port** | The port inside the VM where `sshd` listens | Yes | `4242` |

### Step to Connect
1. Close te VM.
2. Select the VM, then Settings > Network > Adapter 1, and make sure it is NAT.
3. Open Advanced > Port Forwarding and add a rule:
      | Field | Value |
      |---|---|
      | Name | `ssh` |
      | Protocol | TCP |
      | Host IP | Blank (to connect from B) or `127.0.0.1` (only from A) |
      | Host Port | `4242` (or any free port) |
      | Guest IP | Blank |
      | Guest Port | `4242` |
4. Start the VM and keep the VM running.
5. Connect 
      | From where | Command |
      |---|---|
      | local (the one running the VM) | `ssh -p 4242 testuser@127.0.0.1` or `ssh -p 4242 testuser@localhost`|
      | another computer on the same network | `ssh -p 4242 testuser@<A's IP address>` |

---

# UFW
UFW stands for Uncomplicated Firewall. The Linux kernel does the real packet filtering (through tools called iptables/nftables, which are hard to read). Its model is simple:

| Concept | Meaning |
|---|---|
| **Default policy** | What happens to traffic that matches no rule. UFW's usual default is to **deny incoming** and **allow outgoing**. |
| **Rule** | An exception to the default, such as "allow incoming TCP on 4242" |
| **Enabled / disabled** | UFW is installed but **inactive** until you turn it on |

## UFW Installation 
```
sudo apt install ufw
sudo ufw --version      // to see the ufw version
sudo ufw status         // check the status, it should be inactive before you enable
man ufw                 // check the ufw manual
```

## Allow Port and enable UFW
```
sudo ufw allow 4242     // allowing port 4242
sudo ufw enable         // activate ufw and enabled on system startup
sudo ufw status verbose // checking ufw status details, should be see the active details
```

## Usefull command for UFW
| Check or action | Command |
|---|---|
| Is it active, and which rules exist? | `sudo ufw status` |
| Defaults and logging level | `sudo ufw status verbose` |
| Rules with numbers (needed for deleting) | `sudo ufw status numbered` |
| **Delete a rule by number** | `sudo ufw delete <number>` |
| **Delete a rule by its definition** | `sudo ufw delete allow 22/tcp` |
| Does it start at boot? | `systemctl is-enabled ufw` |
| Is the service running? | `systemctl status ufw` |
| Does the port really listen? | `sudo ss -tunlp` |

---

# Cron
cron is Linux’s scheduling service. You tell it “run this command at this time”, and it runs the command in the background without anyone being there.
| Term | Meaning |
|---|---|
| **cron** | The background service (a daemon) that runs scheduled jobs |
| **crontab** | "cron table": the file holding the schedule. Each line is one job. |
| **Job** | One line in a crontab: a time pattern plus a command |

## Command to check the cron manual
| Command | What it covers |
|---|---|
| `man cron` | The cron service itself |
| `man crontab` | The `crontab` command (edit, list, remove) |
| `man 5 crontab` | The **file format**: the five time fields and special strings like `@reboot` |

> The number 5 selects section 5 of the manual (file formats). Without it, man crontab shows the command’s page instead. For this project, man 5 crontab is the most useful one.

## cron rules
Each line has this format:
```
minute  hour  day  month  weekday  command
```
| Field | Range |
|---|---|
| Minute | 0 to 59 |
| Hour | 0 to 23 |
| Day of month | 1 to 31 |
| Month | 1 to 12 |
| Day of week | 0 to 7 (0 and 7 are both Sunday) |

### Special symbols and examples:
| Written | Runs |
|---|---|
| `* * * * *` | Every minute |
| `*/10 * * * *` | Every 10 minutes |
| `0 * * * *` | At the start of every hour |
| `@reboot` | Once, each time the system boots (replaces the five fields) |

## How to set up cron
There are two places to put the schedule. Choose one, and don’t use both, or the script runs twice and you get duplicate broadcasts.
| Where | Format | When to use |
|---|---|---|
| **Root's own crontab** (`sudo crontab -e`) | `time  command` | **Recommended.** Simplest, and the job already runs as root. |
| **`/etc/crontab`** or a file in **`/etc/cron.d/`** | `time  user  command` (one extra field) | Optional alternative for system-wide jobs |

### Option A: root’s crontab
```
sudo crontab -e
```

>The first time, it may ask which editor to use. Choose one you know, such as nano

Lines to write:
```
@reboot           /home/hukhaw/monitoring.sh
*/10 * * * *      /home/hukhaw/monitoring.sh
```

#### Other crontab commands:
| Command | Does |
|---|---|
| `sudo crontab -l` | Lists root's current jobs |
| `sudo crontab -e` | Edits them |
| `sudo crontab -r` | **Deletes the whole crontab immediately, with no confirmation.** Avoid it. |

### Option B: system files `/etc/cron.d`(optional)
Same time pattern, but with a user field between the time and the command, because these files don’t belong to any one user:

Lines to write:
```
@reboot           /home/hukahw/monitoring.sh
*/10 * * * *      /home/hukhaw/monitoring.sh
```

> Remember: whichever option you choose, the script path must be the full path, and the script must contain no sudo.

## Checking whether cron is active
| Check | Command | What you want to see |
|---|---|---|
| Is the service running? | `systemctl status cron` | `active (running)` |
| Short answer | `systemctl is-active cron` | `active` |
| Starts at boot? | `systemctl is-enabled cron` | `enabled` |
| Is my job installed? | `sudo crontab -l` | Your lines |
| Did cron actually run it? | `sudo journalctl -u cron -n 20` | Entries mentioning your command |

## Interupt cron
| Method | Touches `monitoring.sh`? | Touches the crontab? |
|---|---|---|
| Comment the lines out in `sudo crontab -e` | No | Yes |
| `sudo systemctl stop cron` | No | No |