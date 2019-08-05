# terraform-aws

## Terraform Template includes serveral blocks

Here we are making an assumption that default VPC, default subnet and Key to SSH to instance have already been created

Under #helloworld.tf file
```
1. provider --> AWS provider with access_key, secret_access_key (must mention) and region are mentioned
2. data --> Not restricted to particular availability zones. Instances will be launched among us-east-1a/1b/1c/1d
3. resource 
   - AWS_INSTANCE 		--> t2.micro instance type with key (webapp.pem), security group IDs and centos AMI
   - AWS_SECURITY_GROUP --> Two inbound rules  
   								1. 22 for SSH to the instance
   								2. 9999 on which Hello World Rails application running
   - AWS_LAUNCH_CONFIGURATION --> Add application dependency package (for Hello World application )to be installed at the launch under user-data
   - AWS_AUTOSCALING_GROUP --> Minimum size of 2, Maximum size of 5
   - AWS_SECURITY_GROUP for ELB --> Inbound port 80 to be allowed, outbound traffic to 0.0.0.0/0 on all ports
   - AWS_ELB --> health check target should be 9999 (application running on 9999) and listener port mapping (lb_port:instance_port = 80:9999)
```
Steps to initialize the terraform 
```
terraform init
```
Plan the infrastructure before applying actual changes to check the syntax
```
terraform plan
```
Apply the changes
```
terraform apply
```
