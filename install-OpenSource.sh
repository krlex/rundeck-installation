#!/usr/bin/env bash

install_debian() {
  $SUDO apt update
  $SUDO apt install -y curl gnupg mariadb-server htop net-tools

  echo "deb https://rundeck.bintray.com/rundeck-deb /" | sudo tee -a /etc/apt/sources.list.d/rundeck.list
  curl 'https://bintray.com/user/downloadSubjectPublicKey?username=bintray' | sudo apt-key add -

  $SUDO apt update
  $SUDO apt install rundeck -y
  $SUDO apt clean

  $SUDO service rundeckd start
  clear
  echo " RunDeck is ready for Debian"
  echo " wait for 5min to finish starting up rundeck"
  echo " after go to http://localhost:4440"
  echo " Default user and password is admin"

}

install_ubuntu() {

  $SUDO apt update
  $SUDO apt install -y curl gnupg mysql-server htop net-tools

  echo "deb https://rundeck.bintray.com/rundeck-deb /" | sudo tee -a /etc/apt/sources.list.d/rundeck.list
  curl 'https://bintray.com/user/downloadSubjectPublicKey?username=bintray' | sudo apt-key add -

  $SUDO apt update
  $SUDO apt install rundeck -y
  $SUDO apt clean

  $SUDO service rundeckd start
  clear
  echo " RunDeck is ready for Ubuntu"
  echo " wait for 5min to finish starting up rundeck"
  echo " after go to http://localhost:4440"
  echo " Default user and password is admin"
}

install_fedora() {
  $SUDO dnf update -y
  $SUDO dnf install -y curl net-tools mysql-server htop

  $SUDO rpm -Uvh http://repo.rundeck.org/latest.rpm

  $SUDO dnf update
  $SUDO dnf install rundeck java
  $SUDO service rundeckd start
  clear
  echo " RunDeck is ready for Fedora"
  echo " wait for 5min to finish starting up rundeck"
  echo " after go to http://localhost:4440"
  echo " Default user and password is admin"

}

install_centos() {
  $SUDO yum update -y
  $SUDO yum install -y curl net-tools mysql-server htop

  rpm -Uvh http://repo.rundeck.org/latest.rpm
  $SUDO yum update
  $SUDO yum install -y rundeck java
  $SUDO service rundeckd start

  clear
  echo " RunDeck is ready for CentOS"
  echo " wait for 5min to finish starting up rundeck"
  echo " after go to http://localhost:4440"
  echo " Default user and password is admin"

}

usage() {
  echo
  echo "Linux distribution not detected"
  echo "Use: ID=[ubuntu|debian|centos|fedora]"
  echo "Other distribution not yet supported"
  echo

}

if [ -f /etc/os-release ]; then
  . /etc/os-release
elif [ -f /etc/debian_version ]; then
  $ID=debian
fi

if [[ $EUID -ne 0 ]]; then
  SUDO='sudo -H'
else
  SUDO=''
fi

case $ID in
        'ubuntu')
                install_ubuntu
        ;;
        'debian')
                install_debian
        ;;
        'centos')
                install_centos
        ;;
        'fedora')
                install_fedora
        ;;
        *)
          usage
        ;;
esac
