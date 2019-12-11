#!/bin/bash
sudo sh -c 'apt-get update && apt-get upgrade --yes && if [ -f /var/run/reboot-required ]; then echo You should reboot; fi'
apt install -y unzip openjdk-8-jdk-headless jq

apt install -y docker.io docker-compose
# set environment
echo vm.max_map_count=262144 >> /etc/sysctl.conf
sysctl -w vm.max_map_count=262144
echo "    *       soft  nofile  65535
    *       hard  nofile  65535" >> /etc/security/limits.conf
sed -i -e 's/1024:4096/65536:65536/g' /etc/sysconfig/docker
# enable docker    
usermod -a -G docker confluent
systemctl start docker
systemctl enable docker

# install ATM Demo
mkdir -p /home/confluent/opt
chown confluent:confluent -R /home/confluent/opt
cd /home/confluent/opt
wget ${atmfrauddetectiondemo}
unzip master.zip
chown confluent:confluent -R /home/confluent/opt/hackathon-ksql-master/
rm master.zip
cd hackathon-ksql-master/
chown confluent:confluent -R *
rm -r terraform/*


# set PUBLIC IP and change the Data in docker-compose.yaml
HOSTPUBIP=`curl -H Metadata:true "http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/publicIpAddress?api-version=2017-08-01&format=text"` 
cd /home/confluent/opt/hackathon-ksql-master
SCRIPT="sed -i 's/CONTROL_CENTER_KSQL_ADVERTISED_URL: \"http:\/\/localhost:8088\"/CONTROL_CENTER_KSQL_ADVERTISED_URL: \"http:\/\/$HOSTPUBIP:8088\"/g' docker-compose.yml;"
# change ocker-compose file 
bash -c "$SCRIPT"
# Start environment
docker-compose up -d

