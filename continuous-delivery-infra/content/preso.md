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


Affilliated with [SPI](http://spi-inc.org)

---


# Sponsor interlude

* CloudBees
* [OSUOSL](https://osuosl.org)
* [Microsoft](https://jenkins.io/blog/2016/05/18/announcing-azure-partnership/)
* PagerDuty
* Datadog
* Atlassian

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
** Conslidating to a single cloud
* Pagerduty rotation is comically small

---


# Continuous Delivery


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


# Continuous Delivery

> it hurts when I deploy

---


# Continuous Delivery

*so deploy more*

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


# Two Important ingredients

* Testability
* Consistency

---


# Two Important ingredients

* *Testability*
* Consistency

---


# Testing Infrastructure

 ▛▀▀▀▀▀▀▀▜   *▛▀▀▀▀▜*   ▛▀▀▀▀▀▜
 ▌ build ▐ ⇉ *▌test▐* ⇉ ▌stage▐
 ▙▄▄▄▄▄▄▄▟   *▙▄▄▄▄▟*   ▙▄▄▄▄▄▟

there are multiple layers of testing

* unit testing
* acceptance testing
* monitoring

---


# Testing Infrastructure

* unit testing
** [rspec-puppet](http://rspec-puppet.com)
* acceptance testing
** [serverspec](http://serverspec.org)
** [beaker](https://github.com/puppetlabs/beaker)
* monitoring
** [serverspec](http://serverspec.org)
** [Datadog](https://www.datadoghq.com/)

---


-> # quick refresher on how puppet works <-


-> (it's a graph of stuff) <-

---

# Unit testing

a contrived example

~~~ {.numberLines}
class jenkins::repo {
  include apt
  apt::source { 'jenkins':
    location => 'http://pkg.jenkins.io/debian-stable',
    release  => 'binary/',
  }
}
~~~

---


# Unit testing

assert that what you expect
to be in the graph
is in the graph


~~~ {.numberLines}
describe 'jenkins::repo' do
  it { should contain_class 'apt' }
  it { should contain_apt__source 'jenkins' }
end
~~~

---


# Unit testing

a less contrived exapmle

~~~
class jenkins::repo {
  case $::osfamily {
    'RedHat': { include jenkins::repo::redhat },
    'Debian': { include jenkins::repo::debian },
    default: { fail("Unsupported OS ${::osfamily}") }
  }
}
~~~

---


# Unit testing

with less contrived tests

~~~
describe 'jenkins::repo' do
  context 'on Debian-like systems' do
    let(:facts) { {:osfamily => 'Debian' } }
    it { should contain_class 'apt' }
    it { should contain_apt__source 'jenkins' }
  end
end
~~~

---


# Unit testing

covers fundamental logic of
configuration management code


(if you develop a puppet module,
omg plz write rspec-puppet)

---


-> # neat <-

---


*let's look at some real stuff*

---


-> # quick refresher on how puppet works <-


-> (it's a graph of stuff) <-


-> doesn't mean anything until you run it on a host <-

---


# Acceptance testing

with [serverspec](http://serverspec.org), a contrived example

~~~
describe 'www-host' do
  describe service('apache2') do
    it { should be_enabled }
    it { should be_running }
  end
  describe port(80) do
    it { should be_listening }
  end
end
~~~

---

# Acceptance testing

sharing behaviors across hosts

~~~
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
~~~

---


# Acceptance testing

using shared behaviors

~~~
describe 'www-host' do
  it_behaves_like 'a standard Linux host'

  describe service('apache2') do
    it { should be_enabled }
    it { should be_running }
  end
  describe port(80) do
    it { should be_listening }
  end
end
~~~

---


-> # neat <-

---


# Monitoring

* process checks
* service health checks
* synthetic transactions

---

# Testing Infrastructure


 ▛▀▀▀▀▀▀▀▜   *▛▀▀▀▀▜*   ▛▀▀▀▀▀▜
 ▌ build ▐ ⇉ *▌test▐* ⇉ ▌stage▐
 ▙▄▄▄▄▄▄▄▟   *▙▄▄▄▄▟*   ▙▄▄▄▄▄▟


there are multiple layers of testing

* unit testing: rspec-puppet
* acceptance testing: serverspec
* monitoring: datadog

---


# Two Important ingredients

* Testability
* *Consistency*

---


# Reproducible Infrastructure


Consistent, repeatable, environments

* VM images
* Containers
* Terraform

---

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
on physical hardware

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

~~~
docker::run { 'bind':
  command => undef,
  ports   => ['53:53', '53:53/udp'],
  image   => "jenkinsciinfra/bind:${image_tag}",
  volumes => ['/etc/bind/local:/etc/bind/local'],
}
~~~

---


-> the puppet pipeline is your container deployment pipeline <-

---


# Two Important ingredients

* Testability
* Consistency

---


-> # where does Jenkins fit in the picture? <-

We have some different pipelines to describe:

* Puppet (configuration management)
* Containers (packaging)

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


-> *insert Jenkins Web UI screenshot here* <-

---


# Pipeline plugin

* Define your delivery [pipeline as code](https://jenkins.io/doc/pipeline)
* Feed it to Jenkins
* Enjoy a tasty beverage

---

# Pipeline plugin

Model your delivery pipeline in *code*.

* Check it into Git
* Code review it
* Iterate on it

---



-> *let's look at a basic Jenkinsfile* <-

---


-> # neat <-

---


# Pipeline plugin(s)

* [Pipeline Stage View  plugin](https://wiki.jenkins-ci.org/display/JENKINS/Pipeline+Stage+View+Plugin)
* [GitHub Organization Folder](https://wiki.jenkins-ci.org/display/JENKINS/GitHub+Organization+Folder+Plugin)

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

▌staging ⎇    ↓ Automated tests, review, merge
▙▄▄▄▄▄▄▄▄▄▄▄▄▄x▄▄▄

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
** Conslidating to a single cloud
* Pagerduty rotation is comically small

---


# Missing pieces

* Tie delivery back into Jenkins with the [Puppet plugin](https://wiki.jenkins-ci.org/display/JENKINS/Puppet+Plugin)
* [beaker](https://github.com/puppetlabs/beaker) + Docker as Vagrant/serverspec replacement
* Docker Swarm for burstable container capacity

---


# Migration to Azure

* Continuous delivery of [Terraform](https://terraform.io) plans
* Better sizing of "machines" to their role
* Creating VM images via Jenkins
* [Blue-Green deployments](http://martinfowler.com/bliki/BlueGreenDeployment.html)

---


# we want you!

* #jenkins-infra on [Freenode](irc://irc.freenode.net/#jenkins-infra)
* [jenkins-infra](http://lists.jenkins-ci.org/mailman/listinfo/jenkins-infra) mailing list
* [jenkins-infra](https://github.com/jenkins-infra) on GitHub

---

# oh hey, tell me things

wouldn't a better way to manage and provision Jenkins with code be nice?


-> [JENKINS-31094](https://issues.jenkins-ci.org/browse/JENKINS-31094) <-

---

-> # Q&A <-

-> [@agentdero](https://twitter.com/agentdero) <-
-> [rtyler](https://github.com/rtyler) <-
-> [tyler@linux.com](mailto:tyler@linux.com) <-

## Resources

* [jenkins-infra](https://github.com/jenkins-infra)
* [pipeline-examples](https://github.com/jenkinsci/pipeline-examples)
* [Pipeline <3 Jenkins](https://jenkins.io/solutions/pipeline)
* [Docker <3 Jenkins](https://jenkins.io/solutions/docker)
