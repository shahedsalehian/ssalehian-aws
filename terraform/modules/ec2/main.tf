
resource "aws_instance" "web" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"

  user_data = "${file("${path.module}/user-data/cloud-init.conf")}"

  associate_public_ip_address = true
  subnet_id = "${var.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.allow_traffic.id}"]

  tags = {
    Name = "ssalehian"
  }
}

resource "aws_security_group" "allow_traffic" {
  name = "allow_http_traffic"
  description = "Allow all HTTP/S Traffic and SSH"
  vpc_id = "${var.vpc_id}"

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}
