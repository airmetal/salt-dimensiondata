# Dimension Data provider for SaltStack

## Overview
Install script includes the Salt develop (2016.11 develop) branch fork. 
This branch has been updated to support external provisioning. Meaning you can now create an MCP server cluster from an external (public) network. Previously only private IP was supported which meant that only VM's in the same VLAN could be provisioned as minions. 

## Installation
Download install script from https://s3.amazonaws.com/ddsalt/install-salt-dev.sh  or clone this repo.

## Usage
### Provision on same VLAN as Salt Master
Review the sample ~/.salt/etc/salt/cloud.profiles.d/didata-web-na12.conf. The property ssh_gateway=private_ips is required to ensure once the servers are provisioned the Salt Master can bootstrap the nodes(servers)
### Provision over external network using Public IP's
Review the sample ~/.salt/etc/salt/cloud.profiles.d/didata-web-na9.conf.  The property remote_client=true is required.  
### Create a new VLAN
If you are creating a new VLAN then a vlan_base_ip key/value is also required.
### Create a new Network Domain 
Creating a new Network Domain also requires two VLAN key/value pairs, i,e  vlan  & vlan_base_ip
