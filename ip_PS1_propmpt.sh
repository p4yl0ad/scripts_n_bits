#!/bin/bash            

show_menus() {
        clear
        echo "~~~~~~~~~~~~~~~~~~~~~~"
        echo " H T B - IF - M E N U "
        echo "~~~~~~~~~~~~~~~~~~~~~~"
        echo " Make sure you have a "
        echo " OpenVPN connection to"
        echo " HackTheBox if using  "
        echo "          tun0        "
        echo ""
        echo "1. List & Select interface"
        echo "2. Exit"
        echo ""
}

read_options(){
        local choice
        read -p "Enter choice [ 1 OR 2 ] " choice
        echo ""
        case $choice in
                1) interface_lister ;;
                2) exit 0;;
                *) echo -e "${RED}Error...${STD}" && sleep 1
        esac
}

interface_lister(){
    echo "These are the interfaces you have available"
    echo ""
    ip addr | grep brd | grep -i inet | awk '{print $NF, $2}'
    echo ""
        interface_selector
}

interface_selector(){
    read -p "Enter the interface you want to add to your bash prompt e.g. tun0 for hackthebox > " choice2
    echo ""
    #echo $choice2
    #ip addr| grep -i $choice2 | grep -i inet | awk '{print $2}'
    echo ""
       bashrc_append_choice
}

bashrc_append_choice(){
        local choice
        echo "Do you want to add this IP to your bash prompt, it will look like: "
        echo "htb@kali-[10.10.14.33]-$"
        read -p "Enter '1' to continue or '2' to choose a different interface > " choice
        echo ""
        case $choice in
                1) bashrc_add ;;
                2) interface_selector ;;
                *) echo -e "${RED}Error...${STD}" && sleep 1
        esac
}

bashrc_add(){
        ip=$(ip addr|grep $choice2 | grep -i inet| awk '{print $2}' | cut -d "/" -f1)
        echo $ip
        echo "PS1='\[\033[01;31m\]\u@$ip \w $\[\033[00m\]'" >> ~/.bashrc
        source ~/.bashrc
}


show_menus
read_options
source ~/.bashrc
