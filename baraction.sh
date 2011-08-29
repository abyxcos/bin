#!/bin/sh
# baraction.sh for scrotwm status bar

SLEEP_SEC=3

while :; do
	BATTERY=`battery.pl -m -p -t`

	DATE=`date "+%H:%M %d.%b.%Y"`

	SSID=`wpa_cli status | sed -n -r 's/^ssid=(.*)/\1/p'`
	if [ -x $SSID ]
		then SSID="Not Connected"
	fi

	PLAYING=`mpc status | sed -n -r 's/^(\[.*\]).*/\1/p'`
	if [ $PLAYING == "[playing]" ]
		then PLAYING=`mpc -f "%title% - %album% - %artist%" current | sed -r 's/(.{0,25}).*? - (.*) - (.*)/\1 - \2 - \3/'`
	fi

	echo -e "$DATE :: $SSID :: $BATTERY :: $PLAYING"

	sleep $SLEEP_SEC
done

