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

-> # Infrastructure is hard <-

---

-> # Open source infrastructure is hard <-

---

-> # Open source infrastructure is hard <-

* Nobody is employed full time on project infrastructure
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

*every commit should be ready for delivery*

▛▀▀▀▀▀▀▀▀▀▀▀▜   ▛▀▀▀▀▀▜   ▛▀▀▀▀▀▀▀▜   ▛▀▀▀▀▜
▌development▐ ⇉ ▌build▐ ⇉ ▌archive▐ ⇉ ▌test▐
▙▄▄▄▄▄▄▄▄▄▄▄▟   ▙▄▄▄▄▄▟   ▙▄▄▄▄▄▄▄▟   ▙▄▄▄▄▟

---

# Continuous Delivery

*deploy production when the organization is ready*

 ▛▀▀▀▀▀▀▀▜   ▛▀▀▀▀▜   ▛▀▀▀▀▀▜   ▛▀▀▀▀▀▀▜
 ▌archive▐ ⇉ ▌test▐ ⇉ ▌stage▐ ⇉ ▌deploy▐
 ▙▄▄▄▄▄▄▄▟   ▙▄▄▄▄▟   ▙▄▄▄▄▄▟   ▙▄▄▄▄▄▄▟

---


-> # neat <-

---


-> # where does Jenkins fit in <-


---


-> *insert Jenkins Web UI screenshot here* <-

---

# Jenkins as part of CI/CD

traditionally

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

# Unit Testing

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

-> covers fundamental logic of your configuration management code <-


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

# Pipeline plugin
## formerly known as Workflow

* Define your delivery pipeline as code
* Feed it to Jenkins
* Enjoy a tasty beverage

---



*let's look at a basic Jenkinsfile*

---


-> # neat <-

---


-> # Q&A <-

-> [@agentdero](https://twitter.com/agentdero) <-
-> [rtyler](https://github.com/rtyler) <-
-> [tyler@linux.com](mailto:tyler@linux.com) <-
