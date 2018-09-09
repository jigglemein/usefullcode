resource "aws_launch_configuration" "vibrato-lc" {
  name_prefix             = "${var.env}-webserver-lc"
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
  tag {
    key                 = "name"
    value               = "${var.env}-webserver"
    propagate_at_launch = true
  }
}

data "aws_availability_zones" "all" {}

resource "aws_elb" "vibrato-elb" {
  name = "${var.env}-webserver-elb"
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

data "aws_route53_zone" "primary" {
  name         = "jigglemein.com"
}

resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = "${var.env}.jigglemein.com"
  type    = "A"
  alias {
    name                   = "${aws_elb.vibrato-elb.dns_name}"
    zone_id                = "${aws_elb.vibrato-elb.zone_id}"
    evaluate_target_health = true
  }
}
