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
    
    
### 5. COMMANDS TO RUN (make sure you are in the virtual env (step 1) )

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
