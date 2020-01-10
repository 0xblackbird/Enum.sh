#!/bin/bash

domain=$1
file=$2

if [ -f "$file" ]; then
    echo -e "\e[1;31m$file already exists!\e[0m"
		echo -e "\e[1;31mPlease choose an other file!\e[0m "
		read file
else
	curl -s https://crt.sh/\?q\=\%.$domain\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > $file
	echo -e "\e[1;36m[+] Finished enumerating subdomains using\e[0m \e[1;31mcrt.sh\e[0m"
	wait${!}
fi

echo -e "\e[1;31m[+] Started probing file using httprobe...\e[0m"
# Change this directory to the installation of the the httprobe directory in order to use httprobe!
cat $file | /opt/httprobe/./httprobe > d0m@ins15448.txt
mv d0m@ins15448.txt /root/domains

wait${!}
echo -e "\e[1;36m[+] Finished probing file using httprobe!\e[0m"
echo -e "\e[1;31mOutput has been saved in $file!\e[0m"
echo -e "\e[1;31mExiting...\e[0m"
