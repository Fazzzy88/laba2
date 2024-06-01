#!/bin/bash
local_ip=$(ip a | grep 192.168)
hostname=$(hostname)
dns_server=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
gateway=$(ip r | grep 'def' | awk '{print $3}')
ssh_port=$(cat /etc/ssh/sshd_config | grep "Port" | awk '{print $2}' | head -n1)
root_login=$(cat /etc/ssh/sshd_config | grep 'PermitRootLogin' | head -n1 | awk '{print $2}')
allow_users=$(cat /etc/ssh/sshd_config | grep 'AllowUsers' | awk '{print $2}')
established_connections=$(netstat -tnpa | grep 'ESTABLISHED.*sshd' | wc -l)
if [ -z $(ping ya.ru -c 1 | grep -e transmitted -e received) ]; then internet_conn=False; else internet_conn=True; fi 
chrony_sources=$(chronyc sources | grep 'ans.local' | awk '{print $2}')
httpd_state=$(systemctl status httpd | grep Active | awk '{print $2}')
index=$(cat /var/www/html/site/index.html | grep ans)
www=$(cat /etc/httpd/conf.d/www.conf | grep 'ans.local' | awk '{print $2}')
rabota=$(curl www.ans.local | grep 'ans.local')

{
	
	if [[ "$local_ip" == *192.168.100.254/24* ]];
		then ip=True;
		else ip=False;
	fi

	if [[ "$hostname" == web1.ans.local ]];
		then hn=True;
		else hn=False;
	fi

	if [[ "$dns_server" == "77.88.8.8" ]];
		then dns=True;
		else dns=False;
	fi
	
	if [[ "$gateway" == *192.168.100.254* ]];
		then gw=True;
		else gw=False;
	fi

	if [[ "$ssh_port" == 22 ]];
		then ssh=True;
		else ssh=False;
	fi

	if [[ "$root_login" == no ]];
		then rl=True;
		else rl=False;
	fi

	if [[ "$allow_users" == sshuser ]];
		then au=True;
		else au=False;
	fi

 	if [[ "$chrony_sources" == *www.ans.local* ]];
		then cs=True;
		else cs=False;
	fi

	if [[ "$httpd_state" == active ]];
		then htpd=True;
		else htpd=False;
	fi

	if [[ "$index" == *ans.local* ]];
		then ind=True;
		else ind=False;
	fi

	if [[ "$www" == *ans.local* ]];
		then ww=True;
		else ww=False;
	fi

	if [[ "$rabota" == *ans.local* ]];
		then rab=True;
		else rab=False;
	fi


} &> /dev/null

echo '{"ip": "'$ip'"}' | jq .
echo '{"hostname": "'$hn'"}' | jq .
echo '{"dns_server": "'$dns'"}' | jq .
echo '{"gateway"}: "'$gw'"}' | jq .
echo '{"ssh_port": "'$ssh'"}' | jq .
echo '{"root_login": "'$rl'"}' | jq .
echo '{"allow_users": "'$au'"}' | jq .
echo '{"established_connections": "'$established_connections'"}' | jq .
echo '{"ya_ping": "'$internet_conn'"}' | jq .
echo '{"chrony_sources": "'$cs'"}'| jq .
echo '{"httpd_state": "'$htpd'"}'| jq .
echo '{"idex_html": "'$ind'"}'| jq .
echo '{"www.conf": "'$ww'"}'| jq .
echo '{"site": "'$rab'"}'| jq .
