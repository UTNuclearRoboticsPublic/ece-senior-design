for sysdevpath in $(find /sys/bus/usb/devices/usb*/ -name dev); do
	(
		syspath="${sysdevpath%/dev}"
		devname="$(udevadm info -q name -p $syspath)"
		[[ "$devname" == "bus/"* ]] && continue
		eval "$(udevadm info -q property --export -p $syspath)"
		[[ -z "$ID_SERIAL" ]] && continue
		if [[ "$devname" == "video"* ]] 
			then
				if [[ "$ID_SERIAL" == *"KODAK"* ]]
					then
						echo "/dev/$devname"
				fi
		fi
	)
done
