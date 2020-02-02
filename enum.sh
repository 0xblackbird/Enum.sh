#!/bin/bash

clear
printf '\e[8;25;120t'
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
		if [ -f d0m@ins.txt ]; then			
			d0m@ins.txt  > $file
			rm d0m@ins.txt
		fi
		echo -e "\n${red}[-] ${blue}'Ctrl+C'${close}${red} detected...Exiting!${close}"
    exit 2
}
trap "trap_ctrlc" 2

crt_func() {
  if [ "$domain" != "" ] && [ "$file" != "" ]; then
   	echo -e "${red}[+] Searching in ${close}${yellow}crt.sh ${close}${red}!${close}"
	crt=`curl -s https://crt.sh/\?q\=\%.$domain\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | tr ' ' '\n'`
	wait${!}
	echo -e "${red}[+] Finished enumerating subdomains using${close} ${yellow}'crt.sh'${close}${red}...${close}"
   else
	echo -e "${red}[-] Parse error at line ${close}${blue}'44'${close}${red}...Please report this to the developer! Thanks!${close}"
   fi
}

assetfinder_func() {
    if [ "$domain" != "" ] && [ "$file" != "" ]; then
   	echo -e "${red}[+] Searching in ${close}${yellow}Assetfinder ${close}${red}!${close}"
	assetfinder=`/usr/bin/assetfinder $domain | xargs -n1 | grep $domain`
	echo -e "${red}[+] Finished enumerating subdomains using${close} ${yellow}'Assetfinder'${close}${red}...${close}"
   else
	echo -e "${red}[-] Parse error at line ${close}${blue}'54'${close}${red}...Please report this to the developer! Thanks!${close}"
   fi
}

sublist3r_func() {
   if [ "$domain" != "" ] && [ "$file" != "" ]; then
   	echo -e "${red}[+] Searching in ${close}${yellow}Sublist3r ${close}${red}!${close}"
	sublist3r=`python /opt/Sublist3r/sublist3r.py -d $domain | sed "s/ /\n/g" | sed "s/<BR>/\n/g" | grep $domain`
	clear
	echo -e "${red}[+] Finished enumerating subdomains using${close} ${yellow}'Sublist3r'${close}${red}...${close}"
   else
	echo -e "${red}[-] Parse error at line ${close}${blue}'65'${close}${red}...Please report this to the developer! Thanks!${close}"
   fi
}

eyewitness() {
	if [ "$domain" != "" ] && [ "$file" != "" ]; then
		echo -e "${red}[+] Screenshotting subdomains using ${close}${yellow}'Eyewitness'${close}...${close}"
		python3 /opt/EyeWitness/EyeWitness.py -d /screens/ -f $file
	else
		echo -e "${red}[-] Parse error at line ${close}${blue}'74'${close}${red}...Please report this to the developer! Thanks!${close}"
	fi
}

