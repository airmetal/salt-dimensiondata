# Dimension Data provider for SaltStack

## Overview
Install script includes the Salt develop (2016.11 develop) branch fork. 
This branch has been updated to support external provisioning. Meaning you can now create an MCP server cluster from an external (public) network. Previously only private IP was supported which meant that only VM's in the same VLAN could be provisioned as minions. 

## Installation
Download install script from https://s3.amazonaws.com/ddsalt/install-salt-dev.sh  or clone this repo.

## Usage

## Instructions to create a complete SaltStack environment on Red Hat Linux

Note:  These instructions have only been tested on Red Hat Linux 7.  Logically they should also work for Red Hat 6 and Centos 6 & 7.

### 0. Download install script and make it executable before invoking it. The script will install all prereqs and salt development repo.

	curl -O http://s3.amazonaws.com/ddsalt/install-salt-dev.sh
	chmod 744 install-salt-dev.sh
	./install-salt-dev.sh
	 
### 1. Activate your virtual environment

	source ~/.salt/bin/activate
	
### 2. Configure your provider credentials. Example:

	vi ~/.salt/etc/salt/cloud.providers.d/dimensiondata.conf
	
### 3. Configure your profile ( i.e. template for deploying a server). Example:
 
 	vi ~/.salt/etc/salt/cloud.profiles.d/didata-web.conf
 	
### 4. Configure you maps ( i.e. deploying multiple servers in groups). Example:
 
    vi ~/.salt/etc/salt/cloud.maps.d/didata-web-centos.conf
    
    
### 5. Commands (make sure you are in the virtual env (step 1) )

####  List images

	salt-cloud -c ~/.salt/etc/salt --list-images my-dimensiondata-config
	
####  Create server

    salt-cloud -c ~/.salt/etc/salt -p centos7 web1
    
####  Destroy server web1

    salt-cloud -d -c ~/.salt/etc/salt -p centos7  web1
    
####  Create servers using maps (use '-P' option to create servers in parallel)

	salt-cloud -c ~/.salt/etc/salt -m ~/.salt/etc/salt/cloud.maps.d/didata-web-centos.conf -P
	
####  Destroy servers using maps (use '-P' option to destroy servers in parallel)

	salt-cloud -d -c ~/.salt/etc/salt -m ~/.salt/etc/salt/cloud.maps.d/didata-web-centos.conf -P


## Notes:

### Provision on same VLAN as Salt Master
Review the sample 
~/.salt/etc/salt/cloud.profiles.d/didata-web-na12.conf 
The property ssh_gateway=private_ips is required to ensure once the servers are provisioned the Salt Master can bootstrap the nodes(servers)

### Provision over external network using Public IP's
Review the sample
 ~/.salt/etc/salt/cloud.profiles.d/didata-web-na9.conf
 The property remote_client=true is required.  

### Create a new VLAN
If you are creating a new VLAN then a vlan_base_ip key/value is also required.

### Create a new Network Domain 
Creating a new Network Domain also requires two VLAN key/value pairs, i,e  vlan  & vlan_base_ip

