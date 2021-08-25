#!/usr/bin/env bash
currentUser=$USER
if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi
if [[ -z $1 || $1 == "0" || $1 == "1" ]]; then
	mode=$([ -z $1 ] && echo "1" || echo $1)
	modeMessage=$([ "$mode" == 1 ] && echo "on 🟢" || echo "off ⛔")

	echo $mode >> /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
	if [[ $? == 0 ]]; then
		
		echo "Conservation mode $modeMessage"
		sudoUserId=$(id -u $SUDO_USER)
		sudo -u $SUDO_USER DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$sudoUserId/bus notify-send -a "Lenovo S340" "Conservation mode $modeMessage "
	fi
else
	echo "Please provide argument 1 to turn on, or 0 to turn off"
	exit 1;
fi
