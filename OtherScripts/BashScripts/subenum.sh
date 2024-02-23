#!/bin/bash
# Steps
# 1. Enumeration
# 2. Check if website is alive
# 3. Gowitness

domain=$1

if [ -z "$domain" ]; then
	echo "./subdomain.sh <domain>"
	exit 1
fi
# Define directories
base_dir="$domain"
info_path="$base_dir/info"
screenshot_path="$base_dir/screenshots"

temp1_txt="$info_path/temp1.txt"
temp2_txt="$info_path/temp2.txt"
subdomain_txt="$info_path/subdomain.txt"
amass_txt="$info_path/amass.txt"

echo "Target set to: $domain"

# Create directories if they don't exist
for path in "$info_path" "$screenshot_path"; do
    if [ ! -d "$path" ]; then
        mkdir -p "$path"
        echo "Created directory: $path"
    fi
done

# Do Whois scan on domain
echo "Running whois for $domain..."
whois "$domain" > "$info_path/whois.txt"

# Subdomain enum

echo "Running subdomain enumeration..."
subfinder -d $domain -silent > $temp1_txt
assetfinder $domain >> $temp1_txt # Also finds assets associated to the domain
sort -u $temp1_txt > $temp2_txt
echo "Amass enum for $domain stored in $info_path."
amass enum -d tcm-sec.com -o $amass_txt -silent&

# Verify if alive
echo "Checking which Address are alive..."
halive.py $temp2_txt | grep -P ".* \d\d\d" | cut -d " " -f 1 | sort > $subdomain_txt
echo "Alive address stored in $subdomain_txt."
rm $temp1_txt
rm $temp2_txt

# pics
echo "taking pictures..."
gowitness file -f $subdomain_txt -F -X 1280 -Y 720 -P $screenshot_path --chrome-path /usr/bin/chromium --disable-db --disable-logging
echo "Pictures stored in $screenshot_path."

