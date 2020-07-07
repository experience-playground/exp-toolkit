#!/usr/bin/env bash

curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "awscli-v2.pkg"
sudo installer -verbose -pkg "awscli-v2.pkg" -target /
aws --version
