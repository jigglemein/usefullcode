output "elb_dns_name" {
  value = "${aws_elb.jenkins-elb.dns_name}"
}
output "route53_dns_name" {
  value = "${aws_route53_record.www-jenkins.fqdn}"
}
