# iptablesd

Transactional and Linear Iptables Command. This project is a PoC, please don't use it in production!

# Issue(s)

## Race condition

Sometimes, iptables need to be dynamic, in concurrent/parallel world. 
Iptables use lock on kernel side, and sometime, you can make race conditions. 
Sometime... You can have security issue with your firewall.

## Backup

Currently, I haven't found any solution to extract properly iptables rules.

## Monitoring

How to monitor iptables rules? 

# Solution

One solution is to make dedicated daemon for iptables. Some programs (like systemd, or docker) 
doesn't use kernel API to add rules, they uses directly /sbin/iptables 
or /sbin/ip6tables. In our case, we can bootstrap our solution by backup 
those two command and make your own over it.
