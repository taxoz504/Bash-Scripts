#!/bin/sh
screen -x modded
sleep 2
screen -S modded -X stuff "say restarting in 1 minute"
screen -S modded -X eval "stuff \015"
sleep 30
screen -S modded -X stuff "say restarting in 30 seconds"
screen -S modded -X eval "stuff \015"
sleep 15
screen -S modded -X stuff "say restarting in 15 seconds"
screen -S modded -X eval "stuff \015"
sleep 5
screen -S modded -X stuff "say restarting in 10 seconds"
screen -S modded -X eval "stuff \015"
sleep 5
screen -S modded -X stuff "say restarting in 5 seconds"
screen -S modded -X eval "stuff \015"
sleep 1
screen -S modded -X stuff "say restarting in 4 seconds"
screen -S modded -X eval "stuff \015"
sleep 1
screen -S modded -X stuff "say restarting in 3 seconds"
screen -S modded -X eval "stuff \015"
sleep 1
screen -S modded -X stuff "say restarting in 2 seconds"
screen -S modded -X eval "stuff \015"
sleep 1
screen -S modded -X stuff "say restarting in 1 second"
screen -S modded -X eval "stuff \015"
sleep 1
screen -S modded -X stuff "say is restarting. Will take 30-45 seconds to boot up again"
screen -S modded -X eval "stuff \015"
sleep 1
screen -S modded -X stuff "say Next restart is in 3 hours"
screen -S modded -X eval "stuff \015"
sleep 4
screen -S modded -X stuff 'stop'
screen -S modded -X eval "stuff \015"
sleep 15
screen -wipe
sleep 2
screen -ls | awk '/\.modded\t/ {print strtonum($1)}' > SET PATH TO SERVER FOLDER!!!/pid/kill.pid
sleep 1
PIDFile="SET PATH TO SERVER FOLDER!!!/pid/kill.pid"
File=`stat -c %s SET PATH TO SERVER FOLDER!!!/pid/kill.pid`



# This was made due to we had problems with screen sometimes froze so it more of a failsafe to stop the server.
# First part of the script checks if the script is working the "awk" above will grap the PID of the screen,
# The reason this work is if the above stop scrpt works it will stop the server and close the screen

if [ $File -lt 1 ];then
	rm pid/kill.pid
	sleep 2
cd SET PATH TO SERVER FOLDER!!!
sleep 1
sh ./start.sh
else
	sleep 2
kill -9 $(<"$PIDFile")
	sleep 2
	rm pid/kill.pid
	sleep 2
	screen -wipe
	sleep 2
cd SET PATH TO SERVER FOLDER!!!
sleep 1
sh ./start.sh
fi


