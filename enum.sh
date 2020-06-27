#!/usr/bin/env bash

clear;
printf '\e[8;25;120t';

red="\e[1;31m"
yellow="\e[1;33m"
orange="\e[1;39m"
blue="\e[1;36m"
green="\e[1;32m"
close="\e[0m"

function trap_ctrlc() {
	echo -e "\n${yellow}\"Ctrl+^C\"${close}${red} detected...Exiting\! Latest results saved in ./$domain/*${close}";
	exit 2;
}
trap "trap_ctrlc" 2;


if [ "$1" == "" ]; then
	echo -e "${red}Usage: $0 <domain>${close}";
	exit 1;
fi

domain=$1

if [ -d "$domain" ]; then
	echo -e "${red}Directory name already exist!${close}";
	exit 1;
else
	mkdir $domain
fi

cd $domain

echo -e "${orange}Starting sublist3r enumeration...${close}";
`sublist3r -d domain > sublist3r.txt`;
echo -e "${green}Sublist3r enumeration done!${close}${orange} Amass will now start enumerating the domains for ${close}${red}\"$domain\"${close}";
`amass enum -d $domain -passive -o amass.txt`;
echo -e "${green}Amass enumeration done!${close}${orange} Assetfinder will now start enumerating the domains for ${close}${red}\"$domain\"${close}";
assetfinder $domain -subs-only | grep $domain > assetfinder.txt;
echo -e "${green}Assetfinder enumeration done!${close}${orange} Findomain will now start enumerating the domains for ${close}${red}\"$domain\"${close}";
findomain -t $domain -o;
echo -e "${green}Findomain enumeration done!${close}${orange} Subfinder will now start enumerating the domains for ${close}${red}\"$domain\"${close}";
subfinder -d $domain -o subfinder.txt;
echo -e "${green}Subfinder enumeration done!${close}${orange} Crt.sh will now start enumerating the domains for ${close}${red}\"$domain\"${close}";
`curl -s https://crt.sh/\?q\=\%.$domain\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | tr ' ' '\n' > crt.sh`;
echo -e "${green}Crt.sh enumeration done for ${close}${red}\"$domain\"${close}";


echo -e "${blue}Concatenating the results...${close}";
sort -u amass.txt assetfinder.txt $domain.txt subfinder.txt crt.sh sublist3r.txt | grep $domain | sed 's/<BR>/\n/g' > $domain
sort $domain -o $domain

echo -e "${blue}Do you want to probe for alive domains?${close}${green} y${close}${blue}/${close}${red}N${close}";
read probealive;

if [ "$probealive" == "y" ] || [ "$probealive" == "Y" ]; then
	echo -e "${orange}Probing for live domains...Results will be saved in${close}${yellow} 'alive.txt'${close}";
	$domains | /opt/httprobe/./httprobe > alive.txt
elif [ "$probealive" == "N" ] || [ "$probealive" == "N" ]; then
	echo -e "${red}Skipping discovery of alive domains...${close}";
else
	echo -e "${red}Invalid user input...${close}${yellow}'$overwrite'${close}";
	exit 1;	
fi

echo -e "${yellow}Removing unwanted files...${close}";
rm amass.txt assetfinder.txt $domain.txt subfinder.txt crt.sh sublist3r.txt

echo -e "${green}Successfully finished the enumeration of subdomains for${yellow} '$domain'${green}\nSubdomains gathered: `sort $domain | wc -w`${close}";

echo -e "${blue}Do you want to discover hidden parameters in the given wordlist? (This process can take alot of time when having alot of subdomains)${close}${green} y${close}${blue}/${close}${red}N${close}";
read findhiddenparams;

if [ "$findhiddenparams" == "y" ] || [ "$findhiddenparams" == "Y" ]; then
	echo -e "${orange}Discovering hidden parameters...Results will be saved in${close}${yellow} 'hiddenParams.txt'${close}";
	cat $domain | /opt/httprobe/./httprobe | payload="'><--><Svg Onload=confirm(1)><-->"; while read url; do hide=$(curl -s -L $url | egrep -o "('|\")hidden('|\") name=('|\")[a-z_0-9-]*" | sed -e 's/\"hidden\"/[FOUND]/g' -e 's,'name=\"','"$url"/?',g'| sed 's/.*/&=$payload/g'); echo -e "\e[1;32m$url""\e[1;33m\n$hide"; done > hiddenParams.txt	
elif [ "$findhiddenparams" == "N" ] || [ "$findhiddenparams" == "N" ]; then
	echo -e "${red}Skipping the discovery of hidden parameters...${close}";
else
	echo -e "${red}Invalid user input...${close}${yellow}'$overwrite'${close}";
	exit 1;	
fi

echo -e "${blue}Do you want to discover subdomains that may be vulnerable to subdomain takeover? (This process can take alot of time when having alot of subdomains)${close}${green} y${close}${blue}/${close}${red}N${close}";
read subdomaintakeover;

if [ "$subdomaintakeover" == "y" ] || [ "$subdomaintakeover" == "Y" ]; then
	echo -e "${orange}Checking for subdomain takeover...Results will be saved in${close}${yellow} 'possibleSubdomainTakeover.txt'${close}";
	`subjack -a -m -ssl -w $domain -o possibleSubdomainTakeover.txt`;
elif [ "$subdomaintakeover" == "N" ] || [ "$subdomaintakeover" == "N" ]; then
	echo -e "${red}Skipping the discovery of subdomain takeover vulnerability...${close}";
else
	echo -e "${red}Invalid user input...${close}${yellow}'$overwrite'${close}";
	exit 1;	
fi

echo -e "${blue}Do you want to screenshot every domain you gathered? (This process can take alot of time when having alot of subdomains)${close}${green} y${close}${blue}/${close}${red}N${close}";
read screenshotdomains;

if [ "$screenshotdomains" == "y" ] || [ "$screenshotdomains" == "Y" ]; then
	echo -e "${orange}Screenshotting websites...Results will be saved in${close}${yellow} './$domain/*'${close}";
	if [ -f alive.txt ]; then
		`eyewitness --web -f alive.txt -d $domain`;
	else
		`eyewitness --web -f $domain -d $domain`
elif [ "$screenshotdomains" == "N" ] || [ "$screenshotdomains" == "N" ]; then
	echo -e "${red}Skipping screenshotting domains...${close}";
else
	echo -e "${red}Invalid user input...${close}${yellow}'$overwrite'${close}";
	exit 1;	
fi

echo -e "${green}Enumeration done! Results saved in \"./$domain/*\"${close}";
exit 1;
