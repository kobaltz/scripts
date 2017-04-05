#!/bin/bash
# Install a custom MySQL 5.7 version - https://www.mysql.com
#
# To run this script on Codeship, add the following
# command to your project's setup commands:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/mysql-5.7.sh | bash -s
#
# Add the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * MYSQL_VERSION
# * MYSQL_PORT
#

echo "Making MySQL DIR"
mkdir -p "/home/rof/mysql-5.7.17"


echo "Downloading MySQL 5.7.17"
cd "/home/rof/"
wget "https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.17-linux-glibc2.5-x86_64.tar.gz"

echo "Extracting MySQL 5.7.17"
tar -xaf "mysql-5.7.17-linux-glibc2.5-x86_64.tar.gz" --strip-components=1 --directory "/home/rof/mysql-5.7.17"

echo "Making directories"
mkdir -p "/home/rof/mysql-5.7.17/data"
mkdir -p "/home/rof/mysql-5.7.17/socket"
mkdir -p "/home/rof/mysql-5.7.17/log"

echo "Writing my.cnf"
echo "#
# The MySQL 5.7 database server configuration file.
#
[client]
port    = 3307
socket    = /home/rof/mysql-5.7.17/socket/mysqld.sock

# This was formally known as [safe_mysqld]. Both versions are currently parsed.
[mysqld_safe]
socket    = /home/rof/mysql-5.7.17/socket/mysqld.sock
nice    = 0

[mysqld]
user    = rof
pid-file  = /home/rof/mysql-5.7.17/mysqld.pid
socket    = /home/rof/mysql-5.7.17/socket/mysqld.sock
port    = 3307
basedir   = /home/rof/mysql-5.7.17/data
datadir   = /home/rof/mysql-5.7.17/data/mysql
tmpdir    = /tmp
lc-messages-dir = /home/rof/mysql-5.7.17/share/english
skip-external-locking

# Instead of skip-networking the default is now to listen only on
# localhost which is more compatible and is not less secure.
bind-address    = 127.0.0.1

# * Fine Tuning
max_allowed_packet  = 16M
thread_stack    = 192K
thread_cache_size = 8

# * Query Cache Configuration
query_cache_limit = 1M
query_cache_size        = 16M

# * Logging and Replication
log_error   = /home/rof/mysql-5.7.17/log/error.log

[mysqldump]
quick
quote-names
max_allowed_packet  = 16M

[isamchk]
key_buffer    = 16M
" > "/home/rof/mysql-5.7.17/my.cnf"

echo "Writing MySQL Variables Again"


echo "Launching MySQL Daemon"
"/home/rof/mysql-5.7.17/bin/mysqld" --defaults-file="/home/rof/mysql-5.7.17/my.cnf" --initialize-insecure
