#! /bin/bash

# grab the load average for the last minute and convert it to an integer
loadavg=`uptime | awk '{print $10}'`
thisloadavg=`echo $loadavg|awk -F \. '{print $1}'`
declare -i thisloadavg
echo $thisloadavg

psfile=ps-`date +%y%m%d-%H%M`.txt

if [ -d ~/pstmp ]; then
	echo "nothing to do"
else
	mkdir ~/pstmp
fi

usedmem=`free -m | grep "buffers/cache" | awk '{print $4}'`
totmem=`free -m | grep Mem | awk '{print $2}'`

memperc=`echo "scale=3;$usedmem/$totmem * 100" | bc | awk -F \. '{print $1}'`
echo $memperc

if [ $memperc -lt 10 ] || [ $thisloadavg -gt 10 ]; then
	ps -ef > ~/pstmp/$psfile
fi
