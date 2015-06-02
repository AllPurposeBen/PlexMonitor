#!/bin/bash

# Vars and shit
homePath="/path/to/where/script/lives"
pushoverToken=""
pushoverUser=""
timeStamp=`date +"%Y-%m-%d %H:%M"`

#Function for sending pushover notifications
pushNotification () {
	curl -s -F "token=$pushoverToken" -F "user=$pushoverUser" -F "title=W13 Plex Warning" -F "message=$1" https://api.pushover.net/1/messages.json >/dev/null
}

# Wait 90 seconds just in case we just rebooted, give Plex a chance to load
sleep 90

# Is plex running?
plexRunningPid=`ps -ax | grep "/Applications/Plex Media Server.app/Contents/MacOS/Plex Media Server" | grep -v grep | awk -F ' ' '{print $1}'`

if [ -z "$plexRunningPid" ]; then
	# Plex isn't running, is there a "notification sent" flag?
	if [ ! -e "$homePath/notificationSent" ]; then
		# No flag, set and notify
		echo "$timeStamp" > "$homePath/notificationSent"
		pushNotification "Plex is down."
	fi
else
	# Plex is running
	if [ -e "$homePath/notificationSent" ]; then
		# Running now but there is a sent notification flag, clear it and send a positive message
		pushNotification "Plex is back up"
		rm "$homePath/notificationSent" 
	fi
fi

exit 0
		
