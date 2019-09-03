resource "aws_lb_target_group" "target" {
  name        = "${var.name}"
  port        = "${var.instance_port}"
  target_type = "instance"
  protocol    = "HTTP"
  vpc_id = "${aws_default_vpc.default.id}"

  deregistration_delay = "5"

  health_check {
    healthy_threshold   = "2"
    unhealthy_threshold = "5"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "${var.instance_port}"
    timeout             = "5"
  }

  lifecycle {
    create_before_destroy = true
  }

  stickiness {
    enabled = true
    type = "lb_cookie"
  }
}

resource "aws_lb_target_group_attachment" "target" {
  target_group_arn = "${aws_lb_target_group.target.arn}"
  target_id        = "${aws_instance.example.id}"
  port             = "${var.instance_port}"
}