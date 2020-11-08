#!/usr/bin/env python3
from cmd import Cmd
from payload import encode_payload, send_payload

class loop(Cmd):
    prompt="> "

    def default(self, params):
        payload = encode_payload(params)
        ret = send_payload(payload)
        if type(ret) is list:
            for v in ret:
                if type(v) is dict:
                    for val in v.values():
                        print(val)
                else:
                    print(v)
        else:
            print(ret)
        


loop().cmdloop()
