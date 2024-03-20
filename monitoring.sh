#! /bin/bash
archi=$(uname -a)
cpup=$(cat /proc/cpuinfo | grep "physical id" | wc -l)
cpuv=$(cat /proc/cpuinfo | grep processor | wc -l)
ramu=$(free -m | grep Mem | awk '$1 == "Mem:" {print $2, $3}')
ramp=$(free | awk '$1 == "Mem:" {printf("$.2f"), $3/$2*100}')
cpuu=$(grep 'cpu' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}')
	echo ${archi}
	echo ${cpup}
	echo ${cpuv}
	echo ${ramu}
	echo ${ramp}
	echo ${cpuu}
