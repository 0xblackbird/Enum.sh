#!/bin/bash

printf '\033[8;25;120t'
domain=$1
file=$2

# Colors...
red="\e[1;31m"
yellow="\e[1;33m"
orange="\e[1;39m"
blue="\e[1;36m"
green="\e[1;32m"
close="\e[0m"

echo -e "${red}
  _____ _    _ ____  _____   ____  __  __          _____ _   _    _____  _____          _   _ _   _ ______ _____  
 / ____| |  | |  _ \|  __ \ / __ \|  \/  |   /\   |_   _| \ | |  / ____|/ ____|   /\   | \ | | \ | |  ____|  __ \ 
| (___ | |  | | |_) | |  | | |  | | \  / |  /  \    | | |  \| | | (___ | |       /  \  |  \| |  \| | |__  | |__) |
 \___ \| |  | |  _ <| |  | | |  | | |\/| | / /\ \   | | | .   |  \___ \| |      / /\ \ | .   | .   |  __| |  _  / 
 ____) | |__| | |_) | |__| | |__| | |  | |/ ____ \ _| |_| |\  |  ____) | |____ / ____ \| |\  | |\  | |____| | \ \ 
|_____/ \____/|____/|_____/ \____/|_|  |_/_/    \_\_____|_| \_| |_____/ \_____/_/    \_\_| \_|_| \_|______|_|  \_\ ${close}	

${blue}By @BE1807V${close}
${yellow}Usage: ./enum.sh example.com output.txt${close}"

function trap_ctrlc() {
		rm dom@ins.txt
		echo -e "\n${red}[-] ${yellow}'Ctrl+C'${close}${red} detected...Exiting!${close}"
    exit 2
}
trap "trap_ctrlc" 2
crt() {
   if [ "$file" == "" ]; then
	echo -e "${red}[+] Searching in ${close}${yellow}crt.sh ${close}${red}for${close}${yellow} '$domain'${close}${red}!${close}"
	curl -s https://crt.sh/\?q\=\%.$domain\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > subdomain_crt.txt
	wait${!}
	echo -e "${red}[+] Finished enumerating subdomains using${close} ${yellow}'crt.sh'${close}${red}...${close}"
   else
   	echo -e "${red}[+] Searching in ${close}${yellow}crt.sh ${close}${red}!${close}"
	curl -s https://crt.sh/\?q\=\%.$domain\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > subdomain_crt.txt
	wait${!}
	echo -e "${red}[+] Finished enumerating subdomains using${close} ${yellow}'crt.sh'${close}${red}...${close}"
   fi
}

assetfinder() {
   if [ "$file" == "" ]; then
	echo -e "${red}[-] No output file provided...Printing results on screen!${close}"
	echo -e "${red}[+] Searching in ${close}${yellow}Assetfinder ${close}${red}for${close}${yellow} '$domain'${close}${red}!${close}"
	/opt/./assetfinder $domain > subdomain_af.txt
	echo -e "${red}[+] Finished enumerating subdomains using${close} ${yellow}'Assetfinder'${close}${red}...${close}"
   else
   	echo -e "${red}[+] Searching in ${close}${yellow}Assetfinder ${close}${red}!${close}"
	/opt/./assetfinder $domain > subdomain_af.txt
	echo -e "${red}[+] Finished enumerating subdomains using${close} ${yellow}'Assetfinder'${close}${red}...${close}"
   fi

}

sublist3r() {
   if [ "$file" == "" ]; then
	echo -e "${red}[+] Searching in ${close}${yellow}Sublist3r ${close}${red}for${close}${yellow} '$domain'${close}${red}!${close}"
	python /opt/Sublist3r/sublist3r.py -d $domain -o subdomain_sl.txt
	clear
	echo -e "${red}[+] Finished enumerating subdomains using${close} ${yellow}'Sublist3r'${close}${red}...${close}"
   else
   	echo -e "${red}[+] Searching in ${close}${yellow}Sublist3r ${close}${red}!${close}"
	python /opt/Sublist3r/sublist3r.py -d $domain -o subdomain_sl.txt
	clear
	echo -e "${red}[+] Finished enumerating subdomains using${close} ${yellow}'Sublist3r'${close}${red}...${close}"
   fi
}

