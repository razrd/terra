packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.3"
      source  = "github.com/hashicorp/amazon"
    }
  }
}