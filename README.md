# DimensionData cloud driver for Salt (Salt-Cloud)

#  HOW TO INSTALL:

#1) Download latest Salt Source from Git
#2) Install latest Apache Libcloud
#3) Add this file to the Salt source:
    cp dimensiondata.py <salt-src-root-dir>/salt/salt/cloud/clouds/.
#4) Compile Salt source:
    cd <salt-src-root-dir>/salt/salt/cloud/clouds/
    python -m compileall .
#5) Install Salt source to local/virtual environment
    pip install -e <salt-src-root-dir>/salt
#6) Create cloud provider and instance profile YAML files
#7) Use Salt/Salt-Cloud to automate MCP 2.0 cloud
