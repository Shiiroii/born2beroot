#! /bin/bash
archi=$(uname -a)
cpup=$(cat /proc/cpuinfo | grep "physical id" | wc -l)
cpuv=$(cat /proc/cpuinfo | grep processor | wc -l)
ramu=$(free -m | grep Mem | awk '$1 == "Mem:" {print $2, $3}')
ramp=$(free | awk '$1 == "Mem:" {printf("$.2f"), $3/$2*100}')
cpuu=$(grep 'cpu' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}')
rebo=$(who -b | awk '{print $3, $4}')

	echo "Architecture = $archi%"
	echo "Physical processors = $cpup"
	echo "Virtual processors = $cpuv"
	echo "RAM usage = $ramu%"
	echo "RAM $ramp"
	echo "$cpuu"
	echo "Last reboot = $rebo"
