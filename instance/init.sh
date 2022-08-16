#!/bin/bash

logMsg() {
    echo -ne "HERE>>>>> INFO  : ${1}\n"
}
logErr() {
    echo -ne "HERE>>>>> ERROR : ${1}\n"
}

hasItRun() {
    statusCode=$1
    message="$2"
    if [ $statusCode -eq 0 ]; then
        logMsg "${message} ..Executed OK"
    else
        logErr "${message} ..Execution failed with code. ${statusCode}"
    fi
}


yum upgrade -y
ret=$? && hasItRun $ret "Upgrade amz2"

yum -y install zip unzip curl jq telnet git
ret=$? && hasItRun $ret "Component install for zip unzip jq telnet git"

yum install -y yum-utils

mkdir /tmp/installs && cd /tmp/installs
wget https://releases.hashicorp.com/terraform/1.2.7/terraform_1.2.7_linux_arm64.zip

unzip terraform_1.2.7_linux_arm64.zip
mv terraform /usr/local/bin
cd -

terraform version
ret=$? && hasItRun $ret "Terraform bin validate"

yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
yum -y install packer
ret=$? && hasItRun $ret "Packer install"

curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

aws --version
ret=$? && hasItRun $ret "Aws cli"

echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGLbz5vbBcirm0qEeE9KpWz+s8Md/vdDj/QIiR1qdLkn dev b@AL15N' >> /home/ec2-user/.ssh/authorized_keys
ret=$? && hasItRun $ret "Ssh key for laptop"