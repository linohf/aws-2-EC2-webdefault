resource "aws_security_group" "example" {
  name_prefix = "example-sg"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami           = "ami-02396cdd13e9a1257"  #Amazon Linux 2023 AMI 2023.0.2
  instance_type = "t2.micro"  # Cambia al tipo de instancia que prefieras
  key_name      = "lino-key"  # o crear uno nuevo: aws_key_pair.example.key_name
  security_groups = [aws_security_group.example.name]

user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install httpd -y
              sudo systemctl enable httpd
              sudo systemctl start httpd
              echo '<h1>Welcome to my website! LinoHF</h1>' | sudo tee /var/www/html/index.html
              EOF

 tags = {
    Name = "tf-lino-ec2-web"
  }
}


output "public_ip" {
  value = aws_instance.example.public_ip
}