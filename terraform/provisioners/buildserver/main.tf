resource "aws_launch_configuration" "jenkins-lc" {
  name_prefix             = "jenkins-lc"
  image_id                = "${data.aws_ami.jenkins.id}"
  instance_type           = "t2.micro"
  security_groups         = ["${aws_security_group.jenkins-security-group.id}"]
  key_name                = "jenkins-keypair"
  iam_instance_profile        = "${aws_iam_instance_profile.build_service_profile.id}"
  lifecycle {
    create_before_destroy = true
  }
  user_data = <<EOF
    #!/bin/bash
    /usr/local/bin/docker-compose -f /tmp/stack.yml up -d
    EOF
}

resource "aws_autoscaling_group" "jenkins-ag" {
  name = "jenkins-asg-${aws_launch_configuration.jenkins-lc.name}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  desired_capacity = 1
  max_size = 1
  min_size = 1
  load_balancers = ["${aws_elb.jenkins-elb.name}"]
  launch_configuration = "${aws_launch_configuration.jenkins-lc.id}"
  lifecycle {
      create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "jenkins-server"
    propagate_at_launch = true
  }
}

data "aws_availability_zones" "all" {}

resource "aws_elb" "jenkins-elb" {
  name = "jenkins-elb"
  security_groups = ["${aws_security_group.jenkins-elb.id}"]
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:8080/"
  }
  listener {
    lb_port = 8080
    lb_protocol = "http"
    instance_port = "8080"
    instance_protocol = "http"
  }
}

data "aws_route53_zone" "primary" {
  name         = "jigglemein.com"
}

resource "aws_route53_record" "www-jenkins" {
  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = "jenkins.jigglemein.com"
  type    = "A"
  alias {
    name                   = "${aws_elb.jenkins-elb.dns_name}"
    zone_id                = "${aws_elb.jenkins-elb.zone_id}"
    evaluate_target_health = true
  }
}
