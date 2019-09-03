resource "aws_lb" "load_balancer" {
  name = "${var.name}"

  subnets            = ["${aws_default_subnet.main_a.id}","${aws_default_subnet.main_b.id}"]

  security_groups = [
    "${aws_security_group.security_group.id}",
  ]

  idle_timeout = "300"
  internal     = false

  tags = {
    Name        = "${var.name}-${var.environment}"
    Account     = "${var.account}"
    Environment = "${var.environment}"
    Managed     = "terraform"
    Region      = "${var.aws_region}"
  }
}

resource "aws_default_vpc" "default" {
    tags = {
    Name = "Default VPC"
  }
}


resource "aws_default_subnet" "main_a" {
    availability_zone = "us-west-2a"
    tags = {
    Name = "Main"
  }
}

resource "aws_default_subnet" "main_b" {
    availability_zone = "us-west-2b"
    tags = {
    Name = "Main"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = "${aws_lb.load_balancer.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.target.arn}"
    type             = "forward"
  }
}

resource "aws_security_group" "security_group" {
  name        = "${var.name}"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "TCP"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "TCP"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  # Allow all egress rule
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}


