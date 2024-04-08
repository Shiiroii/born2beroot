#! /bin/bash

#Architecture
#uname utilisé pour print le système d'exploitation sur lequel tu travailles, -a pour tout print
archi=$(uname -a)
#Physical CPU
#cat /proc/cpuinfo utilisé pour obtenir les informations du processeur, grep "physical id" permet de trouver le cpu physique
cpup=$(cat /proc/cpuinfo | grep "physical id" | wc -l)
#Virtual CPU
#grep processor permet de trouver le nombre de CPU
cpuv=$(cat /proc/cpuinfo | grep 'processor' | wc -l)
#RAM
#free -m permet de voir la quantité de mémoire libre, le -m pour mettre en mebibytes, une unité de capacité de stockage d'informations
#grep Mem 
rama=$(free -m | grep 'Mem' | awk '{print $2}')
ramu=$(free -m | grep 'Mem' | awk '{print $3}')
ramp=$(free -m | grep 'Mem' | awk '{printf("%.2f"), $3/$2*100}')
#Memory
mema=$(df -Bg | grep "^/dev/" | grep -v "/boot$" | awk '{disk_total += $2} END {print disk_total}')
memu=$(df -Bm | grep "^/dev/" | grep -v "/boot$" | awk '{disk_used += $3} END {print disk_used}')
memp=$(df -m | grep "^/dev/" | grep -v "/boot$" | awk '{disk_used += $3} {disk_total += $2} END {printf("%.2f"), disk_used/disk_total*100}')
#CPU
cpua=$(top -bn1 | grep "^%Cpu" | xargs | awk '{printf("%.1f%%"), $2 + $4}')
#Last reboot
rebo=$(who -b | awk '{print $3 " " $4}')
#LVM
lvmu=$(if [ $(lsblk | grep 'lvm' | wc -l) -gt 0 ]; then echo yes; else echo no; fi)
#Connections
tcpa=$(ss -t | grep ESTAB | wc -l)
#Users
user=$(users | wc -w)
#IP and MAC
adip=$(hostname -i)
macu=$(ip link show | grep ether | awk '{print $2}')
#Numb of sudo commands
sunu=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "	#Architecture: $arc
		#Physical CPU: $cpup
		#Virtual CPU: $cpuv
		#RAM utilization: $ramu/${rama}MB ($ramp%)
		#Memory utilization: $memu/${mema}Gb ($memp%)
		#CPU utilization: $cpua
		#Last reboot: $rebo
		#LVM: $lvmu
		#TCP: $tcpa ESTABLISHED
		#Active users: $user
		#IP adress and MAC: IP $adip ($macu)
		#Number of sudo: $sunu cmd"

