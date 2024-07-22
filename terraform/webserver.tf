resource "aws_instance" "web_server" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]

  ## A key is not used in this situation because an Amazon Linux AMI is used
  ## Amazon Linux AMI supports Direct Connect and the key is managed by AWS backend services
  ## This helps remove the likelihood of poorly managed access keys (pem file) and access comes directly from authenticated AWS users

  tags = {
    Name = var.tag_name
  }

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp2"
    delete_on_termination = true
    encrypted             = true
  }

  ## Encryption at rest for local volume

  metadata_options {
    http_tokens               = "required"
    http_put_response_hop_limit = 2
  }

  ## Ensures IMDSv2 is used, as v1 is the default and enables non-authenticated traffic to instance
  ## Hop limit is set to 2 to accommodate container orchestration environments and helps prevent lateral movement across the internal network

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello, World!" > /var/www/html/index.html
              EOF
}
