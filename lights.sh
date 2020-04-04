#!/bin/bash
# Philips Hue API doc: https://developers.meethue.com/develop/get-started-2/ <-- how to get bridge IP + API key

PH_BRIDGE_IP='192.168.x.x'
PH_API_KEY='XXXXXXXXXXXXXXXXXXXXXXXXX'

# Simple control for the Philips Hue lights, with just a few main colors
lights() {
	if [ -z $1 ]
	then
		echo "Available options: red, orange, yellow, green, aqua, blue, magenta, white / on, black / out / off"
	else
		LIGHT=true

		case $1 in
			red)
				HUE=0
				SAT=254
				;;
			orange)
				HUE=5461
				SAT=254
				;;
			yellow)
				HUE=10922
				SAT=254
				;;
			green)
				HUE=21845
				SAT=254
				;;
			aqua | teal)
				HUE=38228
				SAT=254
				;;
			blue)
				HUE=43690
				SAT=254
				;;
			magenta | pink)
				HUE=54612
				SAT=254
				;;
			black | out | off | dark)
				HUE=65535
				SAT=0
				LIGHT=false
				;;
			*)
				HUE=65535
				SAT=0
				;;
		esac

		JSON="{\"on\":${LIGHT}, \"sat\":${SAT}, \"bri\":254, \"hue\":${HUE}}"
		echo "Lights will turn $1";
		curl --silent --show-error --request PUT --data "${JSON}" http://${PH_BRIDGE_IP}/api/${PH_API_KEY}/groups/1/action > /dev/null
	fi
}

lights $1