finish() {
  echo -e "${red}[+] Gathering results for ${close}${yellow}'$domain'${close}"
  cat subdomain_crt.txt subdomain_sl.txt > subdom@ins.txt #subdomain_af.txt
  echo -e "${red}[+] Deleting unnecessary files...${close}"
  rm subdomain_crt.txt subdomain_sl.txt #subdomain_af.txt
  echo -e "${red}[+] Removing duplicate subdomains...${close}"
  cat subdom@ins.txt | uniq > dom@ins.txt
  rm subdom@ins.txt
  echo -e "${red}Do you want to run ${close}${yellow}'httprobe'${close}${red} on the subdomains?${close}${green} y${close}${orange}/${close}${red}N${close}"
  read httprobe
  if [ "$httprobe" == "y" ] && [ ! $file == "" ]; then	
			echo -e "${red}[+] Probing domains using${close}${yellow} 'httprobe'${close}${red}...${close}"
			cat dom@ins.txt | /opt/httprobe/./httprobe > subdomains.txt
			wait${!}
			rm dom@ins.txt
			mv subdomains.txt /root/$file
			echo -e "${red}[+] Progress finished...Results saved in${close}${blue} '/root/$file'${close}${red}!${close}"
	elif [ "$httprobe" == "y" ] && [ "$file" == "" ]; then
			echo -e "${red}[+] Probing domains using${close}${yellow} 'httprobe'${close}${red}...${close}"
			cat dom@ins.txt | /opt/httprobe/./httprobe > subdomains.txt
			wait${!} 
			rm dom@ins.txt
			echo -e "${red}[+] Progress finished...Displaying results!${close}"
			cat subdomains.txt
			sleep 1
			rm subdomains.txt
  	elif [ "$httprobe" == "N" ] && [ "$file" == "" ]; then
			echo -e "${red}[-] Cancelled${close} ${yellow}'httprobe'${close}${red}!${close}"
			echo -e "${red}[+] Progress finished...Displaying results!${close}"
			sed -i -e 's/<BR>/\n/g' dom@ins.txt			
			cat dom@ins.txt
			sleep 1
			rm dom@ins.txt
	elif [ "$httprobe" == "N" ] && [ ! "$file" == "" ]; then
			echo -e "${red}[-] Cancelled${close} ${yellow}'httprobe'${close}${red}!${close}"
			mv dom@ins.txt /root/$file
			echo -e "${red}[+] Progress finished...Results saved in${close}${blue} '/root/$file'${close}${red}!${close}"
  	elif [ ! "$httprobe" == "y" ] || [ ! "$httprobe" == "N" ]; then
	 		echo -e "${red}[-] Couldn't understand what this is...${close}${yellow}'$httprobe'${close}${red} Can you?${close}"
	  		sleep 1
			rm dom@ins.txt
	else
			echo -e "${red}[-] Parse error...Please report this to the developer! Thank you!${close}"
			rm dom@ins.txt
	fi
}

if [ "$domain" == "" ]; then
	echo -e "${red}[-] No domain name found...Quitting!${close}"
elif [ "$file" == "" ]; then
	echo -e "${red}[-] No output file detected...Printing results on screen!${close}"
  crt
	#assetfinder
	sublist3r
	finish

elif [ ! -f "$file" ]; then
	echo -e "${red}[+] Saving results in ${yellow}$file${close}${red}!${close}"
	crt
	#assetfinder
	sublist3r
	finish
elif [ -f "$file" ]; then
	echo -e "${red}[+] ${close}${orange}$file${close}${red} already exist! Overwrite ${orange}$file${close}${red}?${close}${green} y${close}${orange}/${close}${red}N${close}"
	read overwrite
	if [ "$overwrite" == "y" ]; then
		echo -e "${red}[+] Overwriting ${close}${orange}$file${close}${red}!${close}"
		crt
		#assetfinder
		sublist3r
		finish
	elif [ "$overwrite" == "N" ]; then
		echo -e "${red}[-] Printing results on screen!${close}"
		crt
		assetfinder
		sublist3r
		finish
	else
		echo -e "${red}[-] Couldn't understand what this is...${close}${yellow}'$overwrite'${close}${red} Can you?${close}"
	fi
else
	echo -e "${red}[-] Error occured! Please report this issue to the developer!${close}"
fi
