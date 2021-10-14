resource "aws_instance" "my_webserver" {
  ami                    = "ami-013a129d325529d4d"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webserver.id]
  user_data              = templatefile("user_data.sh.tpl",{
    f_name = Farid,
    l_name = Bakhishli,
    members = ["Babak","Gasham","Nihad","and others=)"]
  })

  tags = {
    Name  = "Web Server Build by Terraform"
    Owner = "Farid Bakhishli"
  }
}


resource "aws_security_group" "webserver" {
  name        = "WebServer SG"
  description = "Security Group for web server"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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