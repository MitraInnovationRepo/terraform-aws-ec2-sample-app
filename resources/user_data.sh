#!/bin/bash

# On Linux
# install CodeDeploy agent
yum -y update
yum install -y ruby
yum install -y wget
cd /home/ec2-user

# wget https://{bucket-name}.s3.{region-identifier}.amazonaws.com/latest/install
# find {bucket-name} from https://docs.aws.amazon.com/codedeploy/latest/userguide/resource-kit.html#resource-kit-bucket-names
wget https://aws-codedeploy-us-east-2.s3.us-east-2.amazonaws.com/latest/install

chmod +x ./install
./install auto


# install java
wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm
yum -y install jdk-8u131-linux-x64.rpm