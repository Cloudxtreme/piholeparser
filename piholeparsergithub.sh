#!/bin/bash
## This will parse lists and upload to Github

## Timestamp
timestamp=`date --rfc-3339=seconds`

## Colors
red='\e[1;31m%s\e[0m\n'
green='\e[1;32m%s\e[0m\n'
yellow='\e[1;33m%s\e[0m\n'
blue='\e[1;34m%s\e[0m\n'
magenta='\e[1;35m%s\e[0m\n'
cyan='\e[1;36m%s\e[0m\n'

## Dependency check
printf "$blue"    "___________________________________________________________"
echo ""
printf "$green"   "Checking Dependencies"
{ if
which p7zip >/dev/null;
then
echo ""
printf "$yellow"  "p7zip is installed"
else
printf "$yellow"  "Installing p7zip"
sudo apt-get install -y p7zip-full
fi }
printf "$magenta" "___________________________________________________________"
echo ""

## Clean directories to avoid collisions
printf "$blue"    "___________________________________________________________"
echo ""
printf "$green"   "Clearing the Path."
sudo rm /etc/piholeparser/lists/*.txt
sudo rm /etc/piholeparser/mirroredlists/*.txt
sudo rm /etc/piholeparser/parsed/*.txt
sudo rm /etc/piholeparser/compressedconvert/*.7z
sudo rm /etc/piholeparser/compressedconvert/*.tar.gz
sudo rm /etc/piholeparser/compressedconvert/*.txt
sudo rm /var/www/html/compressedconvert/*.txt
printf "$magenta" "___________________________________________________________"
echo ""

## Make sure we are in the correct directory
cd /etc/piholeparser

## Pull new lists on github
printf "$blue"    "___________________________________________________________"
echo ""
printf "$green"   "Updating Repository."
sudo git pull
printf "$magenta" "___________________________________________________________"
echo ""

## Process lists that have to be extracted
printf "$blue"    "___________________________________________________________"
echo ""
printf "$green"   "Downloading and Extracting Compressed Lists."
sudo bash /etc/piholeparser/compressedconvert.sh
printf "$magenta" "___________________________________________________________"
echo ""

## Parse Lists
echo ""
echo "Parsing Lists."
sudo bash /etc/piholeparser/advancedparser.sh
printf "$magenta" "___________________________________________________________"
echo ""

## Cleanup
printf "$blue"    "___________________________________________________________"
echo ""
printf "$green"   "Cleaning Up."
sudo rm -r /etc/piholeparser/lists/*.txt
sudo rm /etc/piholeparser/compressedconvert/*.7z
sudo rm /etc/piholeparser/compressedconvert/*.tar.gz
sudo rm /etc/piholeparser/compressedconvert/*.txt
sudo rm /var/www/html/compressedconvert/*.txt
printf "$magenta" "___________________________________________________________"
echo ""

## Push Changes up to Github
printf "$blue"    "___________________________________________________________"
echo ""
printf "$green"   "Pushing Lists to Github"
sudo git config --global user.name "Your Name"
sudo git config --global user.email you@example.com
sudo git remote set-url origin https://USERNAME:PASSWORD@github.com/deathbybandaid/piholeparser.git
sudo git add .
sudo git commit -m "Update lists $timestamp"
sudo git push -u origin master
printf "$magenta" "___________________________________________________________"
echo ""
