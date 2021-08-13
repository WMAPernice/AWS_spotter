# AWS Persistant Spot Intance
Forked from https://github.com/atramos/ec2-spotter

EC2 spot instances behave much like regular instances, but are cheaper. 
Normally, they can only be inited from an AMI image, not EBS volume, resetting any changes made along the way.
This script enables you to continue with your Spot instance where you left off.

Refer to this medium post for information on how to set this up:
https://medium.com/slavv/learning-machine-learning-on-the-cheap-persistent-aws-spot-instances-668e7294b6d8

## Usage

```
$ ./ec2spotter-launch testing.conf
Launching instance type: m5.large
Spot request id: sir-defghijk
```

or

```
$ ./ec2spotter-launch testing.conf p3.2xlarge
Launching instance type: p3.2xlarge
Spot request id: sir-defghijk
```
