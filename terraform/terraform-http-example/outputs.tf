output "instance_id" {
  value = "${aws_instance.example.id}"
}

output "public_ip" {
  value = "${aws_instance.example.public_ip}"
}

output "instance_url" {
  value = "http://${aws_instance.example.public_ip}:${var.instance_port}"
}

output "should_get_404_text" {
  value = "http://${aws_lb.load_balancer.dns_name}/404-url"
}

output "should_get_open_text" {
  # value = "http://${aws_route53_record.instance.name}.nova.infinitec.solutions/open-to-news"
  value = "http://${aws_lb.load_balancer.dns_name}/open-url"
}

output "should_get_hello_world_text" {
  value = "http://${aws_lb.load_balancer.dns_name}"
}

output "should_get_access_restricted_text" {
  value = "http://${aws_lb.load_balancer.dns_name}/close-url"
}