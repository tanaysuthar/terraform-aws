output "instance_ids" {
	value = ["${aws_instance.helloworld.*.public_ip}"]
}

output "elb_dns_name" {
	value = "${aws_elb.helloworld.dns_name}"
}
