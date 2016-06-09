sudo update-locale LC_ALL="en_US.utf8"

# 修改更新源
# sudo cp /etc/apt/sources.list /etc/apt/sources.list_backup
# sudo cp /vagrant/provision/config/sources.list /etc/apt/

sudo apt-get update
sudo apt-get install -y python-software-properties

# 添加postgresql源
# echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" | sudo tee -a /etc/apt/sources.list.d/pgdb.list
# wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# 添加ruby源
sudo apt-add-repository ppa:brightbox/ruby-ng

# 安装ruby postgresql
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y git \
                        build-essential \
                        redis-server \
                        ruby2.2 \
                        ruby2.2-dev \
                        chromium-browser \
                        xvfb \
                        imagemagick

# libxi6 libgconf-2-4 \

# postgresql
sudo apt-cache policy postgresql-9.4
sudo apt-get install -y postgresql-9.4
sudo apt-get install -y libpq-dev

# 安装nginx
sudo add-apt-repository ppa:nginx/stable
sudo apt-get -y update
sudo apt-get -y install nginx

# nginx配置
echo "Configuring Nginx"
sudo cp /vagrant/provision/config/nginx_vhost /etc/nginx/sites-available/qatime

sudo ln -s /etc/nginx/sites-available/qatime /etc/nginx/sites-enabled/

sudo rm -rf /etc/nginx/sites-enabled/default

# 启动服务
sudo service nginx start
sudo service postgresql start

# postgresql添加用户
sudo su postgres -c "createuser -d -R -S $USER"

# 修改gem源
gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/

# chromedriver
sudo cp /vagrant/provision/tools/chromedriver /usr/bin/
sudo chmod +x /usr/bin/chromedriver



# 安装chromium
# mkdir ~/tmp
# cd ~/tmp
# wget http://www.ubuntuupdates.org/package/core/precise/universe/security/chromium-browser
# sudo apt-get install -y chromium-browser_37.0.2062.120-0ubuntu0.12.04.2_amd64.deb
# rm -rf ~/tmp

sudo gem install bundler
bundle config mirror.https://rubygems.org https://gems.ruby-china.org
