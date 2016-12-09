#!/bin/bash
yum -y update
yum -y install git-all
yum -y install gcc
yum -y install wget
wget https://pypi.python.org/packages/source/s/setuptools/setuptools-7.0.tar.gz --no-check-certificate
tar xzf setuptools-7.0.tar.gz
cd setuptools-7.0
python setup.py install
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
virtualenv ~/.salt
source ~/.salt/bin/activate
pip install M2Crypto
pip install pyzmq PyYAML pycrypto msgpack-python jinja2 psutil futures tornado
cd /opt
git clone https://github.com/DimensionDataSA/salt.git
pip install -e ./salt
mkdir -p ~/.salt/etc/salt
cp ./salt/conf/master ./salt/conf/minion ~/.salt/etc/salt
