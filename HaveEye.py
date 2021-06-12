#!/usr/bin/python3

#api endpoint browser compatible https://www.dynarisk.com/home/data-breach-scanner
#HaveEye is a lightweight python script to interface with a public Breach detection API so you can have access in your commandline
#TODO
#Add the ability to have the report sent to said email
#Integreation with .bashrc so you get one check per system restart (Greets you on terminal with a report :) )


import requests
from pwn import *

topost = "https://dynarisk.com"
apiend = "/api/v1/scan/email"

token = "ICtqFI03Ne384S7LaN9XtuxiAqrwOZYeUiwNiiN1" #PUBLICALLY AVAILABLE API TOKEN TAKEN FROM BURP REQUEST
email = input("Input your email pls > ")

data = { '_token': token,
         'email': email }
r =  requests.post(url = topost + apiend, data = data)
output = r.text
#print(output)
if '"breach_contains":0' in output:
    log.success("Congrats You're Safe brochacha, keep it up :O ")
else:
    log.failure("You're Compromised Chief, id suggest a password change bossman ")

#TODO
#add option to send report to email :)
#add multiple api source access // dn checks ;)
