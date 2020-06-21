# Data durability and recovery

In this project you will create highly available solutions to common use cases.  You will build a Multi-AvailabilityZone, Multi-Region database and show how to use it in multiple geographically separate AWS regions.  You will also build a website hosting solution that is versioned so that any data destruction and accidents can be quickly and easily undone.

### Files included

- ./cloudformation/* - VPC CloudFormation templates/scripts
- ./logs/* - DB interaction outputs
- ./s3/* - S3 bucket static content
- ./screenshots/* - project screenshots
- ./estimates.txt - RTO/RPO estimates

## Getting Started

To get started, clone this repo.  Aside from instructions, it contains a CloudFormation script to build an AWS VPC with public and private subnets.  It also contains an example website that you will host in an AWS S3 bucket in your account.

## Project Instructions
### Cloud formation
In this project, you will use the AWS CloudFormation to create Virtual Private Clouds. CloudFormation is an AWS service that allows you to create "infrastructure as code". This allows you to define the infrastructure you'd like to create in code, just like you do with software. This has the benefits of being able to share your infrastructure in a common language, use source code control systems to version your infrastructure and allows for documenting and reviewing of infrastructure and infrastructure proposed changes.

CloudFormation allows you to use a configuration file written in a YAML file to automate the creation of AWS resources such as VPCs. In this project, you will use a pre-made CloudFormation template to get you started. This will allow you to create some of the infrastructure that you'll need without spending a lot of time learning details that are beyond the scope of this course.

In order to build a VPC from the YAML file, follow the steps:

1. Create primary VPC:

```sh
./cloudformation/run-primary-network.sh create
```

2. Create secondary VPC:

```sh
./cloudformation/run-secondary-network.sh create
```

3. Navigate to AWS Console
4. Wait for the stack to build out.  Refresh until status becomes “CREATE_COMPLETE”
5. Observe the “Outputs” tab for the created IDs.  These will be used later.

Once the CloudFormation Stack has completed, you can look at the "Resources" tab to see all of the AWS resources that the stack has created.  You can see both the type of resources that have been created, as well as the AWS identifiers for those resources so that you can locate these resources in the AWS service that they are a part of.

The "Outputs" tab shows you custom output from the CloudFormation Stack that is labeled and described for you.  These descriptions are custom descriptions that were added to the CloudFormation template and make it easier for you to find specific values that have been created as a part of the CloudFormation stack.  Here, you can find the VPC ID that has been created, the subnet IDs including which subnets are public and which are private, and the Security Groups that have been created and a description of each.

### Part 1

Complete the following steps:

### Data durability and recovery
In order to achieve the highest levels of durability and availability in AWS you must take advantage of multiple AWS regions. 
1. Pick two AWS regions.
2. Create one VPC in each region.

### Highly durable RDS Database

1. Create a new RDS Subnet group in the active and standby region.
2. Create a new MySQL, multi-AZ database in the active region. The database must:
     - Be a “burstable” instance class.
     - Have only the “UDARR-Database” security group.
     - Have an initial database called “udacity.”
3. Create a read replica database in the standby region. This database has the same requirements as the database in the active region. 

### Demonstrate normal usage

In the active region:
1. Create an EC2 keypair in the region
2. Launch an Amazon Linux EC2 instance in the active region. Configure the instance to use the VPC's public subnet and security group ("UDARR-Application"). 
3. SSH to the instance and connect to the "udacity" database in the RDS instance. 
4. Verify that you can create a table, insert data, and read data from the database. 

### Part 2
#### Failover And Recovery

In the standby region:

1. Create an EC2 keypair in the region
2. Launch an Amazon Linux EC2 instance in the standby region. Configure the instance to use the VPC's public subnet and security group ("UDARR-Application").
3. SSH to the instance and connect to the read replica database.
4. Verify if you are not able to insert data into the database but are able to read from the database.
5. Promote the read replica
6. Verify that if you are able to insert data into and read from the read replica database.

### Part 3
##### Website Resiliency

Build a resilient static web hosting solution in AWS. Create a versioned S3 bucket and configure it as a static website.

1. Enter “index.html” for both Index document and Error document
2. Upload the files from the GitHub repo (under `/project/s3/`)
3. Paste URL into a web browser to see your website. 

You will now “accidentally” change the contents of the website such that it is no longer serving the correct content

1. Change `index.html` to refer to a different “season”
2. Re-upload `index.html`
3. Refresh web page

You will now need to “recover” the website by rolling the content back to a previous version.

1. Recover the `index.html` object back to the original version
2. Refresh web page

You will now “accidentally” delete contents from the S3 bucket. Delete “winter.jpg”

You will now need to “recover” the object:

1. Recover the deleted object
2. Refresh web page


## License
MIT