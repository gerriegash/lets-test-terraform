#simply accessible from outside
resource "aws_lb_listener_rule" "four_o_four" {
  listener_arn = "${aws_lb_listener.http.arn}"
  priority = 50

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Url not found on server."
      status_code  = "404"
    }
  }

  condition {
    field = "path-pattern"
    values = [
      "/404-url"
    ]
  }
}

#should be accesible from vpn
resource "aws_lb_listener_rule" "behind_vpn" {
  listener_arn = "${aws_lb_listener.http.arn}"
  priority = 100

  action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.target.arn}"
  }

  condition {
    field = "path-pattern"
    values = [
      "dummy"
    ]
  }

  lifecycle {
    ignore_changes = [
      "condition"
    ]
  }
}

locals {
  vpn_cidr = "18.185.2.235/32"
  vpn_provisioner_command = "aws elbv2 modify-rule --rule-arn ${aws_lb_listener_rule.behind_vpn.arn} --conditions '[{\"Field\": \"source-ip\", \"SourceIpConfig\":{\"Values\":[\"${local.vpn_cidr}\"]}},{\"Field\": \"path-pattern\", \"Values\":[\"/close-url\"]}]'"
}

# This will always look for any change in the commands "provisioner_commands" and will fire when needed.
resource "null_resource" "add_vpn_cidr" {
  triggers = {
    commandChange = "${local.vpn_provisioner_command}"
  }

  provisioner "local-exec" {
    command = "${local.vpn_provisioner_command}"
  }
}

resource "aws_lb_listener_rule" "access_restricted" {
  listener_arn = "${aws_lb_listener.http.arn}"
  priority = 101

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Access is retricted."
      status_code  = "403"
    }
  }

  condition {
    field = "path-pattern"
    values = [
      "/close-url"
    ]
  }
}

# open url with a definite message
resource "aws_lb_listener_rule" "open" {
  listener_arn = "${aws_lb_listener.http.arn}"

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "I am open for new opportunities here."
      status_code  = "200"
    }
  }

  condition {
    field  = "path-pattern"
    values = ["/open-url"]
  }
}