sudo update-locale LC_ALL="en_US.utf8"

# 支持 apt-add-repository
sudo apt-get install -y software-properties-common
sudo apt-get update
sudo apt-get upgrade -y

# 安装 git redis-server ruby
# 添加ruby源
echo 'install git redis-server and ruby'
sudo apt-add-repository -y ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y git \
                        build-essential \
                        redis-server \
                        ruby2.2 \
                        ruby2.2-dev

# 安装postgresql
echo 'postgresql installing'
sudo add-apt-repository "deb https://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main"
sudo apt-get update
sudo apt-get install -y --force-yes postgresql-9.4 libpq-dev

# sudo apt-cache policy postgresql-9.4
# sudo apt-get install -y postgresql-9.4 libpq-dev
echo 'postgresql starting.......'
sudo service postgresql start
# postgresql添加用户
sudo su postgres -c "createuser -d -R -S $USER"

# 安装ffmpeg
echo 'install ffmpeg'
sudo add-apt-repository ppa:mc3man/trusty-media
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install -y ffmpeg
echo 'create ffmpeg link'
mkdir ~/bin
ln -s /usr/bin/ffmpeg ~/bin/
ln -s /usr/bin/ffplay ~/bin/
ln -s /usr/bin/ffprobe ~/bin/
ln -s /usr/bin/ffserver ~/bin/

# chrome
# install chrome and xvfb
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo apt-get update
sudo apt-get install -y google-chrome-stable xvfb

# chromedriver
echo 'copy chromedriver'
sudo cp /vagrant/provision/tools/chromedriver /usr/bin/
sudo chmod +x /usr/bin/chromedriver

# 安装中文字体
echo 'install chinese fonts'
sudo apt-get install -y fonts-droid ttf-wqy-zenhei ttf-wqy-microhei fonts-arphic-ukai fonts-arphic-uming

# imagemagick
echo 'imagemagick installing'
sudo apt-get install -y imagemagick

# 修改gem源
echo 'modify gem sources'
gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/
sudo gem install bundler
bundle config mirror.https://rubygems.org https://gems.ruby-china.org
