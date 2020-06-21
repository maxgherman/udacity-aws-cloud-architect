provider "aws" {
  region  = "ap-southeast-2"
  profile = "default"
}

resource "aws_instance" "Udacity-T2" {
  ami           = "ami-088ff0e3bde7b3fdf" # Amazon Linux 2 AMI (HVM), SSD
  instance_type = "t2.micro"
  count         = 4
}

resource "aws_instance" "Udacity-M4" {
  ami           = "ami-088ff0e3bde7b3fdf" # Amazon Linux 2 AMI (HVM), SSD
  instance_type = "m4.large"
  count         = 2
}
