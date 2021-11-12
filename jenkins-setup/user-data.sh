#!/bin/bash

# Update Package Repositories and automatically say yes to any prompts (-y)
yum update -y
# Install EPEL and wget
amazon-linux-extras install epel  -y
yum install wget -y
# Install openjdk-11 (again accepting prompts automatically)
amazon-linux-extras install java-openjdk11 -y

# Download Maven version 3.8.3
cd /tmp
wget https://www-eu.apache.org/dist/maven/maven-3/3.8.3/binaries/apache-maven-3.8.3-bin.tar.gz
tar xf /tmp/apache-maven-*.tar.gz -C /opt
ln -s /opt/apache-maven-3.8.3 /opt/maven
# Set Maven Environment Variables
cat >/etc/profile.d/maven.sh <<EOF 
export JAVA_HOME=/usr/lib/jvm/jre-11-openjdk
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH=${M2_HOME}/bin:${PATH}
EOF
chmod +x /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh
# Remove archive
rm -f apache-maven-3.8.3-bin.tar.gz

# Download Jenkins Repo and Install Key
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
# Install and start jenkins
yum -y install jenkins
service jenkins start
chkconfig jenkins on

# Install Docker
yum install docker -y
# Start and Enable Docker
systemctl enable --now docker
# Add jenkins user to the docker group
usermod -aG docker jenkins
