resource "aws_launch_configuration" "vibrato-lc" {
  name_prefix             = "vibrato-lc-"
  image_id                = "${data.aws_ami.vibrato_ami.id}"
  instance_type           = "t2.micro"
  security_groups         = ["${aws_security_group.ec2.id}"]
  key_name                = "terraform-keypair"
  lifecycle {
    create_before_destroy = true
  }
  user_data = <<EOF
    #!/bin/bash
    /usr/local/bin/docker-compose -f /tmp/stack.yml up -d
    EOF
}

resource "aws_autoscaling_group" "vibrato-ag" {
  name = "vibrato-asg-${aws_launch_configuration.vibrato-lc.name}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  desired_capacity = 1
  max_size = 1
  min_size = 1
  load_balancers = ["${aws_elb.vibrato-elb.name}"]
  launch_configuration = "${aws_launch_configuration.vibrato-lc.id}"
  lifecycle {
      create_before_destroy = true
  }
}

data "aws_availability_zones" "all" {}

resource "aws_elb" "vibrato-elb" {
  name = "vibrato-elb"
  security_groups = ["${aws_security_group.elb.id}"]
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }
}

