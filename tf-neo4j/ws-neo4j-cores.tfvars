cloudwatch_logs_enabled=true

project="tflab"
environment="develop"

neo4j_key="core"
neo4j_instance_count=3
neo4j_instance_type="t4g.micro"
ami="ami-020ef1e2f6c2cc6d6"
termination_protection=false
key_name="tf_key"
subnet_ids=["subnet-0590cd49582402c34", "subnet-04e1974483778e931", "subnet-0a7cfd7625f350386"]
security_group_ids=["sg-016fac30612cf1c66"]

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

vpc_id = "vpc-0e7c4b09f06adf254"

discovery_port = 5000
raft_port = 7000
transaction_port = 6000
bolt_port = 9000

bolt_enabled = true
client_sg_ids=["sg-016fac30612cf1c66"]

http_enabled = false
https_enabled = true

backup_enabled = false

r53_domain = "cmcloudlab379.info"


