#!/bin/sh
sudo locale-gen zh_CN.UTF-8
curl -L https://get.rvm.io | bash
rvm install 2.1
rvm gemset create qatime
