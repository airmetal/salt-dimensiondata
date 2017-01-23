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

	External (Public) network: 
		vi ~/.salt/etc/salt/cloud.profiles.d/didata-web-na9.conf
	
	Internal (Private) network:
		vi ~/.salt/etc/salt/cloud.profiles.d/didata-web-na12.conf
 	
### 4. Configure you maps ( i.e. deploying multiple servers in groups). Example:

	External:
    		vi ~/.salt/etc/salt/cloud.maps.d/didata-web-centos.conf
	Internal:
		vi ~/.salt/etc/salt/cloud.maps.d/didata-web-rhel.conf

### 5. Open up MCP firewall ports 4505, and 4506 for the salt master (i.e. this server)

### 6. Commands NOTE: _make sure you are in the virtual env (step 1)_ 

####  List images

	salt-cloud -c ~/.salt/etc/salt --list-images my-dimensiondata-config
	
####  Create server
    
    	External:
    		salt-cloud -c ~/.salt/etc/salt -p centos7 web5
    	Internal:
        	salt-cloud -c ~/.salt/etc/salt -p rhel7 web6
    
####  Destroy server web1

    	External:
    		salt-cloud -d -c ~/.salt/etc/salt -p centos7  web5
	
    	Internal:
    		salt-cloud -d -c ~/.salt/etc/salt -p rhel7  web6
    
####  Create servers using maps (use '-P' flag to create servers in parallel. CAUTION: Check *Notes* section first.)

    	External:
		salt-cloud -c ~/.salt/etc/salt -m ~/.salt/etc/salt/cloud.maps.d/didata-web-centos.conf
	
    	Internal:
    		salt-cloud -c ~/.salt/etc/salt -m ~/.salt/etc/salt/cloud.maps.d/didata-web-rhel.conf
	
####  Destroy servers using maps (use '-P' flag to destroy servers in parallel)

	External:
		salt-cloud -d -c ~/.salt/etc/salt -m ~/.salt/etc/salt/cloud.maps.d/didata-web-centos.conf

	Internal:
        	salt-cloud -d -c ~/.salt/etc/salt -m ~/.salt/etc/salt/cloud.maps.d/didata-web-rhel.conf

### (OPTIONAL) Install software using Salt Reactor on new VM's
Once the VM's are deployed if you would like to automate software installation you can integrate with the Salt Reactor event system to trigger software installation on our newly created VM's.  The instructions below demonstrate how to configure this with pre-configured files that were downloaded by the install script.

The scenario has been adapted from this [article](https://arnoldbechtoldt.com/blog/saltstack-event-driven-infrastructure-with-salt-reactor)

#### 1. Inspect master config

	cat ~/.salt/etc/salt/master
	
#### 2. Modify minion config and modify the master IP address to match your local machine (i.e. Salt Master) 
	
	vi ~/.salt/etc/salt/minion

#### 3. Inspect the Salt SLS file for deploying an Apache Webserver
     
        cat /srv/salt/states/webserver.sls
	
#### 4. Inspect the Reactor state (sls) files
 	
	cat /srv/salt/reactor/basic.sls
	cat /srv/salt/reactor/job_ret.sls
	cat /srv/salt/reactor/lb_pool_update.sls
	
#### 5.  Inspect (and modify) the autosign.conf file.  This ensures the minions are automatically authenticated by Salt Master.

	cat ~/.salt/etc/salt/autosign.conf

**_NOTE:_** Ensure that the name pattern matches the names of VM's you are created. The existing entry should work if you did not change the VM names. Otherwise update accordingly.

#### 6. Inspect and modify (as needed) the master and minion files.

	vi ~/.salt/etc/salt/master
	vi ~/.salt/etc/salt/minion
	
**_NOTE:_** At the very minimum you will likely need to modify the Salt Master IP address in the _~/.salt/etc/salt/minion_ file
	
#### 7.  Open two new command windows.

Execute the following command in the first window:
	
	salt-run -c ~/.salt/etc/salt state.event pretty=True 
	
Execute the following command in the second window:

	salt-master -c ~/.salt/etc/salt -l debug
	 
#### 6.  Destroy (if you had previously created VM's) and create new VM's 

Observe the messages in the two newly opened command windows (Step 5).

Once the execution has completed, launch the browser and point to the Public IP of any of the VM's created.  It should display the default Apache Webserver page.  **NOTE:  You will need to open port 80 in the firewall**

_This final step completely demonstrates how you can deploy VM's and provision software on newly created servers on the MCP platform._

## Notes:

### Debug
Add the **-l debug** option after the command to display detailed debug information. Example:

	salt-cloud -c ~/.salt/etc/salt -m ~/.salt/etc/salt/cloud.maps.d/didata-web-centos.conf -l debug

### Creating a new VLAN and multiple VM's in parallel (-P flag) is NOT supported
Currently creating a new Network Domain or Vlan is not supported. Nodes/servers **MAY** work but there is no gaurantee, especially if configuring over public/external network. Although retrying the samr command should create the remaining VM's if there was a failure on the first run during VLAN creation. This is due to inability to issue concurrent operations on a shared network resource (VLAN) in Cloud Control.  
You can also pre-create the Network Domain and Vlan prior to creating the nodes, in which case you can use the **-P** flag; otherwise you can issue the command as shown above to issue operations serially.

### Deleting network resources are not supported with (-d) flag
The driver does not remove the network resources created during provisioning with the **-d** flag.  Only the nodes/servers are removed.

### Provision on same VLAN (Private Network) as Salt Master
Review the sample :

	~/.salt/etc/salt/cloud.profiles.d/didata-web-na12.conf

The property **ssh_gateway=private_ips** is required to ensure once the servers are provisioned the Salt Master can bootstrap the nodes(servers)

### Create a new VLAN
If you are creating a new VLAN then a **vlan_base_ip** key/value is also required.

### Create a new Network Domain 
Creating a new Network Domain also requires two VLAN key/value pairs, i,e  **vlan, vlan_base_ip**
