packer {
  required_plugins {
    amazon = {
      version = ">= 1.8.3"
      source  = "github.com/hashicorp/amazon"
    }
  }
}
