variable "count" {
	default = 1
}


variable "region" {
	description = "AWS region for infrastructure"
	default = "us-east-1"
}

variable "key_name" {
	description = "Key_name for SSHing into EC2"
	default = "webapp.pem"
}

variable "amis" {
	description = "Base AMI to launch the instance"
	default = {
			us-east-1 = "ami-0080e4c5bc078760e"
	}
}
