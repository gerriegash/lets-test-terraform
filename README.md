# Let's test terraform

This project intends to test the terrafrom code by executing one module of terraform at a time. 
This basically creates the actual resources on AWS as per the terraform modules and then tests the expected output as specified in `go` tests being run.

## Folder Structure

The folder [terraform/terraform-http-example](/terraform/terraform-http-example) contains a simple Terraform module that deploys resources in [AWS](https://aws.amazon.com/) to demonstrate
how you can use Terratest to write automated tests for your AWS Terraform code. This module deploys an [EC2
Instance](https://aws.amazon.com/ec2/) in the AWS region specified in the `aws_region` variable. The EC2 Instance runs
a simple web server that listens for HTTP requests on the port specified by the `instance_port` variable and returns
the text specified by the `instance_text` variable. This ec2 instance is put behind a load balancer which listens on port 80 and can respond to various urls like /open-url,/close-url,/404. 

Check out [terratest/instance_test.go](/terratest/instance_test.go) to see how you can write
automated tests for this module.

**WARNING**: This module and the automated tests for it deploy real resources into your AWS account which can cost you
money. The resources are all part of the [AWS Free Tier](https://aws.amazon.com/free/), so if you haven't used that up,
it should be free, but you are completely responsible for all AWS charges.

## Running this module manually

1. Sign up for [AWS](https://aws.amazon.com/).
2. Configure your AWS credentials using one of the [supported methods for AWS CLI
   tools](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html), such as setting the
   `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables. If you're using the `~/.aws/config` file for profiles then export `AWS_SDK_LOAD_CONFIG` as "True".
3. Install [Terraform](https://www.terraform.io/) and make sure it's on your `PATH`.
4. Run `terraform init`.
5. Run `terraform apply`.
6. The various output urls would be exposed after running of terraform apply on your console, use those to test the changes.
7. When you're done, run `terraform destroy`.


## Running automated tests against this module

1. Sign up for [AWS](https://aws.amazon.com/).
2. Configure your AWS credentials using one of the [supported methods for AWS CLI
   tools](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html), such as setting the
   `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables. If you're using the `~/.aws/config` file for profiles then export `AWS_SDK_LOAD_CONFIG` as "True".
3. Install [Terraform](https://www.terraform.io/) and make sure it's on your `PATH`.
4. Install [Golang](https://golang.org/) and make sure this code is checked out into your `GOPATH`.
5. `cd terratest`
6. `dep ensure`
7. `go test -v`
