package com.accenture.devops
import com.accenture.devops.JenkinsServerv2
import com.offbytwo.jenkins.model.Plugin
import org.gradle.api.DefaultTask
import org.gradle.api.internal.tasks.options.Option
import org.gradle.api.tasks.TaskAction

import javax.inject.Inject

class JenkinsAdminTask extends DefaultTask {
    def String host

    def String user

    def String password

    def List<String> plugins = new ArrayList()

    @Inject
    JenkinsAdminTask(String host, String user, String password, String plugins) {

        this.host = host
        this.user = user
        this.password = password
        if (plugins != null) {
            this.plugins.addAll(plugins.tokenize(','))
        }
    }

    @TaskAction
    def setup() {

        JenkinsServerv2 jenkins = new JenkinsServerv2(new URI(host), user, password)
        List<com.offbytwo.jenkins.model.Plugin> existingPlugins = jenkins.getPluginManager().getPlugins()
        existingPlugins.each{
            com.offbytwo.jenkins.model.Plugin p ->
                if (p.isHasUpdate()) {
                    p.version="latest"
                    jenkins.installNecessaryPlugins(p)
                }
                println "${p.getShortName()} ${p.getVersion()} ${p.isHasUpdate()}"
        }

        if (!this.plugins.isEmpty()) {
            this.plugins.each {
                com.offbytwo.jenkins.model.Plugin p = new Plugin()
                p.setShortName(it)
                p.setVersion("latest")
                logger.info("adding ${p.getShortName()}")
                jenkins.installNecessaryPlugins(p)
            }
        }

        jenkins.restart(true)

    }



}

