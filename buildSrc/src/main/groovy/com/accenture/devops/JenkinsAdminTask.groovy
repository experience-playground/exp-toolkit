package com.accenture.devops
import com.accenture.devops.JenkinsServerv2
import org.gradle.api.DefaultTask
import org.gradle.api.tasks.TaskAction

class JenkinsAdminTask extends DefaultTask {
    @TaskAction
    def setup(String host, String user, String password) {
        JenkinsServerv2 jenkins = new JenkinsServerv2(new URI(host), user, password)
        List<com.offbytwo.jenkins.model.Plugin> plugins = jenkins.getPluginManager().getPlugins()
        plugins.each{
            com.offbytwo.jenkins.model.Plugin p ->
                if (p.isHasUpdate()) {
                    p.version="latest"
                    jenkins.installNecessaryPlugins(p)
                }
                println "${p.getShortName()} ${p.getVersion()} ${p.isHasUpdate()}"
        }

        jenkins.restart(true)
    }


}

