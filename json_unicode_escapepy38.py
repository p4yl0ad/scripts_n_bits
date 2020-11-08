#!/usr/bin/env python2
from cmd import Cmd

def encode_payload(payload):
    line = payload.encode("hex")
    n = 2
    groups = [line[i:i+n] for i in range(0, len(line), n)]
    full = ''
    for x in groups:
        full = full + "\u00" + x
    retVal = full
    return retVal

class loop(Cmd):
    prompt="> "
    def default(self, params):
        payload = encode_payload(params)
        print(payload)

loop().cmdloop()
