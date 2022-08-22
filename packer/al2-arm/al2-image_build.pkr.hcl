locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "al2-arm64" {
  ami_name      = "${var.ami_prefix}-arm64custom-${local.timestamp}"
  instance_type = "t4g.micro"
  region        = var.region
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-kernel-5.1*arm64-gp2"
      architecture        = "arm64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["137112412989"]
  }
  ssh_username     = "ec2-user"
  ssh_keypair_name = "packer"
  #ssh_private_key_file = "${path.cwd}/id_rsa-packer"
  ssh_private_key_file = "${var.filepath}id_rsa-packer"
  ssh_interface        = "private_ip"
  security_group_id    = "sg-05e5f945d0d4099d4"
  subnet_id            = "subnet-01a79237dae1c70f5"
  run_tags = {
    Creator = "Packer-Build"
  }
  run_volume_tags = {
    Creator = "Packer-Build"
  }
  snapshot_tags = {
    Creator = "Packer-Build"
  }
  tags = {
    Creator = "Packer-Build"
  }
}

build {
  name = "al2-custom-arm64-${local.timestamp}"
  sources = [
    "source.amazon-ebs.al2-arm64"
  ]

  provisioner "shell" {

    only = ["amazon-ebs.al2.arm64"]

    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo Installing openjdk",
      "sudo apt-get update",
      "sudo amazon-linux-extras install java-openjdk11",
      "echo $(java -version) > example.txt",
    ]
    pause_before = "10s"
  }

  provisioner "shell" {
    script = "arm64-init.sh"
  }

}