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


if [ -z "$1" ]; then
	echo -e "${red}Usage: $0 <domain> default${close}";
	echo -e "\n${red}Example: $0 example.com${close}";
	echo -e "\n${red}Example: $0 example.com default${close}";
	exit 1;
fi

domain=$1
default=$2

if [ -z "$2" ]; then
	default="0"
elif [ "$default" == "default" ] || [ "$default" == "DEFAULT" ] || [ "$default" == "d" ] || [ "$default" == "D" ]; then
	echo -e "${blue}Using the default options!${close}";
	default="1"
else
	default="0"
fi

if [ -d "$domain" ]; then
	echo -e "${red}Directory name already exist!${close}";
	exit 1;
else
	mkdir $domain
fi

cd $domain

if [ "$default" == "1" ]; then
	excludeDomains=false
else
	echo -e "${blue}Do you have any subdomains that you want to exclude from the scope? (separate by a comma ',' without white space between the domains, leave blank to not exclude any subdomains)${close}${red}";
	read outOfScope	
	excludeDomains=true
fi

if [ "$outOfScope" == "" ]; then
	echo -e "${green}No domains excluded from scope!${close}";
	excludeDomains=false	
else
	separatedDomains=$(echo $outOfScope | tr "," "\n")
	excludeDomains=true
fi

domain1=${domain%%.*}
domainExt=${domain##*.}
scope="^*\.$domain1\.$domainExt$"

echo -e "${orange}This script may take a long time to completly finish...I recommend you running this at the background and start your manual enumeration process. Here is your \"Target Scope\" regex that you can paste in to only intercept ${red}\"$domain\"${orange} requests:${close}";
echo -e "${green}$scope${close}";

echo -e "${orange}Starting sublist3r enumeration...${close}";
sublist3r -d $domain -o sublister.txt
$(cat sublister.txt | sed 's/<BR>/\n/g' > sublist3r.txt)

echo -e "${green}Sublist3r enumeration done!${close}${orange} Amass will now start enumerating the domains for ${close}${red}\"$domain\"${close}";
echo -e "${red}Oops...sorry..I will display it once more for you: ${green}$scope${close}"
amass enum -d $domain -passive | grep $domain > amass.txt

echo -e "${green}Amass enumeration done!${close}${orange} Assetfinder will now start enumerating the domains for ${close}${red}\"$domain\"${close}";
assetfinder $domain -subs-only | grep $domain > assetfinder.txt

echo -e "${green}Assetfinder enumeration done!${close}${orange} Findomain will now start enumerating the domains for ${close}${red}\"$domain\"${close}";
findomain -t $domain -o;

echo -e "${green}Findomain enumeration done!${close}${orange} Subfinder will now start enumerating the domains for ${close}${red}\"$domain\"${close}";
subfinder -d $domain -o subfinder.txt;

echo -e "${green}Subfinder enumeration done!${close}${orange} Crt.sh will now start enumerating the domains for ${close}${red}\"$domain\"${close}";
curl -s https://crt.sh/\?q\=\%.$domain\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | tr ' ' '\n' > crt.sh
echo -e "${green}Crt.sh enumeration done for ${close}${red}\"$domain\"${close}";


echo -e "${blue}Concatenating the results...${close}";
$(sort -u amass.txt assetfinder.txt $domain.txt subfinder.txt crt.sh sublist3r.txt -o $domain)
if [ $excludeDomains == "true" ]; then
	for domainToExclude in $separatedDomains; do
		echo -e "${red}Removing \"$domainToExclude\" from scope!${close}";
		sed -i "/$domainToExclude/d" $domain
	done
fi

echo -e "${yellow}Removing unwanted files...${close}";
rm amass.txt assetfinder.txt $domain.txt subfinder.txt crt.sh sublister.txt sublist3r.txt
sed -i "/\n/d" $domain

echo -e "${green}Successfully finished the enumeration of subdomains for${yellow} '$domain'${green}\nSubdomains gathered: $(sort $domain | wc -w)${close}";

if [ "$default" == "0" ]; then
	echo -e "${blue}Do you want to probe for alive domains?${close}${green} y${close}${blue}/${close}${red}N${close}";
	read probealive;
else
	probealive="y"
fi

if [ "$probealive" == "y" ] || [ "$probealive" == "Y" ]; then
	echo -e "${orange}Probing for live domains...Results will be saved in${close}${yellow} 'alive.txt'${close}";
	$(cat $domain | /opt/httprobe/./httprobe > alive.txt)
elif [ "$probealive" == "n" ] || [ "$probealive" == "N" ]; then
	echo -e "${red}Skipping discovery of alive domains...${close}";
else
	echo -e "${red}Invalid user input...${close}${yellow}'$overwrite'${close}";
	exit 1;	
fi

echo -e "${green}Successfully gathered all the live subdomains for ${yellow} '$domain'${green}\nAlive subdomains gathered: $(sort alive.txt | wc -w)${close}";

if [ "$default" == "0" ]; then
	echo -e "${blue}Do you want to discover subdomains that may be vulnerable to subdomain takeover? (This process can take alot of time when having alot of subdomains)${close}${green} y${close}${blue}/${close}${red}N${close}";
	read subdomaintakeover;
else
	subdomaintakeover="y"
fi

if [ "$subdomaintakeover" == "y" ] || [ "$subdomaintakeover" == "Y" ]; then
	echo -e "${orange}Checking for subdomain takeover...Results will be saved in${close}${yellow} 'possibleSubdomainTakeover.txt'${close}";
	if [ -f alive.txt ]; then
		subjack -a -m -ssl -w alive.txt -o possibleSubdomainTakeover.txt
		wait${!}
	else
		subjack -a -m -ssl -w $domain -o possibleSubdomainTakeover.txt
		wait${!}
	fi
	if [ ! -f possibleSubdomainTakeover.txt ]; then
		echo -e "${red}No domains found that are vulnerable to subdomain takeover.${orange} Remember to always check it out manually!${close}"
	fi
elif [ "$subdomaintakeover" == "n" ] || [ "$subdomaintakeover" == "N" ]; then
	echo -e "${red}Skipping the discovery of subdomain takeover vulnerability...${close}";
else
	echo -e "${red}Invalid user input...${close}${yellow}'$overwrite'${close}";
	exit 1;	
fi

if [ "$default" == "0" ]; then
	echo -e "${blue}Do you want to screenshot every domain you gathered? (This process can take alot of time when having alot of subdomains)${close}${green} y${close}${blue}/${close}${red}N${close}";
	read screenshotdomains;
else
	screenshotdomains="y"
fi

if [ "$screenshotdomains" == "y" ] || [ "$screenshotdomains" == "Y" ]; then
	echo -e "${orange}Screenshotting websites...Results will be saved in${close}${yellow} './$domain/aquatone/*'${close}";
	mkdir aquatone
	cd aquatone
	cat ../$domain | aquatone -threads 10
elif [ "$screenshotdomains" == "n" ] || [ "$screenshotdomains" == "N" ]; then
	echo -e "${red}Skipping screenshotting domains...${close}";
else
	echo -e "${red}Invalid user input...${close}${yellow}'$screenshotdomains'${close}";
	exit 1;	
fi

echo -e "${green}Enumeration done! Results saved in \"./$domain/*\"${close}";
exit 1;
