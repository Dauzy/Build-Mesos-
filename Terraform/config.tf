provider "aws" {
  access_key = ""
  secret_key = ""
  region     = ""
}

resource "aws_security_group" "mesos-sg" {
  name        = "mesos-sg"
  description = "Allow inbound traffic to mesos"

  ingress {
    from_port   = 0
    to_port     = 5050
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Allow tcp for mesos"
  }
}

resource "aws_security_group" "marathon-sg" {
  name        = "marathon-sg"
  description = "Allow inbound traffic to marathon"

  ingress {
    from_port   = 0
    to_port     = 8080
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Allow tcp for marathon"
  }
}

resource "aws_security_group" "ssh-sg" {
  name        = "ssh-sg"
  description = "Allow all ssh inbound ssh traffic"

  ingress {
    from_port   = 0
    to_port     = 22
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "internet-sg" {
  name        = "internet-sg"
  description = "Allow all connections outbound"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "zookeeper-sg" {
  name        = "zookeeper-sg"
  description = "Allow inbound traffic to zk"

  ingress {
    from_port   = 0
    to_port     = 2181
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Allow zk"
  }
}

resource "aws_instance" "Mesos-master" {
  ami           = "ami-759bc50a"
  instance_type = "t2.micro"
  key_name      = "Mesos-key"

  security_groups = [
    "${aws_security_group.marathon-sg.name}",
    "${aws_security_group.mesos-sg.name}",
    "${aws_security_group.zookeeper-sg.name}",
    "${aws_security_group.ssh-sg.name}",
    "${aws_security_group.internet-sg.name}",
  ]

  tags {
    Name = "Mesos-master"
  }
}

resource "aws_instance" "Mesos-slave" {
  ami           = "ami-759bc50a"
  instance_type = "t2.micro"
  key_name      = "Mesos-key"

  security_groups = [
    "${aws_security_group.ssh-sg.name}",
    "${aws_security_group.internet-sg.name}",
  ]

  tags {
    Name = "Mesos-slave"
  }
}
