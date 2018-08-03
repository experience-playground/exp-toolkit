#!/bin/bash
./tools/sdk.sh
source ~/.sdkman/bin/sdkman-init.sh
#sdk install java
#sdk install groovy
#sdk install gradle
./gradlew --version
sdk c java
sdk c groovy
sdk c gradle
mkdir keys
ssh-keygen -t rsa -N "" -C "jenkins@accenture.com" -f keys/id_jenkins
