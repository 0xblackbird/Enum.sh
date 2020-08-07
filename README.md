# Update [07/8/2020]
**1. Added an intallation script which will install all the requirements for this script to run correctly**

# Enum.sh [BETA]
All of your enumeration tools coded in ONE script!

# Description
An enumeration script that combines **several subdomain scanning tools**!
**Httprobe** and **aquatone** are also added to check for live (sub)domains and screenshot them!
This makes it easier so you only need to run this script once! More tools and helpful functions comming soon! 

# Installation
1. **`$ git clone https://github.com/be1807v/Enum.sh.git enum`**

2. **`$ cd enum/`**

3. **`$ chmod +x *.sh`**

4. **`$ ./install.sh`**

**Make sure you have root access! Else the install.sh will not be able to install all the required tools!**

# Usage

**`$ ./enum.sh example.com`**

# Features
- Scans for subdomains using several subdomain enumeration tools (including crt.sh)!
- Looks for live domains using httprobe (**optional**)
- Looks for hidden parameters (**optional**)
- Discovery of possible subdomain takeover (*subjack*, **optional**)
- Screenshot all the gathered (sub)domains (*aquatone*, **optional**)
