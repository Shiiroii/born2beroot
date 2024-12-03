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
#free -m permet de voir la quantité de mémoire libre, le -m pour mettre en mégaoctets, une unité de capacité de stockage d'informations
#grep Mem permet de trouvera la ligne Mem sortie du free -m et printera $2 qui représente le deuxième argument de cette ligne, $3 la troisième, etc..
#{printf("%.2f"), $3/$2*100}, %.2f permet de formater la sortie avec deux chiffres après la virgule, $3/$2*100 permet de calculer l'utilisation de la mémoire
rama=$(free -m | grep 'Mem' | awk '{print $2}')
ramu=$(free -m | grep 'Mem' | awk '{print $3}')
ramp=$(free -m | grep 'Mem' | awk '{printf("%.2f"), $3/$2*100}')
#Memory
#df permet de donner l'utilisation du disque, -Bg pour donner la quantité en bloc de données en gigaoctets, -Bm bloc en mégaoctets, -m en mégaoctets 
#grep trouve les lignes qui commencent par dev (partition disks) et qui finissent par boot, puis rajoute la donneé à disk_...
mema=$(df -Bg | grep "^/dev/" | grep -v "/boot$" | awk '{disk_total += $2} END {print disk_total}')
memu=$(df -Bm | grep "^/dev/" | grep -v "/boot$" | awk '{disk_used += $3} END {print disk_used}')
memp=$(df -m | grep "^/dev/" | grep -v "/boot$" | awk '{disk_used += $3} {disk_total += $2} END {printf("%.2f"), disk_used/disk_total*100}')
#CPU
#top permet de voir en temps réel les activités du système, comme par exemple les processus et threads actuellement en cours
#-bn1 permet d'avoir automatiquement la sortie, b pour le mode batch, (pas d'itérations en temps réel), n1 car il y aura qu'une seule itération.
#résultat de la 2ème et 4ème colone en décimale, avec un %
cpua=$(top -bn1 | grep "^%Cpu" | xargs | awk '{printf("%.1f%%"), $2 + $4}')
#Last reboot
#who -b permet de voir le dernier démarrage du système, puis extrait la troisème et quatrième donnée qui sont la date et l'heure et met un espace 
rebo=$(who -b | awk '{print $3 " " $4}')
#LVM
#utilise lsblk et cherche les lignes avec lvm, si il y en a présentes, un nombre suppérieur à zero, ça print yes, sinon non.
lvmu=$(if [ $(lsblk | grep 'lvm' | wc -l) -gt 0 ]; then echo yes; else echo no; fi)
#Connections
#ss -t permet d'afficer les informations sur les sockets TCP (-t), que celles établies (ESTAB), et compte le nombre de lignes
tcpa=$(ss -t | grep ESTAB | wc -l)
#Users
#users permet de voir les utilisateurs connectés et compte le nombre de mots
user=$(users | wc -w)
#IP and MAC
#hostname permet de voir l'adresse ip de l'utilisateur local
#ip link show montre toutes les interfaces réseau de l'hôte, cherche la ligne avec ether (pour les adresses MAC) et print la deuxième donnée (adresse MAC)
adip=$(hostname -i)
macu=$(ip link show | grep ether | awk '{print $2}')
#Numb of sudo commands
#journalctl affiche les journaux du système, celle de la commande sudo, cherche les lignes avec COMMAND et compte le nombre de lignes
sunu=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "	#Architecture: $archi
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

