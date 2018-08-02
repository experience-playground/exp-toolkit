#!/bin/bash

host=http://54.227.99.147/jenkins/
url=/pluginManager/installNecessaryPlugins

curl -u user:2yjF0mk66wFe $host + 'crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)'

# git plugin https://wiki.jenkins-ci.org/display/JENKINS/Git+Plugin
curl -X POST -d '<jenkins><install plugin="apache-httpcomponents-client-4-api@4.5.5" /></jenkins>' --header 'Content-Type: text/xml' $host$url

# artifactory plugin https://wiki.jenkins-ci.org/display/JENKINS/Artifactory+Plugin
#curl -X POST -d '<jenkins><install plugin="artifactory@2.2.1" /></jenkins>' --header 'Content-Type: text/xml' $host$url

# wait 20 sec
sleep 20

# jenkins safe restart
curl -X POST $host/safeRestart