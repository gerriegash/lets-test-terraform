# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------


# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "aws_region" {
  description = "The AWS region to deploy into"
  default     = "us-west-2"
}

variable "instance_name" {
  description = "The Name tag to set for the EC2 Instance."
  default     = "terratest-example"
}

variable "instance_port" {
  description = "The port the EC2 Instance should listen on for HTTP requests."
  default     = 8080
}

variable "instance_text" {
  description = "The text the EC2 Instance should return when it gets an HTTP request."
  default     = "Hello, World!"
}

variable "vpn_cidr" {
  type = "list"
  default = ["18.185.2.235/32"]
}

variable "extra_cidr_with_admin_access" {
  type = "list"
  default = []
}

variable "account" {
  default = "something"
}

variable "name" {
  type = "string"
  default = "something"
}

variable "environment" {
  default = "novadev"
}

variable "main_realm" {
  default = "meisterwelt"
}