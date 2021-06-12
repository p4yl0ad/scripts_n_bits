#!/bin/bash            


#EasyIP is a tool i wrote in bash to easily select an interfaces ip address and append it to your bash prompt in order to make remembering local IP addressess easier in labs.

#chmod +x easyIP.sh && bash easyIP.sh
#follow the prompts and make sure to open a new terminal once youre done. To change your ip to another , simply run the script again and select the apropriate interface.


show_menus() {
        clear
        echo "~~~~~~~~~~~~~~~~~~~~~~"
        echo " H T B - IF - M E N U "
        echo "~~~~~~~~~~~~~~~~~~~~~~"
        echo " This application is designed to list your local"
        echo " IP addresses e.g. tun0 10.10.xx.xx ."
        echo " "
        echo " You will then be prompted to enter the interface "
        echo " to use. The script will append a new prompt"
        echo " style to your terminal which contains the ip "
        echo " as the hostname, e.g. username@10.13.12.11"
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
    echo "These are the interfaces you have available to choose from"
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

#TODO
#add function that uses regex and tail to remove the appended $PS1 EXPORT or utilize the ability of having $PS1 $PS2 etc
