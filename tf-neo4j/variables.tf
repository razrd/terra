variable "project" {
  description = "String(required): Project name"
}

variable "environment" {
  description = "String(required): Environment name"
}

variable "customer" {
  description = "String(optional): Customer name"
  default = ""
}

variable "name" {
  description = "String(optional, \"neo4j\"): Name to use for the Neo4j cluster"
  default     = "neo4j"
}

variable "ami" {
  description = "String(optional, \"ami-1b791862\"): AMI to be used for the Neo4j nodes"
  default     = "ami-1b791862"
}

variable "key_name" {
  description = "String(required): ID of the SSH key to use for the Neo4j nodes"
  default = "tf_key"
}

variable "neo4j_instance_count" {
  description = "Int(optional, 1): Size of the Neo4j cluster"
  default     = 3
}

variable "neo4j_instance_type" {
  description = "String(optional, t2.small): Instance type to use for the Core instances"
  default     = "t2.small"
}

variable "neo4j_key" {
  description = "String(required, core|replica): Text if the ec2 is core or replica"
  default     = "core"
}

variable "ebs_device_name" {
  description = "String(optional, 'dev/xvdf'): Mount name of the volume"
  default     = "/dev/xvdf"
}

variable "volume_type" {
  description = "String(optional, \"gp2\"): EBS volume type to use"
  default     = "gp2"
}

variable "volume_size" {
  description = "Int(required): EBS volume size (in GB) to use"
}

variable "volume_iops" {
  description = "Int(required if volume_type=\"io1\"): Amount of provisioned IOPS for the EBS volume"
  default     = 0
}

variable "volume_encryption_enabled" {
  description = "Bool(optional, false): Whether to enables EBS encryption"
  default     = false
}

variable "volume_path" {
  description = "String(optional, \"/var/lib/neo4j/data\"): Mount path of the EBS volume"
  default     = "/var/neo4j/"
}

variable "vpc_id" {
  description = "String(required): VPC ID where to deploy the cluster"
}

variable "subnet_ids" {
  description = "List(required): Subnet IDs where to deploy the cluster"
  type        = list
  default     = []
}

variable "security_group_ids" {
  description = "List(optional, []): Extra security group IDs to attach to the cluster. Note: a default SG is already created and exposed via outputs"
  type        = list
  default     = []
}

variable "client_sg_ids" {
  description = "List(optional, []): Security group IDs for client access to the cluster, via Bolt and/or HTTP(S)"
  type        = list
  default     = []
}

variable "backup_sg_ids" {
  description = "List(optional, []): Security group IDs for the backup client(s)"
  type        = list
  default     = []
}

variable "discovery_port" {
  description = "Int(optional, 5000): Causal clustering discovery port"
  default     = 5000
}

variable "raft_port" {
  description = "Int(optional, 7000): Causal clustering raft port"
  default     = 7000
}

variable "transaction_port" {
  description = "Int(optional, 6000): Causal clustering transaction port"
  default     = 6000
}

variable "bolt_enabled" {
  description = "Int(optional, true): Whether to allow client connections via Bolt"
  default     = true
}

variable "bolt_port" {
  description = "Int(optional, 9000): Bolt client port"
  default     = 9000
}

variable "http_enabled" {
  description = "Int(optional, true): Whether to allow client connections via HTTP"
  default     = true
}

variable "http_port" {
  description = "Int(optional, 7474): HTTP client port"
  default     = 7474
}

variable "https_enabled" {
  description = "Int(optional, false): Whether to allow client connections via HTTPS"
  default     = false
}

variable "https_port" {
  description = "Int(optional, 7473): HTTPS client port"
  default     = 7473
}

variable "backup_enabled" {
  description = "Int(optional, false): Whether to allow client connections for taking backups"
  default     = false
}

variable "backup_port" {
  description = "Int(optional, 6362): Backup client port"
  default     = 6362
}

variable "termination_protection" {
  description = "Bool(optional, true): Whether to enable termination protection on the Ne04j nodes"
  default     = true
}

variable "cloudwatch_logs_enabled" {
  description = "Bool(optional, false): Whether to enable Cloudwatch Logs"
  default     = false
}

variable "r53_domain" {
  description = "String(optional, \"\"): R53 master name to use for setting neo4j DNS records. No records are created when not set"
  default     = ""
}

variable "tags" {
  description = "Map(optional, {}): Optional tags"
  type        = map
  default     = {}
}

variable "root_vl_kms_key_id" {
  default = ""
  description = "(string:optional) KMS Key for the root volume"
}

variable "root_vl_encrypt" {
  default = false
  description = "(bool) Encrypt the root volume with AWS Key"
}

variable "data_block_kms_key_id" {
  default = ""
  description = "(string:optional) KMS Key for the data volume"
}

variable "data_block_encrypted" {
  default = false
  description = "(bool) Encrypt the data volume with AWS Key"
}

variable "create_instance_profile" {
  default = false
  description = "(boolean:optional) enables creation of iam. "
  type = bool
}

variable "instance_profile" {
  default = ""
  description = "(string:optional) When create_instance_profile is false set this. "
}

variable "s3_bucket_ref" {
  description = "(string:required) S3 bucket for IAM read/write, used for tf state and db confs"
  default = "lab01s3tf"
}

variable "nlb_enabled" {
  description = "(boolean:required) Enables NLB creation for instances"
  type = boolean
  default =  false
}

variable "load_balancer_type" {
  description = "(string:required) default set as network for nlb"
  type = string
  default =  "network"
}

variable "internal" {
  description = "(boolean:required) default set as internal"
  type = boolean
  default =  true
}

variable "idle_timeout" {
  description = "(number:optional) idle timeout for the  nlb before closing connection"
  default = 60
}

variable "enable_cross_zone_load_balancing" {
  description = "(boolean:optional) cross az nlb setting"
  type = boolean
  default =  false
}

variable "enable_deletion_protection" {
  description = "(boolean:optional) delete protect for nlb"
  type = boolean
  default =  false
}
  
variable "ip_address_type" {
  description = "(string:optional) default set as ipv4, other option /'dualstack'/"
  type = string
  default =  "ipv4"
}
  