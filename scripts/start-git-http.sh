#!/bin/bash

# Installs Apache and git
yum -y update
yum -y -e0 install httpd git

# Creates the git repo directory
git_dir='/var/www/git'
mkdir "$git_dir"

# Sets the git config that will hook into git-http-backend
cat > /etc/httpd/conf.d/git.conf <<- GitConf
# Git over HTTP
<VirtualHost *:80>
  SetEnv GIT_PROJECT_ROOT $git_dir
  SetEnv GIT_HTTP_EXPORT_ALL
  ScriptAlias /git/ /usr/libexec/git-core/git-http-backend/

  <Location /git/>
  </Location>
</VirtualHost>
GitConf

# Starts the apache server
systemctl start httpd.service
