%title:
%author: R. Tyler Croy .oΟo. CloudBees
%date: 2016-01-19

# Continuous Delivery of Infrastructure
## with Jenkins

by: *R. Tyler Croy*


_Play along_:

    % docker run -ti rtyler/cd-preso

---


# Jenkins?


> Jenkins is the leading open source automation server.
> Built with Java, it provides hundreds of plugins to support building,
> testing, deploying and automation for virtually any project

---


-> # neat <-

---


# R. Tyler Croy
## CloudBees Jenkins Evangelist

* Jenkins since 2008
* Board member
* INFRA. *INFRA*. _*INFRA*_.

---


# Infrastructure

* *Resources*
** Machines (physical/virtual)
** Routers
** Load Balancers
** Switches
* *Configuration Management*
** Files
** Packages
** Secrets
* *Packaging tooling*
* *Deployment tooling*
* *Monitoring/alerting*

---


# Project Infrastructure

* Build infrastructure
** Jenkins master
** Jenkins agents
* Developer Tools
** JIRA
** Confluence
** IRC bot
** Code quality reporters
* Release infrastructure
** Apache/MirrorBrain
** Jenkins
** Ratings app
* Project tooling
** MeetingBot
** LDAP
** Account app
** Spam bot

---


# Beginning (2006 - 2011)

* Scavenged hardware
* Everything. Manually. Set. Up
* `sudo hopethisworks --force`

---


# Better-ish (2011 - 2014)

