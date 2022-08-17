project="tflab"
name="terra"
environment="develop"

instance_count=1
ami="ami-020ef1e2f6c2cc6d6"
instance_type="t4g.micro"
key_name="tf_key"

sgs=["sg-0267ee345ef6a37c2"]
subnets=["subnet-0b9d05fe278c04509","subnet-01ad50e546c45bbca","subnet-0de294d46151b2551"]

user_data=["init.sh"]

public_ip = true

tags = {
    TagEnvironment = "develop"
    TagWorkspace  = "workspace"
    TagExtra = "develop-workspace-tf"
}

create_instance_profile = true
instance_profile = "CustomerManaged_tflab_develop_instance-role"
root_vl_encrypt = true