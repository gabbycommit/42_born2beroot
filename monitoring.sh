# architecture
arch=$(uname -a)

# fcpu
fcpu=$(grep "^physical id" /proc/cpuinfo | sort -u | wc -l)

# vcpu
vcpu=$(nproc)

# RAM
total_ram=$(free --mega | awk 'NR==2 {print $2}')
used_ram=$(free --mega | awk 'NR==2 {print $3}')
percent_ram=$(awk -v t=$total_ram -v u=$used_ram 'BEGIN {print u/t*100}')

# Disk
total_disk=$(df -BMB | grep "^/dev/" | awk '{sum += $2} END {print sum}')
used_disk=$(df -BMB | grep "^/dev/" | awk '{sum += $3} END {print sum}')
percent_disk=$(awk -v $total_disk -v $used_disk 'BEGIN {printf ".0f", u/t*100}')

# cpu load
cpu_load=$(vmstat 1 2 | tail -1 | awk '{printf "%.1f", 100 - $15}')

# last boot
last_boot=$(who -b | awk '{print $3, $4}')

# lvm use
nlvm=$(lsblk -o TYPE | grep -c "^lvm")
is_lvm="no"
if [ nlvm -ge 1 ]; then
    is_lvm="yes"
fi

# tcp connections
tcp_connections=$(ss -tH state established | wc -l)

# user log
user_log=$(w -h | wc -l)

# Network
ip=$(hostname -I | awk '{print $1}')
mac=$(ip addr | grep "link/ether" | awk '{print $2}')

# sudo cmd count
cmd_count=$(journalctl _COMM=sudo | grep "COMMAND=" | wc -l)

wall "#Architecture: $arch
#Physical CPU: $fcpu
#vCPU: $vcpu
#Memory used: $used_ram/${total_ram}MB ($percent_ram%)
#Disk Usage: $used_disk/$(($total_disk/1000))GB ($percent_disk%)
#CPU load: $cpu_load%
#Last boot: $last_boot
#LVM use: $is_lvm
#TCP Connections: $tcp_connections ESTABLISHED
#User log: $user_log
#Network: IP
#Sudo: $cmd_count cmd
"