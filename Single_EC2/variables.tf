variable "aws_region" {
    description = "The AWS region to deploy resources in"
    type=string
    default = "ap-south-1"
}

variable "instance_type" {
    description= "EC2 instance type"
type=string
default="t3.micro"
  
}
variable "key_name"{
    description = "Aws key pair name"
    type=string
}