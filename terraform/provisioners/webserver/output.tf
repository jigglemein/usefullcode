output "elb_dns_name" {
  value = "${aws_elb.vibrato-elb.dns_name}"
}
