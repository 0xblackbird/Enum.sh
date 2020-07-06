# Update [06/7/2020]
**1. New feature available to exclude subdomains that are out of scope!***

**2. Fixed some errors**

# Enum.sh [BETA]
All of your enumeration tools coded in ONE script!

# Description
An enumeration script that combines **several subdomain scanning tools**!
**Httprobe** and **aquatone** are also added to check for live (sub)domains and screenshot them!
This makes it easier so you only need to run this script once! More tools and helpful functions comming soon! 

# Installation
1. `$ git clone https://github.com/be1807v/Enum.sh.git`

2. `$ cd Enum.sh/`

3. `$ sudo chmod +x enum.sh`

**Make sure you have *Sublist3r*, *Amass*, *Assetfinder*, *Findomain*, *Subfinder*, *Aquatone*, *Httprobe* and *Subjack* installed!**

**PLEASE CHANGE THE LOCATION OF THE TOOLS MENTIOND ABOVE TO THE DOWNLOAD LOCATION ON YOUR DEVICE!**

# Usage

`$ ./enum.sh example.com`

# Features
- Scans for subdomains using several subdomain enumeration tools (including crt.sh)!
- Looks for live domains using httprobe (**optional**)
- Looks for hidden parameters (**optional**)
- Discovery of possible subdomain takeover (subjack, **optional**)
- Screenshot all the gathered (sub)domains (aquatone, **optional**)