finish() {
	 if [ "$domain" != "" ] && [ "$file" != "" ]; then	
		results=$crt+$assetfinder+$sublist3r
		echo -e "${red}[+] Gathering results for ${close}${yellow}'$domain'${close}${red}...${close}"
		echo $results | sed 's/ /\n/g' | sed 's/<BR>/\n/g' | sed 's/\*\.//g' | grep $domain > d0m@ins.txt
		sort -u d0m@ins.txt > $file
		clear
		echo -e "${red}Do you want to run ${close}${yellow}'httprobe'${close}${red} on the subdomains?${close}${green} y${close}${orange}/${close}${red}N${close}"
  		read httprobe
		if [ "$httprobe" == "y" ] || [ "$httprobe" == "Y" ]; then
			echo -e "${red}[+] Probing domains using${close}${yellow} 'httprobe'${close}${red}...${close}"
			cat $file > d0m@ins.txt
			cat d0m@ins.txt | /opt/httprobe/./httprobe > $file
			if [ -f d0m@ins.txt ]; then			
				rm d0m@ins.txt
			fi
		elif [ "$httprobe" == "n" ] || [ "$httprobe" == "N" ]; then
			echo -e "${red}[-] Cancelled${close} ${yellow}'httprobe'${close}${red}!${close}"
			if [ -f d0m@ins.txt ]; then			
				#d0m@ins.txt  > $file
				rm d0m@ins.txt
			fi
  		elif [ "$httprobe" != "y" ] || [ "$httprobe" != "Y" ] || [ "$httprobe" != "n" ] || [ ! "$httprobe" != "N" ]; then
			echo -e "${red}[-] Invalid user input...${close}${yellow}'$httprobe'${close}${red} Do you know what this is?${close}"
			if [ -f d0m@ins.txt ]; then			
				#d0m@ins.txt  > $file
				rm d0m@ins.txt
			fi		
		else
			echo -e "${red}[-] Parse error at line ${close}${blue}'107'${close}${red}...Please report this to the developer! Thanks!${close}"
			if [ -f d0m@ins.txt ]; then			
				#d0m@ins.txt  > $file
				rm d0m@ins.txt
			fi		
		fi
	fi
	echo -e "${red}Do you want to screenshot all subdomains found for ${close}${yellow}'$domain'${close}${red} using ${close}${yellow}'Eyewitness'${close}${red}?${close}${green} y${close}${orange}/${close}${red}N${close}"
	read eyewitness
	if [ "$eyewitness" == "y" ] || [ "$eyewitness" == "Y" ]; then
		eyewitness
	elif [ "$eyewitness" == "n" ] || [ "$eyewitness" == "N" ]; then
		if [ "$domain" != "" ] && [ "$file" != "" ]; then
			echo -e "${red}[+] Progress finished...Results saved in ${close}${blue}'/root/$file'${close}${red}!${close}"
		else
			echo -e "${red}[-] Parse error at line ${close}${blue}'122'${close}${red}...Please report this to the developer! Thanks!${close}"	
		fi
	elif [ "$eyewitness" != "y" ] || [ "$eyewitness" != "Y" ] || [ "$eyewitness" != "n" ] || [ "$eyewitness" != "N" ]; then
		echo -e "${red}[-] Invalid user input...${close}${yellow}'$eyewitness'${close}${red} Do you know what this is?${close}"
	else
		echo -e "${red}[-] Parse error at line ${close}${blue}'127'${close}${red}...Please report this to the developer! Thanks!${close}"
	fi
}

if [ "$domain" == "" ]; then
	echo -e "${red}[-] No domain name found...Quitting!${close}"
elif [[ "$domain" =~ [A-Z] ]]; then
	echo -e "${red}Invalid domain name found...A domain name cannot contain ${close}${yellow}'uppercase characters'${close}${red}!${close}"
elif [ "$file" == "" ]; then	
	echo -e "${red}[-] No output file detected...Please provide an output file!${close}"
elif [ ! -f "$file" ]; then
	echo -e "${red}[+] Saving results in ${yellow}$file${close}${red}!${close}"
	crt_func
	assetfinder_func
	sublist3r_func
	finish
elif [ -f "$file" ]; then
	echo -e "${red}[+] ${close}${orange}$file${close}${red} already exist! Overwrite ${orange}$file${close}${red}?${close}${green} y${close}${orange}/${close}${red}N${close}"
	read overwrite
	if [ "$overwrite" == "y" ] || [ "$overwrite" == "Y" ]; then
		echo -e "${red}[+] Overwriting ${close}${orange}$file${close}${red}!${close}"
		crt_func
		assetfinder_func
		sublist3r_func
		finish
	elif [ "$overwrite" == "N" ] || [ "$overwrite" == "N" ]; then
		echo -e "${red}[-] No output file provided...${close}${orange}'$file'${close}${red} already exists!${close}"
		
	elif [ "$overwrite" != "y" ] || [ "$overwrite" != "Y" ] || [ "$overwrite" != "N" ] || [ "$overwrite" != "N" ]; then
		echo -e "${red}[-] Invalid user input...${close}${yellow}'$overwrite'${close}${red} Do you know what this is?${close}"
	
	else
		echo -e "${red}[-] Parse error at line ${close}${blue}'159'${close}${red}...Please report this to the developer! Thanks!${close}"	
	fi
else
	echo -e "${red}[-] Parse error at line ${close}${blue}'162'${close}${red}...Please report this to the developer! Thanks!${close}"
fi
