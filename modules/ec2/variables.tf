variable "region" {
  description = "AWS Region"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC to use"
  type        = string
}


variable "instances" {
  description = "List of EC2 instances to create"
  type = list(object({
    name                = string
    instance_type       = string
    create_sg           = bool
    associate_public_ip = optional(bool, false)
  }))
}
