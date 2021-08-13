# The config file was created in ondemand_to_spot.sh
export config_file=my.conf

# Set current dir to working dir - http://stackoverflow.com/a/10348989/277871
cd "$(dirname ${BASH_SOURCE[0]})"

. ../$config_file || exit -1

export request_id=`../ec2spotter-launch $config_file`
echo Spot request ID: $request_id

echo Waiting for spot request to be fulfilled...
aws ec2 wait spot-instance-request-fulfilled --spot-instance-request-ids $request_id  

export instance_id=`aws ec2 describe-spot-instance-requests --spot-instance-request-ids $request_id --query="SpotInstanceRequests[*].InstanceId" --output="text"`

echo Waiting for spot instance to start up...
aws ec2 wait instance-running --instance-ids $instance_id

echo Spot instance ID: $instance_id 

echo 'Please allow the root volume swap script a few minutes to finish.'
if [ "x$ec2spotter_elastic_ip" = "x" ]
then
	# Non elastic IP
	export ip=`aws ec2 describe-instances --instance-ids $instance_id --filter Name=instance-state-name,Values=running --query "Reservations[*].Instances[*].PublicIpAddress" --output=text`
else
	# Elastic IP
	export ip=`aws ec2 describe-addresses --allocation-ids $ec2spotter_elastic_ip --output text --query 'Addresses[0].PublicIp'`
fi	

echo 'Connect to your instance: ssh -i ~/.ssh/$ec2spotter_key_name.pem -o UserKnownHostsFile=/dev/null ubuntu@$ip'
echo 'Alternatively, use aliases: aws-ssh, aws-terminate, aws-state ...'

alias aws-ssh='ssh -i ~/.ssh/CUMC_WP_AWS_key.pem -o UserKnownHostsFile=/dev/null ubuntu@$ip'
alias aws-state='aws ec2 describe-instances --instance-ids $instance_id --query "Reservations[0].Instances[0].State.Name"'
alias aws-terminate='aws ec2 terminate-instances --instance-ids $instance_id; aws ec2 cancel-spot-instance-requests --spot-instance-request-ids $request_id'
