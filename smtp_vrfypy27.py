#!/usr/bin/env python2

import socket
import sys

if len(sys.argv) != 2:
    print "Usage: vrfy.py <username>"
    sys.exit(0)

with open('SMTP-ip-addresses.txt', 'r') as ipl:
    ips = (line.rstrip() for line in ipl) #ipl.readlines()
    for i in ips:
        print "VRFY root against the ip: " + i
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            connect = s.connect(( i , 25 ))
            banner = s.recv(1024)
            print banner
            s.send('VRFY ' + sys.argv[1] + '\r\n')
            result = s.recv(1024)
            print result
            s.close()
        except:
            print "failed against IP: " + i
