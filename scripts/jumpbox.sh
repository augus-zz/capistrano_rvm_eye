#!/usr/bin/env bash
apt-get update
apt-get install -y ruby2.3 ruby2.3-dev git

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable

source /etc/profile.d/rvm.sh
rvm reload
rvm install 2.4.1
rvm use 2.4.1
gem install bundler -N
gem install eye -N

cd /vagrant
bundle install

