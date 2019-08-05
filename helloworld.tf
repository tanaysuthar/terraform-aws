provider "aws" {
	access_key = "aws_access_key_id"
	secret_key = "aws_secret_access_key_id"
    region = "us-east-1"
}

data "aws_availability_zones" "all" {}

## CREATE EC2 Instances

resource "aws_instance" "helloworld" {
	 ami           			= "${lookup(var.amis,var.region)}"
	 count         			= "${var.count}"
	 key_name      			= "${var.key_name}"
	 vpc_security_group_ids	= ["${aws_security_group.instance.id}"]
     instance_type          = "t2.micro"


tags {
	Name = "${format("helloworld-%03d", count.index + 1)}"
  } 
}


## CREATE SECURITY GROUP FOR EC2

resource "aws_security_group" "instance" {
	name = "rails-hello-world-app"
	ingress {
			from_port  = 9999
			to_port    = 9999
			protocol   = "tcp"
			cidr_block = ["0.0.0.0/0"]
	}
	ingress {
			from_port  = 22
			to_port    = 22
			protocol   = "tcp"
			cidr_block = ["0.0.0.0/0"]
	}
}


## CREATE LAUNCH CONFIGURATION

resource "aws_launch_configuration" "helloworld" {
	image_id		=	"${lookup(var.amis, var.region)}"
	instance_type   =   "t2.micro"
	security_group  =   ["${aws_security_group.instance.id}"]
	key_name        =   "${var.key_name}"
	user_data    =  <<-EOF
					#!/bin/sh

					#Install Package dependencies 
					sudo yum install -y curl gpg gcc gcc-c++ make -y
					sudo yum install epel-release -y
					sudo yum install nodejs npm -y

					#Install RVM
					curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
					curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
					curl -L get.rvm.io | bash -s stable
					source /etc/profile.d/rvm.sh
					rvm reload

					#Install Ruby
					rvm install 2.6

					#Install Rails
					gem install rails

					cd hello_world

					nohup rails server -p 9999 --binding=0.0.0.0 &

					EOF

	lifecycle {
		create_before_destroy = true
	}
}


## CREATE AUTOSCALING GROUP

resource "aws_autoscaling_group" "helloworld" {
	launch_configuration  =  "${aws_launch_configuration.helloworld.id}"
	availability_zones    =  ["${data.aws_availability_zones.all.names}"]
	min_size              =   2
	max_size              =   5
	load_balancers        =  ["${aws_elb.helloworld.name}"]
	health_check_type     = "ELB"
	tag    {
		key   				= "Name"
		value 				= "helloworld-asg"
		propagate_at_launch = true
	}  
}


## SECURITY GROUP FOR ELB

resource "aws_security_group" "elb" {
	name = "helloworld-elb"
    egress {
        from_port = 0
    	to_port = 0
    	protocol = "-1"
    	cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
    	from_port = 80
    	to_port = 80
    	protocol = "tcp"
    	cidr_blocks = ["0.0.0.0/0"]
  	}
}


# CREATE ALB

resource "aws_elb" "helloworld" {
	name 				= "helloworld-elb"
	security_groups 	= ["${aws_security_group.elb.id}"]
	availability_zones  = ["${data.aws_availability_zones.all.names}"]
	health_check   {
		healthy_threshold 	= 2
		unhealthy_threshold = 2
		timeout				= 3
        interval            = 5
        target				= "HTTP:9999/"
	}
	listener {
		lb_port 		  = 80
		lb_protocol 	  = "http"
		instance_port 	  = "9999"
		instance_protocol = "http"
    }
}

