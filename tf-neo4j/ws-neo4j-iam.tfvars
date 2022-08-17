cloudwatch_logs_enabled=true

project="tflab"
environment="develop"

neo4j_key="core"
neo4j_instance_count=3
neo4j_instance_type="t4g.micro"
ami="ami-020ef1e2f6c2cc6d6"
termination_protection=false
key_name="tf_key"
subnet_ids=["subnet-09e8a4b23c4dfa0a8", "subnet-0e2f1909b7f0b5b48", "subnet-0bd6ca7f03bc7f9bc"]
security_group_ids=["sg-07bba049ef26664ab"]

tags = {
    TagEnvironment = "develop"
    TagWorkspace  = "develop"
    TagExtra = "develop-workspace"
}

ebs_device_name = "/dev/xvdf"
volume_type = "gp2"
volume_size = 8
volume_iops = 0
volume_encryption_enabled = true
volume_path = "/var/neo4j"

vpc_id = "vpc-00a2df302500bbec8"

discovery_port = 5000
raft_port = 7000
transaction_port = 6000
bolt_port = 9000

bolt_enabled = true
client_sg_ids=["sg-07bba049ef26664ab"]

http_enabled = false
https_enabled = true

backup_enabled = false

r53_domain = "cmcloudlab436.info"
root_vl_encrypt = true
data_block_encrypted = true

create_instance_profile = true
instance_profile = "CustomerManaged_tflab_develop_ec2-role"