provider "aws" {
  region  = "ap-south-1"
}

module "vpc" {
  source             = "../../modules/vpc"
  vpc_cidr           = "10.0.0.0/16"
  vpc_name           = "arc-iac-vpc"
  azs                = ["ap-south-1a", "ap-south-1b"]
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24"]
  enable_nat_gateway = true

  tags = {
    Environment = "testing"
    Project     = "arc-vpc"
  }
}
