#!/bin/bash
 
# Set bash delimeter to be line break
IFS=$'\n'
 
# VPN DNS Server
vpndns=$(kubectl get service --namespace=kube-system -o jsonpath='{.spec.clusterIP}' kube-dns)
 
# Get adapter list
adapters=`networksetup -listallnetworkservices |grep -v denotes`
 
for adapter in $adapters
do
	echo "Updating dns for $adapter"
	dnssvr=(`networksetup -getdnsservers $adapter`)

	if [ $dnssvr != $vpndns ]; then
		# set dns server to the vpn dns server
		networksetup -setdnsservers $adapter $vpndns
	else
		# revert back to DHCP assigned DNS Servers
		networksetup -setdnsservers $adapter empty
	fi
done
