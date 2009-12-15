# preparation
apt-get update
apt-get upgrade

# time
dpkg-reconfigure tzdata
apt-get install ntp

# ruby enterprise edition
apt-get install build-essential zlib1g-dev libssl-dev libreadline5-dev
wget http://rubyforge.org/frs/download.php/66162/ruby-enterprise-1.8.7-2009.10.tar.gz
tar xzf ruby-enterprise-1.8.7-2009.10.tar.gz 
rm ruby-enterprise-1.8.7-2009.10.tar.gz 
cd ruby-enterprise-1.8.7-2009.10/
./installer
cd

# nginx + passenger
/opt/ruby/bin/passenger-install-nginx-module
apt-get install git-core
git clone git://github.com/jnstq/rails-nginx-passenger-ubuntu.git
mv rails-nginx-passenger-ubuntu/nginx/nginx /etc/init.d/nginx
/etc/init.d/nginx start
/etc/init.d/nginx status
/usr/sbin/update-rc.d -f nginx defaults

# java
apt-get install openjdk-6-jdk openjdk-6-jre openjdk-6-jre-headless openjdk-6-jre-lib -y
apt-get install unzip -y

# ubuntu user
useradd -d /home/ubuntu -m ubuntu
passwd ubuntu
chsh ubuntu

# key-based ssh only
vi /etc/ssh/sshd_config

  ChallengeResponseAuthentication no
  PasswordAuthentication no
  UsePAM no

/etc/init.d/ssh reload

# ec2 api tools
wget http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip&token=A80325AA4DAB186C80828ED5138633E3F49160D9
unzip ec2-api-tools.zip 
vi .profile

  export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
  export EC2_URL=https://eu-west-1.ec2.amazonaws.com
  export EC2_PRIVATE_KEY=~/pk-TM374PQ4KXOLLOWN5DUYXYB3M3EX3IQP.pem
  export EC2_CERT=~/cert-TM374PQ4KXOLLOWN5DUYXYB3M3EX3IQP.pem
  export EC2_HOME=~/ec2-api-tools-1.3-46266
  export PATH=$EC2_HOME/bin:$PATH

