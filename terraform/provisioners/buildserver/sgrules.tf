resource "aws_security_group" "jenkins-security-group" {
  name = "jenkins-security-group"
  vpc_id      = "${var.vpc_id}"
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_elb_to_jenkins" {
  type            = "ingress"
  from_port       = 8080
  to_port         = 8080
  protocol        = "tcp"
  source_security_group_id = "${aws_security_group.jenkins-elb.id}"
  security_group_id = "${aws_security_group.jenkins-security-group.id}"
}

resource "aws_security_group" "jenkins-elb" {
  name = "elb-sc-jenkins"
  vpc_id      = "${var.vpc_id}"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
