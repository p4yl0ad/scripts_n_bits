#!/bin/bash

#MM:MM:MM:SS:SS:SS #00:0a:95:9d:68:16 #!@#$%^*&*(){}:">?<|~

show_menu() {
         echo "~~~~~~~~~~~~~~~~~~~~~~"
         echo " BLE EasySetup script "
         echo "~~~~~~~~~~~~~~~~~~~~~~"
         echo ""
         echo "Either enter a mac address or a name"
         echo "and this script will configure a private"
         echo "unadvertised bluetooth serial tether"
         echo ""
}

read_input() {
        read -p "Enter your choice > " user_input
        if [[ $user_input =~ ^([[:xdigit:]][[:xdigit:]]:){5}[[:xdigit:]][[:xdigit:]]$ ]]
        then
                connect_to_mac
        else
                mac_from_name
        fi
}

mac_from_name() {

        echo "removing ALL previously connected Devices from /var/lib/bluetooth"
        rm -rf /var/lib/bluetooth/*
        echo "Scanning for inputted device" 
        sleep 5
        hcitool scan > /dev/shm/output.txt
        device_line=$(cat /dev/shm/output.txt | grep -i $user_input)

        device_mac=$(echo $device_line | awk '{print $1}')
        device_name=$(echo $device_line | awk '{print $2}')
        bluetoothctl remove $device_mac
        echo $device_name 
        echo $device_mac

        echo "Connecting to the device "$device_name""
        echo $device_mac
        sleep 3
        bluetoothctl pair $device_mac
}

connect_to_mac() {
        #bluetooth pair $mac_address
        echo "connect_to_mac"
}

show_menu
read_input
