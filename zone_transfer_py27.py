#!/usr/bin/env python2.7

import dns.resolver
import dns.zone

domain = 'whatever_you_want.com'

def dns_transfer(domain):
    ns = dns.resolver.query(domain, 'NS')
    #ns = dns.resolver.resolve(domain, 'NS')
    for i in ns.response.answer:
        for j in i.items:
            try:
                z = dns.zone.from_xfr(dns.query.xfr(j.to_text(), domain))
                names = z.nodes.keys()
                names.sort()
                for n in names:
                    print(n.to_text() + '.' + domain)
            except:
                print("Failed for ns : " + j.to_text())

if __name__ == '__main__':
    dns_transfer(domain)
