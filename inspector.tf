resource "aws_inspector_resource_group" "this" {
  tags = {
    Inspector = "true"
  }
}

resource "aws_inspector_assessment_target" "this" {
  name               = "DevResourcesTarget"
  resource_group_arn = aws_inspector_resource_group.this.arn
}

resource "aws_inspector_assessment_template" "this" {
  name       = "DevResourcesTemplate" 
  target_arn = aws_inspector_assessment_target.this.arn
  duration   = 180

  rules_package_arns = [            
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-gEjTy7T7",
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-R01qwB5Q",
  ]
}


locals {
  user_data = <<-EOF
    #!/bin/bash
    wget https://inspector-agent.amazonaws.com/linux/latest/install
    curl -O https://inspector-agent.amazonaws.com/linux/latest/install
    sudo bash install
    EOF
}
resource "aws_instance" "this" {
  associate_public_ip_address = true
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  user_data = local.user_data
  tags = {
    Terraform   = "true"
    Environment = "dev"
    Inspector = "true"
  }
}
