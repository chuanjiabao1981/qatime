## QATime

The source code of QATime

## Requirements for production

* Ruby 2.3.0 +
* PostgreSQL 9.4 +
* Redis 2.8 +
* ffmpeg
* ImageMagick 6.5 +

## Requirements for test

* google-chrome
* chromedriver
* xvfb

## Install in development

### Vagrant

Install [VirtualBox](https://www.virtualbox.org/) + [Vagrant](https://www.vagrantup.com/), and then:

```bash
vagrant up
vagrant ssh
cd /vagrant
./bin/setup
rake test:units
rake test:integration
rails s -b 0.0.0.0
```

Open http://localhost:3000 in host