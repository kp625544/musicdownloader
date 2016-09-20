#!/bin/bash

#some variables
DEFAULT_ROUTE=$(ip route show default | awk '/default/ {print $3}')
IFACE=$(ip route show | awk '(NR == 2) {print $3}')
JAVA_VERSION=`java -version 2>&1 |awk 'NR==1{ gsub(/"/,""); print $3 }'`
MYIP=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')

######### Install VirutalBox
function installvirtualbox {

	echo -e "\e[1;31mThis option will install all essential programs!\e[0m"
	echo -e ""
	echo -e "Do you want to install it ? (Y/N)"
			read install
			if [[ $install = Y || $install = y ]] ; then	
				echo -e "\033[31m====== Installing======\033[m"
				sleep 2
				sudo apt-get update && sudo apt-get install wget youtube-dl ffmpeg lame xclip lynx curl
			else
				echo -e "\e[32m[-] Ok,maybe later !\e[0m"
			fi
}

######### Take Song Name as input
function createsongvariable {
        echo -e $songname
	echo -e "\e[1;31mEnter the song Name you want to download!\e[0m"
        read songname
	echo -e ""
	echo -e "Are you sure it's" $songname "Y/N"
			read install
			if [[ $install = Y || $install = y ]] ; then	
				echo -e "\033[31m====== Installing======\033[m"
				##sleep 2
				readonly newsongname=$(echo -e $songname | sed -e "s/ /+/g")
                             
			else
				echo -e "\e[32m[-] Ok,maybe later !\e[0m"
			fi
}
######### Search and download song
function searanddown {
        echo -e $newsongname
        lynx -cmd_script=/home/hydra/Desktop/AUR/ost-project/youtube.txt http://www.youtube.com/results?search_query=$newsongname
        cat results\?search_query\=$newsongname.txt |   grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' |   sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//' > shortlist.txt
        sed -ne '/watch/p' shortlist.txt > shortlist1.txt
        readonly RESULT=($(cat shortlist1.txt))
        echo "${RESULT[0]}"
        sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
        sudo chmod a+rx /usr/local/bin/youtube-dl
        youtube-dl "https://youtube.com${RESULT[0]}"
        sleep 5
	
}

######### Cleaning directory
function cleandir {

	echo -e "\e[1;31mThis option will delete unnecessary garbage from the folder!\e[0m"
	echo -e ""
	echo -e "Do you want to do it ? (Y/N)"
			read install
			if [[ $install = Y || $install = y ]] ; then	
				rm shortlist.txt
                                rm shortlist1.txt
                                rm results\?search_query\=$newsongname.txt
			else
				echo -e "\e[32m[-] Ok,maybe later !\e[0m"
			fi
}

function mainmenu {
echo -e "
\033[32m################################################################################\033[m
\033[1;36m
|                                                                              |
|                          I love Security and Haking.                         |
|______________________________________________________________________________|
|                                                                              |
|                                                                              |
|                                                                              |
|                 User Name:          [   kp625544    ]                        |
|                                                                              |
|                 Password:           [   ********    ]                        |
|                                                                              |
|        My facebook: www.facebook.com/kp625544                                |
|                                                                              |  
|    My github: www.github.com/kp625544                                        |     |                                                                              |
|                                                                              |
|                                   [ OK ]                                     |
|______________________________________________________________________________|
\033[m                                        
                  	    Script by HYDRA
                     	    Version : 3.0 \033[32m$version\033[m
Script Location : \033[32m$0\033[m
Connection Info :-----------------------------------------------
  Gateway: \033[32m$DEFAULT_ROUTE\033[m Interface: \033[32m$IFACE\033[m My LAN Ip: \033[32m$MYIP\033[m
\033[32m###############################################################################\033[m"

select menusel in "Install Essential programs" "Enter your Song Name" "Search and Download" "Update tools to latest version" "EXIT PROGRAM"; do
case $menusel in
	"Install Essential programs")
		installvirtualbox
		clear ;;
	
	"Enter your Song Name")
		createsongvariable
		clear ;;
	
	"Search and Download")
		searanddown 
		clear ;;
	"Update tools to latest version")
		updatetools
		clear ;;

	
	"EXIT PROGRAM")
		clear && exit 0 ;;
		
	* )
		screwup
		clear ;;
esac

break

done
}

while true; do mainmenu; done
