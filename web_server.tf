resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_webserver.id
  tags = {
    "Name" = "Web Server IP"
  }
}

data "aws_ami" "latest_amazon_linux" {
	owners      = ["amazon"]
	most_recent = true
	filter {
	name   = "name"
	value  = ["amzn2-ami-hvm-*-x86_64-gp2"]
	}
}

resource "aws_instance" "my_webserver" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webserver.id]
  user_data              = templatefile("user_data.sh.tpl",{
    f_name = "Farid",
    l_name = "Bakhishli",
    members = ["Rick","Morty","Summer"]
  })

  tags = {
    Name  = "Web Server Build by Terraform"
    Owner = "Farid Bakhishli"
  }

  depends_on = [
    aws_instance.my_db_server
  ]

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_instance" "my_db_server" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webserver.id]

  tags = {
    Name  = "Web Server Build by Terraform"
    Owner = "Farid Bakhishli"
  }
  
}

resource "aws_security_group" "webserver" {
  name        = "WebServer SG"
  description = "Security Group for web server"

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
    Name  = "Web Server"
    Owner = "Farid Bakhishli"
  }
}

