data "aws_ami" "jenkins" {
  most_recent      = true
  filter {
    name   = "name"
    values = ["jenkins*"]
  }
}

