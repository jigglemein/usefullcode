data "aws_ami" "vibrato_ami" {
  most_recent      = true
  filter {
    name   = "name"
    values = ["vibrato website*"]
  }
}

