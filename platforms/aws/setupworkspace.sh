#!/usr/bin/env bash

curl "https://d2td7dqidlhjx7.cloudfront.net/prod/global/osx/WorkSpaces.pkg" -o "WorkSpaces.pkg"
sudo installer -verbose -pkg "WorkSpaces.pkg" -target /
aws --version
