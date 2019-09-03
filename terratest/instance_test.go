package test

import (
	"crypto/tls"
	"fmt"
	"testing"
	"time"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// An example of how to test the Terraform module in examples/terraform-http-example using Terratest.
func TestTerraformHttpExample(t *testing.T) {
	t.Parallel()

	// A unique ID we can use to namespace resources so we don't clash with anything already in the AWS account or
	// tests running in parallel
	uniqueID := random.UniqueId()

	// Give this EC2 Instance and other resources in the Terraform code a name with a unique ID so it doesn't clash
	// with anything else in the AWS account.
	instanceName := fmt.Sprintf("terratest-http-example-%s", uniqueID)

	environment := "someenv"
	name := "somename"

	account:= "someaccount"

	// Specify the text the EC2 Instance will return when we make HTTP requests to it.
	instanceText := fmt.Sprintf("Hello, World!")

	vpnCidr := []string{"18.185.2.235/32"}

	extra_cidr_with_admin_access := []string{""}

	// Pick a random AWS region to test in. This helps ensure your code works in all regions.
	awsRegion := "us-west-2"

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../terraform/terraform-http-example",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"aws_region":    awsRegion,
			"instance_name": instanceName,
			"instance_text": instanceText,
			"environment": environment,
			"account": account,
			"name": name,
			"vpn_cidr": vpnCidr,
			"extra_cidr_with_admin_access": extra_cidr_with_admin_access,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	should_get_404_on_this_url := terraform.Output(t, terraformOptions, "should_get_404_text")
	should_get_access_restricted_text_url := terraform.Output(t, terraformOptions, "should_get_access_restricted_text")
	should_get_good_text_url := terraform.Output(t, terraformOptions, "should_get_open_text")
	should_get_hello_world_text_url := terraform.Output(t, terraformOptions, "should_get_hello_world_text")

	// Setup a TLS configuration to submit with the helper, a blank struct is acceptable
	tlsConfig := tls.Config{}

	// It can take a minute or so for the Instance to boot up, so retry a few times
	maxRetries := 30
	timeBetweenRetries := 5 * time.Second

	// Verify that we get back a 200 OK with the expected instanceText
	fmt.Println(should_get_404_on_this_url)
	fmt.Println(should_get_access_restricted_text_url)
	fmt.Println(should_get_good_text_url)
	http_helper.HttpGetWithRetry(t, should_get_good_text_url, &tlsConfig, 200, "I am open for new opportunities here.", maxRetries, timeBetweenRetries)
	http_helper.HttpGetWithRetry(t, should_get_404_on_this_url, &tlsConfig, 404, "Url not found on server.", maxRetries, timeBetweenRetries)
	http_helper.HttpGetWithRetry(t, should_get_hello_world_text_url, &tlsConfig, 200, instanceText, maxRetries, timeBetweenRetries)
	//http_helper.HttpGetWithRetry(t, should_get_access_restricted_text_url, &tlsConfig, 403, "Access is restricted.", maxRetries, timeBetweenRetries)
}
