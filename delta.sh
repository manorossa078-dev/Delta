#!/bin/bash

GREEN="\e[1;32m"
RED="\e[1;31m"
YELLOW="\e[1;33m"
DEFAULT="\e[0m"
FILETYPES=("zip" "7z")
VERSION="v.0.0.6 bugfix"

echo -e "${YELLOW}"

cat << "EOF"
 ____       _ _           ___  ____ ___ _   _ _____
|  _ \  ___| | |_ __ _   / _ \/ ___|_ _| \ | |_   _|
| | | |/ _ \ | __/ _` | | | | \___ \| ||  \| | | |
| |_| |  __/ | || (_| | | |_| |___) | || |\  | | |
|____/ \___|_|\__\__,_|  \___/|____/___|_| \_| |_|
EOF

echo -e "Delta OSINT $VERSION${GREEN}"

if [ -z "$1" ]; then
    echo -e "${RED}Error. Enter a flag (use -h to see the options).${DEFAULT}" >&2
    exit 1
elif [ "$1" == "-h" ]; then
    echo "-------------------------------------------------------------"
    echo "Use -h to view this message"
    echo "Use -u to view the usage of the commands"
    echo "Use -s [username] to search for a username"
    echo "Use -c to crack an archive password"
    echo "Use -cw followed by your wordlist path to crack a website"
    echo "Use -lm to launch Maltego"
    echo "-------------------------------------------------------------"
elif [ "$1" == "-u" ]; then
        echo "-------------------------------------------------------------------"
        echo "Usage for -s: type -s followed by the username you're searching for"
        echo "Usage for -c: type -c followed by your wordlist file to crack an archive"
        echo "Usage for -cw: type -cw followed by the wordlist path"
        echo "-------------------------------------------------------------------"
elif [ "$1" == "-s" ]; then
    if [ -z "$2" ]; then
        echo -e "${RED}Error. Enter a username.${DEFAULT}" >&2
    else
        echo -e "Searching for $2...${DEFAULT}"
        maigret $2
        echo -e "${GREEN}Done searching.${DEFAULT}"
    fi
elif [ "$1" == "-c" ]; then
        read -p "Enter the target file: " target
            read -p "Enter the file type: " filetype
    echo "Available targets: zip, 7z"
    
    if [[ ! " ${FILETYPES[*]} " == *" $filetype "* ]]; then
        echo -e "${RED}Error. File type not found.${DEFAULT}" >&2
        exit 1
    else
        if [ "$filetype" == "zip" ]; then
                if [ -z "$2" ]; then
                        echo -e "${RED}Error. Try providing a wordlist."
                        exit 1
                else
                    echo "Extracting password..."
                    zip2john "$target" > password.txt 2> /dev/null
                    echo -e "Cracking password...${DEFAULT}"
                    john --wordlist="$2" password.txt
                fi
        else
            echo "Extracting password..."
            7z2john "$target" > password.txt 2> /dev/null
            echo -e "Cracking password...${DEFAULT}"
            john --wordlist="$2" password.txt
        fi
        john --show password.txt
    fi
elif [ "$1" == "-cw" ]; then
        if [ -z "$2" ]; then
                echo -e "${RED}Error. Put a wordlist path." >&2
                exit 1
        else
                read -p "Enter an URL: " target
                echo -e "Cracking websites's directories' passwords...${DEFAULT}"
                gobuster dir -u $target -w $2
                echo -e "${GREEN}Done cracking!"
        fi
elif [ "$1" == "-lm" ]; then
        echo -e "[+] Launching Maltego...${DEFAULT}"
        maltego
        echo -e "${GREEN}[*] Maltego terminated."
else
    echo -e "${RED}Error. Flag not recognized.${DEFAULT}" >&2
fi

echo -e "${DEFAULT}"