* Virtualization enters the picture
* Masterless [Puppet](https://puppetlabs.com/puppet/puppet-open-source)
* [Nagios](http://nagios.org)  monitoring
* Some development tools
** [librarian-puppet](http://librarian-puppet.com/)
** [puppet-lint](http://puppet-lint.com/)

---


# More Gooder (now)

* Centralized Puppet with [Puppet Enterprise](https://puppetlabs.com/puppet/puppet-enterprise)
* [Datadog](https://datadoghq.com) + [Pagerduty](https://pagerduty.com)
* DOCKER. *DOCKER*. *_DOCKER_*.
* More development tools
** [puppet-lint](http://puppet-lint.com/)
** [rspec-puppet](http://rspec-puppet.com/)
** [serverspec](http://serverspec.org/)
** [r10k](https://github.com/puppetlabs/r10k)

---


# Infrastructure is hard

* *Resources*
** Machines (physical/virtual)
** Routers
** Load Balancers
** Switches
* *Configuration Management*
** Files
** Packages
** Secrets
* *Packaging tooling*
* *Deployment tooling*
* *Monitoring/alerting*

---


# Open source infrastructure is hard

* *Resources*
** Machines (physical/virtual)
** Routers
** Load Balancers
** Switches
* *Configuration Management*
** Files
** Packages
** Secrets
* *Packaging tooling*
* *Deployment tooling*
* *Monitoring/alerting*

---


# Open source infrastructure is hard

* Nobody is employed full time on infra
* Donationware assets across *4 data centers*
* Pagerduty rotation is comically small

---


# Continuous Delivery


> it hurts when I deploy

---


# Continuous Delivery


*so deploy more*

---


# Continuous Delivery

every commit should be ready for delivery

deploy production when the organization is ready


▛▀▀▀▀▀▀▀▀▀▀▀▜   *▛▀▀▀▀▀▜*   *▛▀▀▀▀▀▀▀▜*   *▛▀▀▀▀▜*
▌development▐ ⇉ *▌build▐* ⇉ *▌archive▐* ⇉ *▌test▐*
▙▄▄▄▄▄▄▄▄▄▄▄▟   *▙▄▄▄▄▄▟*   *▙▄▄▄▄▄▄▄▟*   *▙▄▄▄▄▟*
                                        ↓
                *▛▀▀▀▀▀▀▜*   *▛▀▀▀▀▀▜*     ↙
                *▌deploy▐* ⇇ *▌stage▐* ⇇ ⇇
                *▙▄▄▄▄▄▄▟*   *▙▄▄▄▄▄▟*

---


-> # neat <-

---


# Two Important ingredients

* *Testability*
* *Reproducibility*

---


# Two Important ingredients

* *Testability*
* Reproducibility

----


# Testing Infrastructure


 ▛▀▀▀▀▀▀▀▜   *▛▀▀▀▀▜*   ▛▀▀▀▀▀▜
 ▌ build ▐ ⇉ *▌test▐* ⇉ ▌stage▐
 ▙▄▄▄▄▄▄▄▟   *▙▄▄▄▄▟*   ▙▄▄▄▄▄▟


there are multiple layers of testing

two examples:

* unit testing
* acceptance testing

---


# Testing Infrastructure

* unit testing
** [rspec-puppet](http://rspec-puppet.com)
* acceptance testing
** [serverspec](http://serverspec.org)
** [beaker](https://github.com/puppetlabs/beaker)

---


-> # quick refresher on how puppet works <-


-> (it's a graph of stuff) <-

---


# Unit testing

a contrived example

    class jenkins::repo {
        include apt
        apt::source { 'jenkins':
            location => 'http://pkg.jenkins-ci.org/debian-stable',
            release  => 'binary/',
        }
    }

---


# Unit testing

rspec-puppet asserts what you expect to be in the catalogue


    describe 'jenkins::repo' do
        it { should contain_class 'apt' }
        it { should contain_apt__source 'jenkins' }
    end

---


# Unit testing

a less contrived exapmle


    class jenkins::repo {
        case $::osfamily {
            'RedHat': { include jenkins::repo::redhat },
            'Debian': { include jenkins::repo::debian },
            default: { fail("Unsupported OS ${::osfamily}") }
        }
    }

---


# Unit testing

with less contrived tests


    describe 'jenkins::repo' do
        context 'on Debian-like systems' do
            jet(:facts) { {:osfamily => 'Debian' } }
            it { should contain_class 'apt' }
            it { should contain_apt__source 'jenkins' }
        end
    end

---


# Unit testing

covers fundamental logic of your configuration management code


---


-> # neat <-

---


-> # quick refresher on how puppet works <-


-> (it's a graph of stuff) <-


-> doesn't mean anything until you run it on a host <-

---


# Acceptance testing

with [serverspec](http://serverspec.org), a contrived example


    describe 'www-host' do
        describe service('apache2') do
            it { should be_enabled }
            it { should be_running }
        end
        describe port(80) do
            it { should be_listening }
        end
    end


---


# Acceptance testing

sharing behaviors across hosts

    require 'rspec'
    shared_examples 'a standard Linux host' do
        describe port(22) do
            it { should be_listening }
        end
        describe file('/etc/ssh/sshd_config') do
            it { should contain 'PasswordAuthentication no' }
        end
        # We should always have the agent running
        describe service('datadog-agent') do
            it { should be_enabled }
            it { should be_running }
        end
    end

---


# Acceptance testing

using shared behaviors

    describe 'www-host' do
        it_behaves_like 'a standard Linux host'
    end

---


-> # neat <-

---


# Testing Infrastructure


 ▛▀▀▀▀▀▀▀▜   *▛▀▀▀▀▜*   ▛▀▀▀▀▀▜
 ▌ build ▐ ⇉ *▌test▐* ⇉ ▌stage▐
 ▙▄▄▄▄▄▄▄▟   *▙▄▄▄▄▟*   ▙▄▄▄▄▄▟


there are multiple layers of testing

* unit testing: rspec-puppet
* acceptance testing: serverspec

---


# Two Important ingredients

* Testability
* *Reproducibility*

----


# Reproducible Infrastructure


DOCKER

*DOCKER*

_*DOCKER*_

---


# Docker: Pros

(besides the cool factor)

* Easy to partition workloads on physical hardware
* Consistent application runtime environment
* Rapidly evolving

---


# Docker: Cons

(besides the cool factor)

* What goes in Puppet vs Dockerfile
* iptables
* The image becomes another _thing_ with a lifecycle
* Rapidly evolving

---


# Where we use Docker

to keep the ugly things contained

* JIRA
* Confluence
* Bind9
* IRC bots

---


-> let's look at some Dockerfiles <-

---


# Puppet + Docker

* using [garethr-docker](https://github.com/garethr/garethr-docker) puppet module
* Puppet orchestrates running containers on hosts

    docker::run { 'bind':
        command => undef,
        ports   => ['53:53', '53:53/udp'],
        image   => "jenkinsciinfra/bind:${image_tag}",
        volumes => ['/etc/bind/local:/etc/bind/local'],
    }

---


-> the puppet pipeline is your container deployment pipeline <-

---


-> # where does Jenkins fit in the picture? <-

We have some different pipelines to describe:

* Puppet (configuration management)
* Containers (packaging)

---


-> *insert Jenkins Web UI screenshot here* <-

---


# Jenkins as part of CI/CD

traditionally, a series of jobs


▛▀▀▀▀▀▀▀▀▀▀▀▜   *▛▀▀▀▀▀▜*   ▛▀▀▀▀▀▀▀▜   *▛▀▀▀▀▜*
▌development▐ ⇉ *▌build▐* ⇉ ▌archive▐ ⇉ *▌test▐*
▙▄▄▄▄▄▄▄▄▄▄▄▟   *▙▄▄▄▄▄▟*   ▙▄▄▄▄▄▄▄▟   *▙▄▄▄▄▟*

---


# Jenkins as the CD Hub


▛▀▀▀▀▀▀▀▀▀▀▀▜   *▛▀▀▀▀▀▜*   *▛▀▀▀▀▀▀▀▜*   *▛▀▀▀▀▜*
▌development▐ ⇉ *▌build▐* ⇉ *▌archive▐* ⇉ *▌test▐*
▙▄▄▄▄▄▄▄▄▄▄▄▟   *▙▄▄▄▄▄▟*   *▙▄▄▄▄▄▄▄▟*   *▙▄▄▄▄▟*
                                        ↓
                *▛▀▀▀▀▀▀▜*   *▛▀▀▀▀▀▜*     ↙
                *▌deploy▐* ⇇ *▌stage▐* ⇇ ⇇
                *▙▄▄▄▄▄▄▟*   *▙▄▄▄▄▄▟*

---


# Pipeline plugin
## formerly known as Workflow

* Define your delivery pipeline as code
* Feed it to Jenkins
* Enjoy a tasty beverage

---



-> *let's look at a basic Jenkinsfile* <-

---


-> # neat <-

---


-> *how about something more complex* <-

---


-> # neat <-

---


# Gaps in Pipeline

* Developing a Jenkinsfile can be tricky
** [experimental pipeline editor plugin](https://github.com/jenkinsci/pipeline-editor-plugin)
* Currently no good pipeline visualization
** [Workflow Stage View](https://dzone.com/refcardz/continuous-delivery-with-jenkins-workflow)1
* Putting manual deployment gates in is
  [tricky](https://issues.jenkins-ci.org/browse/JENKINS-27039)

---


-> but wait <-

---


-> # you never deployed production you cheater <-

---


# Meet r10k

[r10k](https://github.com/puppetlabs/r10k) manages dynamic environments on a
Puppet master.

*Environment:* puppet agent -t --environment staging



Roughly speaking: Git branch == environment


---


# jenkins-infra pipeline


▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
▌pull request #1▐
▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟
              ↓
▌staging ⎇    ↓ Automated tests, review, merge
▙▄▄▄▄▄▄▄▄▄▄▄▄▄x▄▄▄
               ↘
▌production ⎇    ↘ Manual merge, auto-deploy
▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄x▄▄▄▄▄▄▄▄▄▄▄


---

# Webhooks complete the pipeline

* GitHub pings [r10k webhook server](https://github.com/acidprime/r10k#webhook-support)
* r10k deploys environment
* puppet agents pick up changes


---


-> # what is missing? <-

---


-> # Open source infrastructure is hard <-

* *Nobody is employed full time on project infrastructure*
* Donationware assets across 4 data centers
* Pagerduty rotation is comically small

---


# Missing pieces

* Tie delivery of files back into Jenkins with the [Puppet plugin](https://wiki.jenkins-ci.org/display/JENKINS/Puppet+Plugin)
* Cross data-center Docker Swarm
* [beaker-rspec](https://github.com/puppetlabs/beaker-rspec) + Docker as vagrant/serverspec replacement


---


# we want you!

* #jenkins-infra on [Freenode](irc://irc.freenode.net/#jenkins-infra)
* [jenkins-infra](http://lists.jenkins-ci.org/mailman/listinfo/jenkins-infra) mailing list
* [jenkins-infra](https://github.com/jenkins-infra) on GitHub

---


-> # Q&A <-

-> [@agentdero](https://twitter.com/agentdero) <-
-> [rtyler](https://github.com/rtyler) <-
-> [tyler@linux.com](mailto:tyler@linux.com) <-

## Resources

* [jenkins-infra](https://github.com/jenkins-infra)
* [workflow-examples](https://github.com/jenkinsci/workflow-examples)
* [Pipeline <3 Jenkins](https://jenkins-ci.org/solutions/pipeline)
* [Docker <3 Jenkins](https://jenkins-ci.org/solutions/docker)
