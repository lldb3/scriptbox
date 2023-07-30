#!/usr/bin/env bash

if [[ -f /etc/redhat-release ]]; then
  yum update -y 
  yum install -y cargo
fi

if [[ -f /etc/lsb-release ]]; then
  apt-get update -y
  apt-get install -y cargo libssl-dev pkg-config
fi


cargo install topgrade cargo-upgrade