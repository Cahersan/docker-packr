# sshd
#
# VERSION               0.0.1

FROM     ubuntu
MAINTAINER Thatcher R. Peskens "thatcher@dotcloud.com"

# Adding our debian repository
ADD mygpgkey_pub.gpg /root/
ADD mygpgkey_sec.gpg /root/
RUN apt-key add /root/mygpgkey_pub.gpg && apt-key add /root/mygpgkey_sec.gpg 
RUN echo "deb http://172.17.42.1/ubuntu precise main" > /etc/apt/sources.list.d/packages.internal.list

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

# Install app
RUN apt-get install -y django-polls

# Add ssh key to allow deployment with ansible. Modify permissions
RUN mkdir /root/.ssh && chmod 700 /root/.ssh
ADD id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 400 /root/.ssh/authorized_keys && chown root. /root/.ssh/authorized_keys

# Installs missing locale
RUN locale-gen en_US en_US.UTF-8

EXPOSE 22
CMD    /usr/sbin/sshd -D
