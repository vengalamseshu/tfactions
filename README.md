# terraform-aws-vpc
terraform standard vpc module

### This repository contains Terraform configuration templates to create an AWS VPC

The idea behind creating this repository is to have an up and running VPC setup that comprises of frequently used VPC Features, Standard Terraform Practices such as *having a proper directory structure, naming conventions, remote state, logical grouping of similar resources under same file, use of variables to make things configurable, displaying outputs, conditional feature implementation* etc.

---

VPC Features demonstrated at the time of writing:

- Public and Private Subnets  
- NAT Gateway  
- VPC Flow Logs
- Network Access Control List (NACL)
- VPC endpoints

You are more than welcome to add more feature implementations
  
---

***tfvars:***
A sample values.tfvars file has been created for reference, you can create another tfvars file and
pass your configuration through it.

```bash
    terraform init
    terraform plan -var-file values.tfvars
    terraform apply -var-file values.tfvars
```
---

***Example VPC Design:***

VPCs should be designed in such a way that it caters to the needs of our applications today and should be scalable to accommodate future needs.\
It is important to properly plan a VPC so that we do not encounter problems with Fault Tolerance, Scaling and Security.

Assume a CIDR Range of 10.7.0.0/16.\
It's critical to consider Availability Zones to ensure fault tolerance. So Let's split this VPC 
CIDR *evenly* in 4 Parts, One for each AZ - A, B and C. We keep the 4th part as spare, it helps a lot in the future for unforseen scenarios.

AZ - A:\
CIDR: 10.7.0.0/18. Now Lets break this into a Private and Public Subnet:\
That means 10.7.0.0/19 and 10.7.32.0/19. Around 8000 IP Addresses each.

AZ - B:\
CIDR: 10.7.64.0/18. Similarly we break this into a Private and Public Subnet:\
Now we have 10.7.64.0/19 and 10.7.96.0/19

AZ - C:\
CIDR: 10.7.128.0/18. On breaking this as well into Private and Public Subnet:\
We get 10.7.128.0/19 and 10.7.160.0/19

Note that we are still left with Spare CIDR of 10.7.192.0/18. This will come handy in future.

This strategy has been taken from a seasoned AWS Consultant Nathan McCourtney.\
https://aws.amazon.com/blogs/startups/practical-vpc-design/

---

***NAT Gateway:***

- enable_nat_gateway creates a NAT Gateway in each subnet
- single_nat_gateway creates one NAT Gateway only, usually in the first public subnet
- one_nat_gateway_per_az creates a NAT Gateway in each Availability Zone

Let's say you want to create a single NAT gateway then you will need to set enable_nat_gateway and single_nat_gateway to true

---

***VPC Flow Logs***:

Flow Logs you to capture information about the IP traffic going to and from network interfaces in your VPC.
You can publish Flow logs to:
- Amazon CloudWatch
- Amazon S3 

An example of CloudWatch has been given in values.tfvars file.
If you want to use an already existing CloudWatch log group then pass *flow_log_destination_arn* and *flow_log_cloudwatch_iam_role_arn*

If you want to use S3 for storing the logs then instead of cloudwatch parameters pass *flow_log_destination_type* as s3 and *flow_log_destination_arn* of an s3 bucket.

---

***Network Access Control List(NACL):***

NACLs function at the _subnet level_ of a VPC, each NACL can be applied to one or more subnets, but each subnet is required to be associated with one—and only one—NACL.

Please bear in mind that NACL are stateless, meaning any changes applied to an incoming rule isn’t automatically applied to an outgoing rule. 

Whereas Security Groups automatically do that, that means they are stateful.
For example, If you allow an incoming port 80, the outgoing port 80 will be automatically opened.
For NACL you will have to explicitly specify the outgoing ports.

---

***VPC Endpoints:***

A VPC endpoint enables you to privately connect your VPC to supported AWS services and VPC endpoint services powered by PrivateLink without requiring an internet gateway, NAT device, VPN connection, or AWS Direct Connect connection

There are 3 Type of Endpoint connections, namely *Interface, Gateway and GatewayLoadBalancer*.

***Interface Endpoint*** creates Endpoint Network Interfaces, at most one Interface Subnet can be present in an Availability Zone. You can attach Security group to it as well.

***Gateway Endpoint*** creates an entry in the Route Table of the subnets and the traffic to the service is routed through this gateway.\
No Subnet and Security Group Configuration is supported.\
At the time of writing, Amazon S3 and DynamoDB are supported by Gateway Endpoint.\
Note that Gateway endpoints do not enable AWS PrivateLink

***GatewayLoadBalancer Endpoint*** is deployed in a Subnet. Security groups are not supported.

How to configure VPC Endpoints:
- Set *create_vpc_endpoints* to true
- Specify the configuration in the endpoints.yaml, a sample configuration is given.
- Make sure you have unique names for each endpoint config in the endpoints.yaml
- If you need to attach a policy and security group to the Endpoint, you can configure 
  the Generic Endpoint IAM Policy and security group present in dependent.tf and
  set the *attach_generic_security_group* & *attach_generic_policy* to true.

If you want to create a VPC Endpoint and want to specifically pass the Subnet IDs to create the 
Interface or GatewayLoadBalancer endpoint in then:

In endpoints.tf, pass Subnet IDs as a list

```yaml
- name: s3-interface
  service: s3
  create: true
  service_type: Interface
  subnet_ids:
    - subnet-01234567890abcdef
    - subnet-98765432123abcdef
```

---

***Remote State and State Locking:***

For Remote State you need to have an already existing S3 Bucket and a DynamoDB Table. Pass those values in provider.tf file

---

***Opinion and Customisability:***

We want to follow an opinionated approach, things like Practical VPC Planning have been demonstrated in the README and values.tf vars file, tags containing *terraform = true* should ideally be there in any case so they have been added as defaults.

We want to keep things customisable - Say a user only wants specific features then they can pass values of only those variables. 
Other features should not get implemented.\
For this reason most of the variables created have been given a default value of either null,[] or {}
depending on the type of variable.

The idea behind this is that the module internally uses conditional statements with count and if the
value of the variable is null or empty then count becomes zero hence that particular feature does not
get implemented.\
In case you pass the value of that variable then count becomes one and that feature gets implemented.
