#!/usr/bin/env bash

install_debian() {
  $SUDO apt update
  $SUDO apt install -y curl gnupg mariadb-server htop net-tools

  echo "deb https://rundeckpro.bintray.com/deb stable main" | sudo tee /etc/apt/sources.list.d/rundeck.list
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 379CE192D401AB61

  $SUDO apt update
  $SUDO apt install rundeckpro-enterprise -y
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

  echo "deb https://rundeckpro.bintray.com/deb stable main" | sudo tee /etc/apt/sources.list.d/rundeck.list
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 379CE192D401AB61

  $SUDO apt update
  $SUDO apt install rundeckpro-enterprise -y
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

  curl https://bintray.com/rundeckpro/rpm/rpm | $SUDO tee /etc/yum.repos.d/bintray-rundeckpro-rpm.repo

  $SUDO dnf update
  $SUDO dnf install -y rundeckpro-enterprise java
  $SUDO service rundeckd start
  $SUDO service firewalld stop
  clear
  echo " RunDeck is ready for Fedora"
  echo " wait for 5min to finish starting up rundeck"
  echo " after go to http://localhost:4440"
  echo " Default user and password is admin"

}

install_centos() {
  $SUDO yum update -y
  $SUDO yum install -y curl net-tools mysql-server htop

  curl https://bintray.com/rundeckpro/rpm/rpm | $SUDO tee /etc/yum.repos.d/bintray-rundeckpro-rpm.repo

  $SUDO yum update
  $SUDO yum install -y rundeckpro-enterprise java
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
