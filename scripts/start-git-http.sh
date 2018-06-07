#!/bin/bash

# Installs Apache and git
yum -y update
yum -y -e0 install httpd git

# Starts the apache server
systemctl start httpd.service
