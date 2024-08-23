#!/bin/sh
# Made by WafflesExploits
arg_count=$#
filename=$1
hostname=$2

# Exit if arg_count is less than 2
if [ $arg_count -lt 2 ]; then
  echo "$0 <dns_history_ips.txt> <subdomain.hostname.com>"
  exit 1
fi

while IFS= read -r line
do
  echo "Testing $line"
  curl -k -I --connect-timeout 5 -H "Host: $hostname" "https://$line"
done < "$filename"
