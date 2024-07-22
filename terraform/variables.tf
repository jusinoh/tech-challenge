variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ami" {
  description = "Amazon Linux 2 AMI ID"
  default     = "ami-0b72821e2f351e396" # Replace with your region's AMI ID
}

variable "security_group_name" {
  description = "Security group name"
  default     = "web_server_sg"
}

variable "tag_name" {
  description = "Tag name for the instance"
  default     = "WebServer"
}

variable "subnet_id" {
  description = "ID of the subnet where the instance will be deployed"
  default = "vpc-0f973f393187d8121"
  # default     = "subnet-xxxxxxx" # Replace with your subnet ID
}

variable "vpc_id" {
  description = "ID of the VPC"
  default= "subnet-0220a9bfd922dd49f"
  # default     = "vpc-xxxxxxx" # Replace with your VPC ID
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GB"
  default     = 8
}