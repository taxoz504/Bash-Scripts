This is for auto restarting a Minecraft server on linux

Type "crontab -e" into the terminal

put in "0 */8 * * * path to/restart.sh > /dev/null 2>&1" (the 0 */8 means it runs the script on top of every 8th)