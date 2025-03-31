module "ec2" {
  source     = "../../modules/ec2"
  region     = "us-east-1"
  vpc_name   = "Default VPC"

  instances = [
    {
      name                = "instance-1"
      instance_type       = "t3.micro"
      create_sg           = true
      associate_public_ip = true
    },
    {
      name                = "instance-2"
      instance_type       = "t3.micro"
      create_sg           = false
    }
  ]
}
