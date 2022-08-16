module "neo4j" {
  source                 = "../instance"
  project                = var.project
  environment            = var.environment
  name                   = var.name
  instance_count         = var.neo4j_instance_count
  instance_type          = var.neo4j_instance_type
  ami                    = var.ami
  termination_protection = var.termination_protection
  key_name               = var.key_name
  subnets                = var.subnet_ids
  sgs                    = [aws_security_group.sg.id,var.security_group_ids[0]]
  user_data              = data.template_cloudinit_config.userdata.*.rendered

  tags = merge(
    var.tags,
    {
      "neo4j" = "${var.neo4j_key}"
    }
  )
}

resource "aws_ebs_volume" "ebs_data_block" {
  count             = var.neo4j_instance_count
  availability_zone = module.neo4j.instance_azs[count.index]
  size              = var.volume_size
  type              = var.volume_type
  iops              = var.volume_iops

  tags = merge(
    var.tags,
    {
        "Name"        = "${var.project}-${var.environment}-${var.name}-${var.neo4j_key}-${count.index + 1}"
        "Environment" = var.environment
        "Project"     = var.project
    }
  )
}

resource "aws_volume_attachment" "ebs_attach" {
  count       = var.neo4j_instance_count
  device_name = var.ebs_device_name
  volume_id   = "${aws_ebs_volume.ebs_data_block.*.id[count.index]}"
  instance_id = "${module.neo4j.instance_ids[count.index]}"
}

data "template_cloudinit_config" "userdata" {
  count         = var.neo4j_instance_count
  gzip          = true
  base64_encode = true

  # Install stuff
  part {
    content_type = "text/cloud-config"

    content = <<EOF
package_update:true    
packages:
  - awscli
  - telnet
  - git
  - unzip
  - zip
EOF
  }

  # Add an fstab entry for the mounts # doesnt work.
  part {
    content_type = "text/cloud-config"

    content = <<EOF
mounts:
  - [ "LABEL=NEO4J", "${var.volume_path}", ext4, "defaults,nofail", "0", "2" ]
fs_setup:
  - label: NEO4J
    filesystem: ext4
    device: "${var.ebs_device_name}"
    partition: auto
runcmd:
  - mkdir -p ${var.volume_path}
EOF
  }

  # Prepare and mount the EBS volume
  part {
    content_type = "text/x-shellscript"

    content = <<EOF
#!/bin/bash

logMsg() {
    echo -ne "HERE>>>>> INFO  : $1\n"
}
logErr() {
    echo -ne "HERE>>>>> ERROR : $1\n"
}

hasItRun() {
    statusCode=$1
    message="$2"
    if [ $statusCode -eq 0 ]; then
        logMsg "$message ..Executed OK"
    else
        logErr "$message ..Execution failed with code. $statusCode"
    fi
}

# Wait for the EBS volumes to become ready

logMsg "Waiting for EBS mount ${var.ebs_device_name}"
aws --region $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//') ec2 wait volume-in-use --filters Name=attachment.instance-id,Values=$(curl -s http://169.254.169.254/latest/meta-data/instance-id) Name=attachment.device,Values=${var.ebs_device_name}
ret=$?
hasItRun "$ret" "${var.ebs_device_name} is aws mounted?"

# Create FS and make entry into /etc/fstab
if ! $(blkid -p ${var.ebs_device_name} &>/dev/null); then
  logMsg "${var.ebs_device_name} is not mounted, First run...formatting device."
  mkfs.ext4 "${var.ebs_device_name}" -L NEO4J
  ret=$?
  hasItRun "$ret" "${var.ebs_device_name} is formatted?"

  logMsg "Fetching UUID.."
  uuid=$(sudo blkid -p /dev/xvdf | awk '{print $3}' | sed 's/"//g')
  logMsg "$uuid"
  cp -fp /etc/fstab /etc/fstab.bak

  mkdir -p ${var.volume_path}
  mount "${var.ebs_device_name}" "${var.volume_path}"
  
  logMsg "Mount checks"
  df -k ${var.volume_path}

  #Persist the setting 
  #UUID=a2fc8833-86dd-42c6-af77-6510651f4e3a     /           xfs    defaults,noatime  1   1
  
  echo "$uuid     ${var.volume_path}           ext4    defaults,nofail  0   2" >> /etc/fstab
  ret=$?
  hasItRun "$ret" "Fstab entry"

  ls -ltr /etc/fstab*
fi

# Make sure the mount path exists

# Mount the drive
mount -a
ret=$?
hasItRun "$ret" "${var.ebs_device_name} mount command worked fine?.."  
EOF
  }

  part {
      content_type = "text/x-shellscript"

      content = <<EOF

#!/bin/bash

logMsg() {
    echo -ne "HERE>>>>> INFO  : $1\n"
}

logMsg "Setting users and directories"
adduser neo4j
mkdir -p /var/neo4j/certificates
mkdir -p /var/neo4j/certificates/https
mkdir -p /var/neo4j/certificates/https/trusted
mkdir -p /var/neo4j/certificates/https/revoked
mkdir -p /var/neo4j/certificates/bolt
mkdir -p /var/neo4j/certificates/bolt/trusted
mkdir -p /var/neo4j/certificates/bolt/revoked
mkdir -p /var/neo4j/certificates/backup
mkdir -p /var/neo4j/certificates/bolt/revoked
mkdir -p /var/neo4j/certificates/bolt/trusted
mkdir -p /var/neo4j/data
mkdir -p /var/neo4j/data/transactions
mkdir -p /var/neo4j/data/dumps
mkdir -p /var/neo4j/data/backup
mkdir -p /var/neo4j/licenses
mkdir -p /var/neo4j/metrics
mkdir -p /var/neo4j/plugins
mkdir -p /var/neo4j/logs
mkdir -p /var/neo4j/run

echo "neo4j        soft  nproc  65536" >> /etc/security/limits.conf
echo "neo4j        hard  nproc  65536" >> /etc/security/limits.conf
echo "neo4j        soft  nofile  50000" >> /etc/security/limits.conf
echo "neo4j        hard  nofile  50000" >> /etc/security/limits.conf
#     <domain>        <type>  <item>  <value>

chown -R neo4j:neo4j /var/neo4j 
  EOF
    }
}