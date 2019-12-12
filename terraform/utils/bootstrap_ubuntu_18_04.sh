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
# change docker-compose file 
bash -c "$SCRIPT"
# Start environment
docker-compose up -d

# install Confluent Cloud CLI
cd ~
curl -L https://cnfl.io/ccloud-cli | sh -s -- -b /usr/local/bin
ccloud completion bash > /etc/bash_completion.d/ccloud

mkdir /home/confluent/.ccloud
chown confluent:confluent /home/confluent/.ccloud
chmod 700 /home/confluent/.ccloud

cat <<'EOF' > /home/confluent/.ccloud/config
bootstrap.servers=${ccloud_broker_endpoint}
ssl.endpoint.identification.algorithm=https
security.protocol=SASL_SSL
sasl.mechanism=PLAIN
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username\="${ccloud_api_key}" password\="${ccloud_api_secret}";

# If you are using Confluent Cloud Schema Registry, add the following configuration parameters
basic.auth.credentials.source=USER_INFO
schema.registry.basic.auth.user.info=${ccloud_sr_api_key}:${ccloud_sr_api_secret}
schema.registry.url=https://${ccloud_sr_endpoint}
EOF

chown confluent:confluent /home/confluent/.ccloud/config

# Install Confluent Hub Client
wget "http://client.hub.confluent.io/confluent-hub-client-latest.tar.gz"

mkdir -p /home/confluent/opt/confluent/confluent-hub
tar -C /home/confluent/opt/confluent/confluent-hub/ -xvf confluent-hub-client-latest.tar.gz
rm ./confluent-hub-client-latest.tar.gz

chown confluent:confluent -R /home/confluent/opt/confluent/

cat <<'EOF' >> /home/confluent/.profile

# set PATH so it includes confluent hub client bin if it exists
if [ -d "$HOME/opt/confluent/confluent-hub/bin" ] ; then
    PATH="$HOME/opt/confluent/confluent-hub/bin:$PATH"
fi
EOF

# install Confluent Platform on Docker connecting to Confluent Cloud
cd /home/confluent/opt
wget ${cp_all_in_one_cloud_repo}
unzip 5.3.1-post.zip
mv ./examples-5.3.1-post/cp-all-in-one-cloud .
mkdir cp-all-in-one-cloud/scripts
chmod 755 cp-all-in-one-cloud/scripts
mv ./examples-5.3.1-post/ccloud/ccloud-generate-cp-configs.sh ./cp-all-in-one-cloud/scripts
chown confluent:confluent -R /home/confluent/opt/cp-all-in-one-cloud/
rm 5.3.1-post.zip
rm -r examples-5.3.1-post
cd cp-all-in-one-cloud

# Set ports for Control Center and ksql 
sed -i 's;\"9021:9021\";\"80:9021\";g' /home/confluent/opt/cp-all-in-one-cloud/docker-compose.yml
sed -i 's;CONTROL_CENTER_KSQL_ADVERTISED_URL: \"http:\/\/localhost:8089\";CONTROL_CENTER_KSQL_ADVERTISED_URL: \"http:\/\/$HOSTPUBIP:8089\";g' /home/confluent/opt/cp-all-in-one-cloud/docker-compose.yml

# Generate the a file of ENV variables used by Docker to connect to a Confluent Cloud Kafka Cluster
. /home/confluent/opt/cp-all-in-one-cloud/scripts/ccloud-generate-cp-configs.sh /home/confluent/.ccloud/config

chown confluent:confluent -R *

# Source the ENV variables from .bashrc
 cat <<'EOF' >> /home/confluent/.bashrc

# Set Confluent Cloud connection environment variables for Confluent Platform Docker 
if [ -f /home/confluent/opt/cp-all-in-one-cloud/delta_configs/env.delta ]; then
. /home/confluent/opt/cp-all-in-one-cloud/delta_configs/env.delta
fi
EOF