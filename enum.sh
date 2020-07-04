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
	echo -e "\n${yellow}\"Ctrl+^C\"${close}${red} detected...Exiting! Latest results will be saved in ./$domain/*${close}";
	exit 2;
}
trap "trap_ctrlc" 2;


if [ "$1" == "" ]; then
	echo -e "${red}Usage: $0 <domain>${close}";
	echo -e "\n${red}Example: $0 example.com${close}";
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
sublist3r -d $domain -o sublister.txt
$(cat sublister.txt | sed 's/<BR>/\n/g' > sublist3r.txt)
clear;
echo -e "${green}Sublist3r enumeration done!${close}${orange} Amass will now start enumerating the domains for ${close}${red}\"$domain\"${close}";
amass enum -d $domain -passive | grep $domain > amass.txt
clear;
echo -e "${green}Amass enumeration done!${close}${orange} Assetfinder will now start enumerating the domains for ${close}${red}\"$domain\"${close}";
assetfinder $domain -subs-only | grep $domain > assetfinder.txt
clear;
echo -e "${green}Assetfinder enumeration done!${close}${orange} Findomain will now start enumerating the domains for ${close}${red}\"$domain\"${close}";
findomain -t $domain -o;
clear;
echo -e "${green}Findomain enumeration done!${close}${orange} Subfinder will now start enumerating the domains for ${close}${red}\"$domain\"${close}";
subfinder -d $domain -o subfinder.txt;
clear;
echo -e "${green}Subfinder enumeration done!${close}${orange} Crt.sh will now start enumerating the domains for ${close}${red}\"$domain\"${close}";
curl -s https://crt.sh/\?q\=\%.$domain\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | tr ' ' '\n' > crt.sh
echo -e "${green}Crt.sh enumeration done for ${close}${red}\"$domain\"${close}";


echo -e "${blue}Concatenating the results...${close}";
$(sort -u amass.txt assetfinder.txt $domain.txt subfinder.txt crt.sh sublist3r.txt -o $domain)

echo -e "${yellow}Removing unwanted files...${close}";
rm amass.txt assetfinder.txt $domain.txt subfinder.txt crt.sh sublister.txt sublist3r.txt

echo -e "${green}Successfully finished the enumeration of subdomains for${yellow} '$domain'${green}\nSubdomains gathered: $(sort $domain | wc -w)${close}";

echo -e "${blue}Do you want to probe for alive domains?${close}${green} y${close}${blue}/${close}${red}N${close}";
read probealive;

if [ "$probealive" == "y" ] || [ "$probealive" == "Y" ]; then
	echo -e "${orange}Probing for live domains...Results will be saved in${close}${yellow} 'alive.txt'${close}";
	$(cat $domain | /opt/httprobe/./httprobe > alive.txt)
elif [ "$probealive" == "n" ] || [ "$probealive" == "N" ]; then
	echo -e "${red}Skipping discovery of alive domains...${close}";
else
	echo -e "${red}Invalid user input...${close}${yellow}'$overwrite'${close}";
	exit 1;	
fi

echo -e "${blue}Do you want to discover hidden parameters in the given wordlist? (This process can take alot of time when having alot of subdomains)${close}${green} y${close}${blue}/${close}${red}N${close}";
read findhiddenparams;

if [ "$findhiddenparams" == "y" ] || [ "$findhiddenparams" == "Y" ]; then
	echo -e "${orange}Discovering hidden parameters...Results will be saved in${close}${yellow} 'hiddenParams.txt'${close}";
	if [ -f alive.txt ]; then
		$(cat alive.txt | while read url; do hide=$(curl -s -L $url | egrep -o "('|\")hidden('|\") name=('|\")[a-z_0-9-]*" | sed -e 's/\"hidden\"/[FOUND]/g' -e 's,'name=\"','"$url"/?',g'| sed 's/.*/&=XSSCHECK/g'); echo -e "\e[1;32m$url""\e[1;33m\n$hide"; done | grep XSSCHECK > hiddenParams.txt)
	else
		$(cat $domain | /opt/httprobe/./httprobe | while read url; do hide=$(curl -s -L $url | egrep -o "('|\")hidden('|\") name=('|\")[a-z_0-9-]*" | sed -e 's/\"hidden\"/[FOUND]/g' -e 's,'name=\"','"$url"/?',g'| sed 's/.*/&=XSSCHECK/g'); echo -e "\e[1;32m$url""\e[1;33m\n$hide"; done | grep XSSCHECK > hiddenParams.txt)
	fi
elif [ "$findhiddenparams" == "n" ] || [ "$findhiddenparams" == "N" ]; then
	echo -e "${red}Skipping the discovery of hidden parameters...${close}";
else
	echo -e "${red}Invalid user input...${close}${yellow}'$overwrite'${close}";
	exit 1;	
fi

echo -e "${blue}Do you want to discover subdomains that may be vulnerable to subdomain takeover? (This process can take alot of time when having alot of subdomains)${close}${green} y${close}${blue}/${close}${red}N${close}";
read subdomaintakeover;

if [ "$subdomaintakeover" == "y" ] || [ "$subdomaintakeover" == "Y" ]; then
	echo -e "${orange}Checking for subdomain takeover...Results will be saved in${close}${yellow} 'possibleSubdomainTakeover.txt'${close}";
	subjack -a -m -ssl -w $domain -o possibleSubdomainTakeover.txt -v
	wait${!}
	if [ ! -f possibleSubdomainTakeover.txt ]; then
		echo -e "${red}No domains found that are vulnerable to subdomain takeover.${orange} Remember to always check it out manually!${close}"
	fi
elif [ "$subdomaintakeover" == "n" ] || [ "$subdomaintakeover" == "N" ]; then
	echo -e "${red}Skipping the discovery of subdomain takeover vulnerability...${close}";
else
	echo -e "${red}Invalid user input...${close}${yellow}'$overwrite'${close}";
	exit 1;	
fi

echo -e "${blue}Do you want to screenshot every domain you gathered? (This process can take alot of time when having alot of subdomains)${close}${green} y${close}${blue}/${close}${red}N${close}";
read screenshotdomains;

if [ "$screenshotdomains" == "y" ] || [ "$screenshotdomains" == "Y" ]; then
	echo -e "${orange}Screenshotting websites...Results will be saved in${close}${yellow} './$domain/aquatone/*'${close}";
	mkdir aquatone
	cd aquatone
	cat ../$domain | aquatone
elif [ "$screenshotdomains" == "n" ] || [ "$screenshotdomains" == "N" ]; then
	echo -e "${red}Skipping screenshotting domains...${close}";
else
	echo -e "${red}Invalid user input...${close}${yellow}'$screenshotdomains'${close}";
	exit 1;	
fi

echo -e "${green}Enumeration done! Results saved in \"./$domain/*\"${close}";
exit 1;
