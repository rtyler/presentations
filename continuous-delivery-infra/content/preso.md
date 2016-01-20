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


where does Jenkins fit in?

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

---

# Pipeline plugin
## formerly known as Workflow

* Define your delivery pipeline as code
* Feed it to Jenkins
* Enjoy a tasty beverage

---



*let's look at a Jenkinsfile*

---

-> # neat <-


---

-> # Q&A <-

-> [@agentdero](https://twitter.com/agentdero) <-
-> [rtyler](https://github.com/rtyler) <-
-> [tyler@linux.com](mailto:tyler@linux.com) <-
