# Update [12/7/2020]
**1. Fixed some issues where the out of scope function didn't work correctly.**

# Enum.sh [BETA]
All of your enumeration tools coded in ONE script!

# Description
An enumeration script that combines **several subdomain scanning tools**!
**Httprobe** and **aquatone** are also added to check for live (sub)domains and screenshot them!
This makes it easier so you only need to run this script once! More tools and helpful functions comming soon! 

# Installation
1. **`$ git clone https://github.com/be1807v/Enum.sh.git enum`**

2. **`$ cd enum/`**

3. **`$ chmod +x enum.sh`**

**Make sure you have *Sublist3r*, *Amass*, *Assetfinder*, *Findomain*, *Subfinder*, *Aquatone*, *Httprobe* and *Subjack* installed!**

# Usage

**`$ ./enum.sh example.com`**

# Features
- Scans for subdomains using several subdomain enumeration tools (including crt.sh)!
- Looks for live domains using httprobe (**optional**)
- Looks for hidden parameters (**optional**)
- Discovery of possible subdomain takeover (*subjack*, **optional**)
- Screenshot all the gathered (sub)domains (*aquatone*, **optional**)
