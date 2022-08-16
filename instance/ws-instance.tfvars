project="tflab"
name="terra"
environment="develop"

instance_count=1
ami="ami-020ef1e2f6c2cc6d6"
instance_type="t4g.micro"
key_name="tf_key"

sgs=["sg-041534fbbd3520f7a"]
subnets=["subnet-0962484fc1d7a0b4c","subnet-0128f9de32890947c"]

user_data=["init.sh"]

public_ip = true

tags = {
    TagEnvironment = "develop"
    TagWorkspace  = "workspace"
    TagExtra = "develop-workspace-tf"
}