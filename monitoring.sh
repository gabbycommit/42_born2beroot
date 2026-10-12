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



wall "#Architecture: $arch
#Physical CPU: $fcpu
#vCPU: $vcpu
#Memory used: $used_ram/${total_ram}MB ($percent_ram%)
"