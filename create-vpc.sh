# create a vpc
aws ec2 create-vpc --cidr-block 10.10.0.0/16
# vpc id- vpc-0c0008335bb66cc83
aws ec2 create-subnet --cidr-block 10.10.1.0/24 --availability-zone ap-south-1a --vpc-id vpc-0c0008335bb66cc83
# subnet id= subnet-0e1a58cda294d74aa
aws ec2 create-security-group --description "vpc-shop" --group-name "shopizer-vpc" --vpc-id vpc-0c0008335bb66cc83
#security group id:sg-07c57cd07b43f5552
aws ec2 authorize-security-group-ingress --group-id sg-07c57cd07b43f5552 --protocol tcp --port 8080 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id sg-07c57cd07b43f5552 --protocol tcp --port 22 --cidr 183.83.73.244/32 

# igw creation and attach to vpc
aws ec2 create-internet-gateway
#igw id:igw-0fda5a2695e9e4eea
aws ec2 attach-internet-gateway --internet-gateway-id igw-0fda5a2695e9e4eea --vpc-id vpc-0c0008335bb66cc83
# create route table for subnet
# route table1
aws ec2 create-route-table --vpc-id vpc-0c0008335bb66cc83
# route table-id:rtb-058c2419ecd5d1d9d (created by us that is not main)
aws ec2 create-route --route-table-id rtb-058c2419ecd5d1d9d --gateway-id igw-0fda5a2695e9e4eea --destination-cidr-block 0.0.0.0/0
# attach subnets to route table igw as making all subnets as public
aws ec2 associate-route-table --route-table-id rtb-058c2419ecd5d1d9d --subnet-id subnet-0e1a58cda294d74aa
#association id:rtbassoc-010069f5c951b91aa

#create ec2 instance
aws ec2 run-instances --image-id ami-0a574895390037a62 --instance-type t2.small --key-name first_key --security-group-ids sg-07c57cd07b43f5552 --subnet-id subnet-0e1a58cda294d74aa --count 1 --associate-public-ip-address

aws ec2  create-image --instance-id i-08bf2a8abef5865cc --name my-shop
#ami id : ami-0fb2cc4fedc3989d3
aws ec2 terminate-instances --instance-ids i-08bf2a8abef5865cc
#creating ec2 instance using shopizer image
aws ec2 run-instances --image-id ami-0fb2cc4fedc3989d3 --instance-type t2.small --key-name first_key --security-group-ids sg-07c57cd07b43f5552 --subnet-id subnet-0e1a58cda294d74aa --count 1 --associate-public-ip-address

