variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ami" {
  description = "Amazon Linux 2 AMI ID"
  default     = "ami-0c55b159cbfafe1f0" # Replace with your region's AMI ID
}

variable "security_group_name" {
  description = "Security group name"
  default     = "web_server_sg"
}

variable "tag_name" {
  description = "Tag name for the instance"
  default     = "WebServer"
}
