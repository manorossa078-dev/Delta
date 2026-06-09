#!/bin/bash

readonly REQUIRES=("sherlock" "john")
readonly GREEN="\e[1;32m"
readonly YELLOW="\e[1;33m"
readonly RESET="\e[0m"

echo -e "${GREEN}"
cat << "EOF"
    ____       ____           ____           __        ____
   / __ \___  / / /_____ _   /  _/___  _____/ /_____ _/ / /
  / / / / _ \/ / __/ __ `/   / // __ \/ ___/ __/ __ `/ / / 
 / /_/ /  __/ / /_/ /_/ /  _/ // / / (__  ) /_/ /_/ / / /  
/_____/\___/_/\__/\__,_/  /___/_/ /_/____/\__/\__,_/_/_/ 
EOF

for tool in "${REQUIRES[@]}"; do
	if [ $? -eq 0 ]; then
		echo -e "${GREEN}[+] Requirements already installed!"
		exit 0
	else
		echo -e "${YELLOW}[*] Installing $tool..."
		sudo apt install $tool
	fi
done
