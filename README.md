# Digital Accelerator Home

To get started you will need to run these commands in your terminal.
    ssh-keygen -t rsa -b 4096 -C "accenture.eid@accenture.com"
When prompted for location, enter


New to Git? Learn the basic Git commands
Configure Git for the first time

    git config --global user.name "Lastname, Firstname"
    git config --global user.email "accenture.eid@accenture.com"

Working with your repository
I just want to clone this repository
If you want to simply clone this empty repository then run this command in your terminal.


    git clone ssh://git@innersource.accenture.com/dqt/start-here.git

# Getting Started
If you're on a system that has 'bash' (linux, osx, cygwin, etc) run:
    
    ./go.sh

It runs the following commands and will give you sdkman, java, groovy, and gradle:

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

# Technology Accelerators
* [hybris](https://innersource.accenture.com/projects/A1129/repos/hybris-quickstart/browse) [Lou Baliotis](https://people.accenture.com/People/user/louis.baliotis)
* [AEM 6.3](https://innersource.accenture.com/projects/GSKDO/repos/aem_install_author_publish/browse) [Jon Ito](https://people.accenture.com/People/user/jon.ito)
* [angular](https://innersource.accenture.com/projects/NEW/repos/newao-angular/browse) Krett?
* [hybrid-mobile Ionic](https://innersource.accenture.com/projects/A3050/repos/ionic2-app-sample/browse) [Brandon Krett](https://people.accenture.com/People/user/brandon.krett)
* [native-android] [Brandon Krett](https://people.accenture.com/People/user/brandon.krett)
* [native-ios] [Brandon Krett](https://people.accenture.com/People/user/brandon.krett)
* [elastic-path](https://innersource.accenture.com/projects/EPB) [Matt Lewter](https://people.accenture.com/People/user/matthew.lewter)
* [spring-boot]()

# Process Runbooks

* [source-code-control]
* [ci-cd]
* [test-automation]

