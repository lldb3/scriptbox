#!/usr/bin/env bash

if [[ -f /etc/redhat-release ]]; then
  yum update -y 
  yum install -y cargo openssl-devel
fi

if [[ -f /etc/lsb-release ]]; then
  apt update -y
  apt remove -y rust
  curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh
  apt  install -y cargo libssl-dev pkg-config
fi


cargo install topgrade cargo-update lsd