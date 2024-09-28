# Create VPC for Jenkins
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-vpc"
  cidr = var.vpc_cidr

  azs                     = data.aws_availability_zones.azs.names
  public_subnets          = var.public_subnets
  map_public_ip_on_launch = true
  enable_dns_hostnames    = true
  enable_dns_support      = true

  tags = {
    name        = "jenkins-vpc"
    Terraform   = "true"
    Environment = "dev"
  }

  public_subnet_tags = {
    Name = "jenkins-subnet"
  }
}

# Create Sg for Jenkins

module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jenkins-sg"
  description = "Security group for Jenkins Server"
  vpc_id      = module.vpc.vpc_id


  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    }

  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Name = "Jenkins-Sg"
  }
}

# Create Jenkins Server
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                   = "jenkins-instance"
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [module.sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  user_data              = file("bootstrap.sh")
  availability_zone      = data.aws_availability_zones.azs.names[0]
  root_block_device = [{
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }]


  tags = {
    Name        = "Jenkins-server"
    Terraform   = "true"
    Environment = "dev"
  }
}
