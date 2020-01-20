#!/bin/bash

printf '\033[8;25;120t'
domain=$1
file=$2

echo -e "\e[1;31m
  _____ _    _ ____  _____   ____  __  __          _____ _   _    _____  _____          _   _ _   _ ______ _____  
 / ____| |  | |  _ \|  __ \ / __ \|  \/  |   /\   |_   _| \ | |  / ____|/ ____|   /\   | \ | | \ | |  ____|  __ \ 
| (___ | |  | | |_) | |  | | |  | | \  / |  /  \    | | |  \| | | (___ | |       /  \  |  \| |  \| | |__  | |__) |
 \___ \| |  | |  _ <| |  | | |  | | |\/| | / /\ \   | | | .   |  \___ \| |      / /\ \ | .   | .   |  __| |  _  / 
 ____) | |__| | |_) | |__| | |__| | |  | |/ ____ \ _| |_| |\  |  ____) | |____ / ____ \| |\  | |\  | |____| | \ \ 
|_____/ \____/|____/|_____/ \____/|_|  |_/_/    \_\_____|_| \_| |_____/ \_____/_/    \_\_| \_|_| \_|______|_|  \_\ \e[0m
\e[1;33m@Nahamsec crt.sh script, but then improved!\e[0m                                                            \e[1;36mBy @BE1807V\e[0m"


if [ ! -f "$file" ]; then
		echo -e "\e[1;36m[`whoami`]\e[0m \e[1;31mHello \e[1;39mcrt.sh\e[0m\e[1;31m! Can you scan for me\e[0m \e[1;39m$domain\e[1;31m?\e[0m"
    echo -e "\e[1;36m[crt.sh]\e[0m \e[1;31mHere are the results!\e[0m"
    echo -e "\e[1;31m[+] Saving results in\e[0m \e[1;32m$file...\e[0m"
    curl -s https://crt.sh/\?q\=\%.$domain\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > $file
		wait${!}
		echo -e "\e[1;33mDo you want to probe the domains?\e[0m \e[1;31my/N\e[0m"
		read answer
    if [ "$answer" == "y" ]; then 
				echo -e "\e[1;33mProbing $file...\e[0m"
        cat $file | /opt/httprobe/./httprobe > d0m@ins15448.txt
				mv d0m@ins15448.txt /root/$file
				wait${!}
				echo -e "\e[1;31mProgress finished...Quitting!\e[0m"
    elif [ "$answer" == "N" ]; then
			  echo -e "\e[1;31mProgress finished...Quitting!\e[0m"
		else
        echo -e "\e[1;31mProgress finished...Quitting!\e[0m"
 	  fi
elif [ -f "$file" ]; then
     echo -e "\e[1;31m$file already exists!\e[0m"
     echo -e "\e[1;31mPlease choose an other file!\e[0m "
		 read file
		 if [ ! -f "$file" ]; then
     				echo -e "\e[1;36m[`whoami`]\e[0m \e[1;31mHello \e[1;39mcrt.sh\e[0m\e[1;31m! Can you scan for me\e[0m \e[1;39m$domain\e[1;31m?\e[0m"
     				echo -e "\e[1;36m[crt.sh]\e[0m \e[1;31mHere are the results!\e[0m"
     				echo -e "\e[1;31m[+] Saving results in $file...\e[0m"
     				curl -s https://crt.sh/\?q\=\%.$domain\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > $file
     				wait${!}
     				echo -e "\e[1;33mDo you want to probe the domains?\e[0m \e[1;31my/N\e[0m"
						read answer
		 				if [ "$answer" == "y" ]; then
          			echo -e "\e[1;33mProbing $file...\e[0m"
          			cat $file | /opt/httprobe/./httprobe > d0m@ins15448.txt
          			mv d0m@ins15448.txt /root/$file
								wait${!}
          			echo -e "\e[1;31mProgress finished...Quitting!\e[0m"
      			elif [ "$answer" == "N" ]; then
          			echo -e "\e[1;31mProgress finished...Quitting!\e[0m"
         		else
          			echo -e "\e[1;31mProgress finished...Quitting!\e[0m"
            fi
      elif [ -f "$file" ]; then
		 			echo -e "\e[1;31m$file already exists!\e[0m"
   		 		echo -e "\e[1;31mOverwriting $file!\e[0m"
		 			curl -s https://crt.sh/\?q\=\%.$domain\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > $file
			fi
fi
if [ "$file" == " " ]; then
 		echo -e "\e[1;31mNo file provided, printing the ouput...\e[0m"
 		echo $domain
 		curl -s https://crt.sh/\?q\=\%.$domain\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u
else
		echo ""
fi
