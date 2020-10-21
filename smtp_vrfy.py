#!/usr/bin/env python2

import socket
import sys

ip_start = '10.11.1.'

if len(sys.argv) != 2:
    print "Usage: vrfy.py <username>"
    sys.exit(0)

for i in range(0,256):
    ip = ip_start + str(i)
    print "VRFY root against the ip: " + ip
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        connect = s.connect(( ip , 25 ))
        banner = s.recv(1024)
        print banner
        s.send('VRFY ' + sys.argv[1] + '\r\n')
        result = s.recv(1024)
        print result
        s.close()
    except:
        print "failed against IP: " + ip
