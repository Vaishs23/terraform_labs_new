#  Provision Highly available Web Cluster in any region default VPC Create:
# Security Group for web server and ELB
#  Launch Configuration with Auto AMI Lookup
#  Auto Scaling Group using 2 availability zones
#  Classis load balanacer in 2 available zones

provider "aws" {
  region = "ca-central-1"
}

data "aws_availability_zones" "working" {}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["137112412989"]
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-x86_64"]
  }
}

resource "aws_security_group" "web" {
  name = "Web Security Group"
  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "Web Security Group"
    Owner = "Musa Ejaz"
  }
}

resource "aws_launch_configuration" "web" {
  name_prefix     = "WebServer-Highly-Available-LC-"
  image_id        = data.aws_ami.latest_amazon_linux.id
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.web.id]
  user_data       = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

//An ASG is a logical grouping of EC2 instances running the same configuration.
//ASGs allow for dynamic scaling and make it easier to manage a group of instances that host the same services.
resource "aws_autoscaling_group" "web" {
  name                 = "ASG-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  max_size             = 3
  min_size             = 3
  min_elb_capacity     = 3
  health_check_type    = "ELB"
  vpc_zone_identifier  = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  load_balancers       = [aws_elb.web.name]

  dynamic "tag" {
    for_each = {
      "Name"   = "Webserver in ASG"
      "Owner"  = "Musa Ejaz"
      "TAGKEY" = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "web" {
  name               = "Webserver-HighlyAvailable-ELB"
  availability_zones = [data.aws_availability_zones.working.names[0], data.aws_availability_zones.working.names[1]]
  security_groups    = [aws_security_group.web.id]
  listener {
    //load balance receives traffic on port 80 and sends signals to instances through port 80 as well
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }
  tags = {
    Name  = "Webserver-HighlyAvailable-ELB"
    Owner = "Musa Ejaz"
  }
}


resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.working.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.working.names[1]
}


output "web_loadbalancer_url" {
  value = aws_elb.web.dns_name
}


// with the DNS name you can create a domain name using route 53
