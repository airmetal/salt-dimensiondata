#!/bin/bash
yum -y update
yum groupinstall -y 'development tools'
yum install -y zlib-devel bzip2-devel openssl-devel xz-libs wget
wget https://www.python.org/ftp/python/2.7.12/Python-2.7.12.tar.xz
tar xf Python-2.7.12.tar.xz 
cd Python-2.7.12
./configure --prefix=/usr/local
make
make altinstall
ln -s /usr/local/bin/python2.7 /usr/local/bin/python
yum -y install git-all
yum -y install gcc
yum -y install openssl-devel
yum -y install python-devel
yum -y install wget
systemctl stop firewalld
systemctl disable firewalld
wget https://pypi.python.org/packages/source/s/setuptools/setuptools-7.0.tar.gz --no-check-certificate
tar xzf setuptools-7.0.tar.gz
cd setuptools-7.0
cd
mkdir -p /srv/salt/{states,reactor}
cd /srv/salt/states
wget https://s3.amazonaws.com/ddsalt/files/webserver.sls
cd /srv/salt/reactor
wget https://s3.amazonaws.com/ddsalt/files/job_ret.sls
wget https://s3.amazonaws.com/ddsalt/files/lb_pool_update.sls
wget https://s3.amazonaws.com/ddsalt/files/basic.sls
cd
python setup.py install
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
pip install virtualenv
virtualenv --system-site-packages ~/.salt
source ~/.salt/bin/activate
pip install M2Crypto
pip install pyzmq PyYAML pycrypto msgpack-python jinja2 psutil futures tornado
pip install apache-libcloud
pip install netaddr
cd /opt
git clone https://github.com/DimensionDataSA/salt.git -b develop --single-branch
pip install -e ./salt
mkdir -p ~/.salt/etc/salt
cd
rm -rf setuptools*
cp -r /opt/salt/conf/* ~/.salt/etc/salt/
cd ~/.salt/etc/salt/cloud.providers.d/
wget http://s3.amazonaws.com/ddsalt/etc/salt/cloud.providers.d/dimensiondata.conf
cd ~/.salt/etc/salt/cloud.profiles.d/
wget  https://s3.amazonaws.com/ddsalt/etc/salt/cloud.profiles.d/didata-web-na9.conf
wget https://s3.amazonaws.com/ddsalt/etc/salt/cloud.profiles.d/didata-web-na12.conf
cd ~/.salt/etc/salt/cloud.maps.d/ 
wget  http://s3.amazonaws.com/ddsalt/etc/salt/cloud.maps.d/didata-web-centos.conf 
wget https://s3.amazonaws.com/ddsalt/etc/salt/cloud.maps.d/didata-web-rhel.conf
cd ~/.salt/etc/salt
wget https://s3.amazonaws.com/ddsalt/files/autosign.conf
wget https://s3.amazonaws.com/ddsalt/files/master
wget https://s3.amazonaws.com/ddsalt/files/minion
cd

