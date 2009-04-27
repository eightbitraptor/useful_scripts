#! /bin/bash
PATH=/bin:/usr/bin
# grab the load average for the last minute and convert it to an integer
thisloadavg=`cat /proc/loadavg | awk -F \. '{print $1}'`
psfile=ps-`date +%y%m%d-%H%M`.txt

usedmem=`free -m | grep "buffers/cache" | awk '{print $4}'`
totmem=`free -m | grep Mem | awk '{print $2}'`

let memperc=(usedmem*100)/totmem

if [ $memperc -lt 10 ] || [ $thisloadavg -gt 10 ]; then
	mkdir -p ~/pstmp
	uptime > ~/pstmp/$psfile
	ps -ef >> ~/pstmp/$psfile
	free -m >> ~/pstmp/$psfile
else
	echo "load: $thisloadavg, memperc: $memperc"
fi
