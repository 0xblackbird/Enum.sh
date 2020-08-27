#!/usr/bin/env bash

if [ -d "enum-install" ]; then
	echo -e "\e[1;31mFolder for installing all the tools already exisits. This likely means that you already have executed this script. Remove the folder to install everthing again.\e[0m"
	exit 1
else
	sudo mkdir enum-install
	cd enum-install
fi

# Updating && upgrading system
sudo apt update && sudo apt -y full-upgrade
wait${!}

# Downloading && installing golang + setting up the GoPath
sudo wget https://golang.org/dl/go1.14.7.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.14.7.linux-amd64.tar.gz
sudo echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile
source ~/.profile

# Downloading && installing sublist3r & amass
sudo apt-get install sublist3r amass

# Downloading && installing Assetfinder
go get -u github.com/tomnomnom/assetfinder

# Downloading && installing Anew
go get -u github.com/tomnomnom/anew

# Downloading && installing Findomain
sudo wget https://github.com/Edu4rdSHL/findomain/releases/latest/download/findomain-linux -O findomain
sudo chmod +x findomain
sudo mv findomain /usr/bin/

# Downloading && installing Subfinder
GO111MODULE=on go get -v github.com/projectdiscovery/subfinder/cmd/subfinder

# Downloading && installing Aquatone
cmd=$(uname -a)
if [[ "$cmd" == *"amd64"* ]]; then
	sudo wget https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip
	sudo unzip aquatone_linux_amd64_1.7.0.zip
	sudo chmod +x aquatone
	sudo mv aquatone /usr/bin/
elif [[ "$cmd" == *"arm64"* ]];then
	sudo wget https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_arm64_1.7.0.zip
	sudo unzip aquatone_linux_arm64_1.7.0.zip
	sudo chmod +x aquatone
	sudo mv aquatone /usr/bin/
else
	echo "Error while installing Aquatone!"
fi
# Downloading && installing Httprobe
go get -u github.com/tomnomnom/httprobe

# Downloading && installing Subjack
go get github.com/haccer/subjack
