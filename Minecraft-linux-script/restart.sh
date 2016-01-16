#!/bin/sh
screen -x mcmodded
sleep 2
screen -S mcmodded -X stuff "say Server restarting in 1 minute"
screen -S mcmodded -X eval "stuff \015"
sleep 30
screen -S mcmodded -X stuff "say Server restarting in 30 seconds"
screen -S mcmodded -X eval "stuff \015"
sleep 15
screen -S mcmodded -X stuff "say Server restarting in 15 seconds"
screen -S mcmodded -X eval "stuff \015"
sleep 5
screen -S mcmodded -X stuff "say Server restarting in 10 seconds"
screen -S mcmodded -X eval "stuff \015"
sleep 5
screen -S mcmodded -X stuff "say Server restarting in 5 seconds"
screen -S mcmodded -X eval "stuff \015"
sleep 1
screen -S mcmodded -X stuff "say Server restarting in 4 seconds"
screen -S mcmodded -X eval "stuff \015"
sleep 1
screen -S mcmodded -X stuff "say Server restarting in 3 seconds"
screen -S mcmodded -X eval "stuff \015"
sleep 1
screen -S mcmodded -X stuff "say Server restarting in 2 seconds"
screen -S mcmodded -X eval "stuff \015"
sleep 1
screen -S mcmodded -X stuff "say Server restarting in 1 second"
screen -S mcmodded -X eval "stuff \015"
sleep 1
screen -S mcmodded -X stuff "say Server is restarting. Will take 30-45 seconds to boot up again"
screen -S mcmodded -X eval "stuff \015"
sleep 1
screen -S mcmodded -X stuff "say Next server restart is in 4 hours"
screen -S mcmodded -X eval "stuff \015"
sleep 4
screen -S mcmodded -X stuff 'stop'
screen -S mcmodded -X eval "stuff \015"
sleep 15
screen -wipe
sleep 2
cd path to minecraft server folder
./start.sh
