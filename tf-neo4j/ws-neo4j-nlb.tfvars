project="tflab"
environment="develop"

neo4j_key="core"
neo4j_instance_count=3
neo4j_instance_type="t4g.micro"
ami="ami-020ef1e2f6c2cc6d6"
termination_protection=false
key_name="tf_key"
subnet_ids=["subnet-0f79b2600322b6dca", "subnet-05c5770492fcc600c", "subnet-0b30e0986b6eba8fa"]
security_group_ids=["sg-0014c55ccc502904d"]

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

vpc_id = "vpc-082432fe921a8ecf4"

discovery_port = 5000
raft_port = 7000
transaction_port = 6000
bolt_port = 9000

bolt_enabled = true
client_sg_ids=["sg-0014c55ccc502904d"]

http_enabled = false
https_enabled = true

backup_enabled = false

r53_domain = "cmcloudlab737.info"
root_vl_encrypt = true
data_block_encrypted = true

create_instance_profile = true
instance_profile = "CustomerManaged_tflab_develop_ec2-role"
role_permissions_boundary = "Playground_AWS_Sandbox"
cloudwatch_logs_enabled = true

nlb_enabled = true
internal = true
