resource "aws_instance" "ec2-terraform" {
  ami = "ami-0230bd60aa48260c6"
  instance_type = "t2.micro"
  tags = {
    Name = "EC2-TF"
  }
  user_data = <<EOF
    #!/bin/bash
    sudo apt update
    sudo apt install nginx -y
    systemctl enable nginx
    systemctl start nginx
  EOF
  key_name = aws_key_pair.ec2-tf.id
  vpc_security_group_ids = [aws_security_group.ssh-access.id]
}

resource "aws_key_pair" "ec2-tf" {
  public_key = file("./tf_ec2.pub")
}

resource "aws_security_group" "ssh-access" {
  name = "ssh-access"
  description = "SSH Access"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output publicip {
  value = aws_instance.ec2-terraform.public_ip
}
