# Update [07/8/2020]
**1. Added a new (flag) that will enable all the options without requiring additional user input**

# Enum.sh
All of your enumeration tools implemented in ONE single script!

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

**`$ ./enum.sh example.com default`** # This will enable all the features listed below

# Features
- Scans for subdomains using several subdomain enumeration tools (including crt.sh)!
- Looks for live domains using httprobe (**optional**)
- Discovery of possible subdomain takeover (*subjack*, **optional**)
- Screenshot all the gathered (sub)domains (*aquatone*, **optional**)
