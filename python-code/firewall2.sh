#firewall local
#!/bin/bash
ipt="iptables"
#
#regras padroes
$ipt -F
$ipt -X
#
#políticas de acesso
$ipt -P INPUT DROP
$ipt -P OUTPUT DROP
$ipt -P FORWARD DROP
#
#liberar o loopback
$ipt -A INPUT -i lo -j ACCEPT
$ipt -A OUTPUT -o lo -j ACCEPT
#
#habilitar stateful
$ipt -A OUTPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT
#
#libera icmp
#https://capec.mitre.org/data/definitions/285.html
$ipt -A INPUT -p icmp --icmp-type 8 -i enp0s3 -s 192.168.15.6/24 -j ACCEPT
#libera acesso a porta 80
$ipt -A INPUT -p tcp --dport 80 -i enp0s3 -s 192.168.15.6/24 -j ACCEPT
#
#loga e libera acessos SSH
#SSH config: https://www.ssh.com/academy/ssh/sshd_config#root-login
$ipt -A INPUT -p tcp --dport 22 -j LOG --log-level info --log-prefix "SSH:"
$ipt -A INPUT -p tcp --dport 22 -i enp0s3 -s 192.168.15.6/24 -j ACCEPT
