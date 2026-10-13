# Mandatory
files to submit: signature.txt, README.md
signature.txt: must paste the signature of your virtual machine's disk into this file (.vdi) in sha1 format.

Rules:
- Project:
    - *system*:
        - install a minimal set of services (*LTS* version of *Debian* or *Rocky*).
        - *AppArmor*(Debian) or *SELinux*(Rocky) must be running at startup.
        - forbidden to instal graphic interface.
        - you need to determine the appropriate size for each partition to ensure proper operation while avoiding unnecessary disk usage.
    
    - *hostname*:
        - must be login ending with 42 (e.g wil42).
    
    - *username*
        - must with your login as the username.
    
    - *sudo*
        - Authentication using sudo has to be limited to 3 attempts in the event of an incorrect password.
        - custom message for incorrect password is entered when using sudo.
        - ***log*** each action performed by sudo, including input and output, in /var/log/sudo/ folder.
        - The TTY mode has to be enabled.
        - paths that can be used by sudo must also be restricted. (/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin)
    
    - *groups*
        - this user have to belong to user42 and sudo group.
    
    - *password*
        - expire every 30days.
        - minimum numbers of days between password changes must be set to 2.
        - user has to receive a warning message 7 days before their password expires.
        - password must be at least 10 characters long.
        - must contain an uppercase letter.
        - must contain a lowercase letter.
        - must contain a number.
        - must contain at least 7 charaters that were not part of the previous password. (this rule is not apply to root due to system side reason).
        - ***must not*** contain more than 3 consecutive identical characters.
        - ***must not*** include the name of the user.
        - ***all password rules must apply to current user and root ***

    - *SSH*:
        - *SSH* service must be running on port 4242.
        - for security reasons, it must not be possible connect using SSH as root.
    
    - *UFW*:
        - leave only 4242 open in your virtual machine.
        - must be active when you launch your virtual machine.

    - monitoring.sh
        - written in bash.
        - refer to pdf.

    - signature.txt


- To understand:
    - *disk size*
        - should able to answer why to choose this size.
    - *system*:
        - the differences between *aptitude* and *apt*.
        - what is *AppArmor*.
    - *hostname*:
        - how to modify hostname.
    - *user*
        - to create new user.
    - *groups*
        - to assign new user to a group.
    - *SSH*:
        - the use of ssh will be tested during defend by setting up a new account.
    - *monitoring.sh*
        - how the script works.
        - have to interrupt it without modifying it. (using cron).

- *Evaluation*:
    - no snapshots may exist at the beginning of each evaluation
