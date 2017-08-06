# iptablesd

Transactional  and Linear  Iptables Command.  This project  is a  PoC,
please don't use it in production!

# Issue(s)

## Race condition

Sometimes, iptables need to  be dynamic, in concurrent/parallel world.
Iptables use  lock on  kernel side,  and sometime,  you can  make race
conditions.   Sometime...  You  can  have  security  issue  with  your
firewall.

## Backup

Currently, I haven't  found any solution to  extract properly iptables
rules.

## Monitoring

How to monitor iptables rules? 

# Solution

nftables is the  next project from netfilter, and will  give you a new
way of thinking  about firewalling. nftables is  now transactional, it
would be easier  to backup and make change on  firewall rules. So, why
make something like that for iptables?

To make it possible,  we need to create only one  entry point. In this
case,  I will  use unix  socket (stream),  one client  and one  server
application (as  daemon). To make  it simple, we'll not  create locks,
and will  just use socket  timeout. Connections are not  concurrent in
first time.
