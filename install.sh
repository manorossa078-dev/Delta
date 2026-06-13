#!/bin/bash

readonly REQUIRES=("sherlock" "john" "maltego")
readonly SCRIPT_REQ=("toilet")
readonly PYTHON_REQ=("maigret")
readonly GREEN="\e[1;32m"
readonly YELLOW="\e[1;33m"
readonly RESET="\e[0m"

for scriptTool in "${SCRIPT_REQ[@]}"; do
        if [ ! command -v toilet ]; then
                echo -e "${GREEN}[+] TOIlet already installed.${RESET}"
                toilet -f slant -F metal Delta Install
        else
                sudo apt install toilet -y
                toilet -f slant -F metal Delta Install
        fi
done

echo -e "${GREEN}"

for tool in "${REQUIRES[@]}"; do
        if [ $? -eq 0 ]; then
                echo -e "${GREEN}[+] Bash requirements already installed!"
        else
                echo -e "${YELLOW}[*] Installing $tool..."
                sudo apt install $tool
                clear
        fi
done
for pythonTool in "${PYTHON_REQ[@]}"; do
        if [ pip show $pythonTool 2> /dev/null ]; then
                echo -e "${GREEN}[+] All pyhton tools are installed!"
                exit 0
        else
                echo -e "${YELLOW}[*] Warning. $pythonTool isn't installed. Installing it now..."
                pip3 install $pythonTool --break-system-packages
                echo -e "${GREEN}[+] $pythonTool installed succesfully!"
        fi
done
echo -e "${GREEN}[+] All tools are installed."
