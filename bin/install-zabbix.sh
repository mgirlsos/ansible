#!/bin/bash
##########################################
# Ansible install zabbix-agent  script.
#
# Install zabbix agent on Linux server.
#  
###########################################
# Contact:
#  lisa.shen@ef.com
###########################################
# ChangeLog:
#  20170527    LS    Version 1.0
###########################################

hostfile=''
keyfile=''
zbx_server=''
default_keyfile='/home/ubuntu/itis_cw/key/itis_id_rsa'

ECHO_USAGE(){
cat   << EOF
Usage:
bash $(basename $0 )  -i  <hostfile>  -k <keyfile>  -h <bj|sg>

	-i <hostfile>,		Input your hostfile
	-k <keyfile>,		Input your keyfile (Default:itis_id)
	-h <bj|sg>		Setup zabbix server address

EOF
}
[ $# -eq 0 ] && ECHO_USAGE && exit 1
while [ $# -gt 0 ]
do
case $1 in
	 -i)
		hostfile=$2
		shift;shift
	;;
	 -k)
		keyfile=$2
		shift;shift
	;;
	-h)
		if [ $2 == 'bj' ];then
			zbx_server='10.163.13.99'
		elif [ $2 == 'sg' ];then
			zbx_server=10.160.114.182
		else
			echo "Sorry,Unknow zabbix server"
			echo "Please input 'bj' or 'sg' "
			echo  "Script quit."
			exit 2
		fi
		shift;shift
	;;

	 *)
		 ECHO_USAGE  && exit 3
	;;
esac
done
if [ -z "$hostfile"  -o  -z "$zbx_server" ];then 
	 ECHO_USAGE && exit 4
fi
[ ! -f "$hostfile" ] && echo "Host file:$hostfile not exists." && echo "Script quit." && exit 5
if [ -z "$keyfile" ]  ;then export keyfile="$default_keyfile"; fi
[ ! -f "$keyfile" ] && echo "Key file:$hostfile not exists." && echo "Script quit." && exit 5

# ansible-playbook install zabbix-agent
ansible-playbook  -i $hostfile  /root/ansible/ansible/yaml/install_zabbix_agent.yml  -u ubuntu --private-key=$keyfile -e zbx_server=$zbx_server

# ansible restart zabbix-agent
#ansible -i $hostfile  all -m shell -a "sudo service zabbix-agent restart"    -u ubuntu --private-key=$keyfile 



