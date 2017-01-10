# Dimension Data provider for SaltStack

## Overview
Install script includes the Salt develop (2016.11 develop) branch fork. 
This branch has been updated to support external provisioning. Meaning you can now create an MCP server cluster from an external (public) network for e.g. your laptop over the internet. Previously only private IP was supported which meant that only VM's in the same VLAN as the Salt Master could be provisioned and added as minions via the automation. 

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
	
### 3. Configure your profile ( i.e. template for deploying a server). Examples:

  #### External (Public) network       
 	 vi ~/.salt/etc/salt/cloud.profiles.d/didata-web-na9.conf
	
  #### Internal (Private) network       
 	 vi ~/.salt/etc/salt/cloud.profiles.d/didata-web-na12.conf
 	
### 4. Configure you maps ( i.e. deploying multiple servers in groups). Example:
 
    vi ~/.salt/etc/salt/cloud.maps.d/didata-web-centos.conf
    
    
### 5. Commands (make sure you are in the virtual env (step 1) )

####  List images

	salt-cloud -c ~/.salt/etc/salt --list-images my-dimensiondata-config
	
####  Create server

    salt-cloud -c ~/.salt/etc/salt -p centos7 web1
    
####  Destroy server web1

    salt-cloud -d -c ~/.salt/etc/salt -p centos7  web1
    
####  Create servers using maps 

	salt-cloud -c ~/.salt/etc/salt -m ~/.salt/etc/salt/cloud.maps.d/didata-web-centos.conf
	
####  Destroy servers using maps (use '-P' flag to destroy servers in parallel)

	salt-cloud -d -c ~/.salt/etc/salt -m ~/.salt/etc/salt/cloud.maps.d/didata-web-centos.conf


## Notes:

### Provisioning in parallel (-P flag) is NOT supported
Currently creating a new Network Domain or Vlan is not supported. Nodes/servers **MAY** work but there is no gaurantee, especially if configuring over public/external network. This is due to inability to issue concurrent operations on a shared network resource in Cloud Control.  You may want to pre-create the Network Domain and Vlan prior to creating the nodes, in which case you can use the **-P** flag; otherwise you can issue the command as shown above to issue operations serially.

### Deleting network resources are not supported with (-d) flag
The driver does not remove the network resources created during provisioning with the **-d** flag.  Only the nodes/servers are removed.

### Provision on same VLAN (Private Network) as Salt Master
Review the sample 
 **~/.salt/etc/salt/cloud.profiles.d/didata-web-na12.conf**
The property **ssh_gateway=private_ips** is required to ensure once the servers are provisioned the Salt Master can bootstrap the nodes(servers)

### Create a new VLAN
If you are creating a new VLAN then a **vlan_base_ip** key/value is also required.

### Create a new Network Domain 
Creating a new Network Domain also requires two VLAN key/value pairs, i,e  **vlan, vlan_base_ip**
_
