#!/bin/bash
# Philips Hue API doc: https://developers.meethue.com/develop/get-started-2/ <-- how to get bridge IP + API key

PH_BRIDGE_IP='192.168.x.x'
PH_API_KEY='XXXXXXXXXXXXXXXXXXXXXXXXX'
PH_LAST_HUE=65535

# Simple control for the Philips Hue lights, with just a few main colors
lights() {
	if [ -z $1 ]
	then
		echo "Available options: red, orange, yellow, green, aqua, blue, purple, white / on, black / out / off"
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
			magenta | purple)
				HUE=54612
				SAT=254
				;;
			black | out | off)
				HUE=${PH_LAST_HUE}
				SAT=254
				LIGHT=false
				;;
			* | white | on)
				HUE=65535
				SAT=0
				;;
		esac

		PH_LAST_HUE=${HUE}
		JSON="{\"on\":${LIGHT}, \"sat\":${SAT}, \"bri\":254, \"hue\":${HUE}}"
		if [ -z $2 ]
		then
			echo "All lights will turn $1";
			curl --silent --show-error --request PUT --data "${JSON}" http://${PH_BRIDGE_IP}/api/${PH_API_KEY}/groups/1/action > /dev/null
		else
			echo "Light(s) $2 will turn $1";
			case $2 in
				bulbA | a | 1)
					PH_LIGHT=1
					;;
				bulbB | b | 2)
					PH_LIGHT=2	
					;;
				bulbC | c | 3)
					PH_LIGHT=3	
					;;
				bulbD | d | 4)
					PH_LIGHT=4	
					;;
				*)
					PH_LIGHT=0
					;;
			esac
			if [ $PH_LIGHT -ne 0 ]
			then
		 		curl --silent --show-error --request PUT --data "${JSON}" http://${PH_BRIDGE_IP}/api/${PH_API_KEY}/lights/${PH_LIGHT}/state > /dev/null
			else
				curl --silent --show-error --request PUT --data "${JSON}" http://${PH_BRIDGE_IP}/api/${PH_API_KEY}/groups/1/action > /dev/null
  			fi
  		fi
	fi
}

lights $1 $2
