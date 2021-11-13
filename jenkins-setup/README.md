# Jenkins Setup

## Generate a Key Pair
An AWS key pair is needed to SSH into the instance after creation which could be
useful for adding additional build tools or diagnosing problems.

You can generate an [ED25519 Key](https://docs.gitlab.com/ee/ssh/index.html#ed25519-ssh-keys) with the name `jenkins-tf-key` by running the following command:
```bash
ssh-keygen -ted25519 -fjenkins-tf-key
```

## Running the Terraform Deployment

The Terraform files will create the following:
- A security group with port 22 and 8080 open
- An AWS Key with the public part from the `jenkins-tf-key`
- An AWS instance with the following properties:
    - Instance Type: `t3.large` (default can be overriden)
    - AMI: Latest `amzn2` AMI in your region
    - Root Volume Size: 50GB (default can be overriden)
    - Name: "Jenkins Build Server (tf)"
    - User Data: The script [user-data.sh](./user-data.sh) which installs Java,
      Maven, Jenkins and Docker 
- An Elastic IP address which is associated with the instance

Before running the deployment, create a `.tfvars` file with the following
required variables:
```terraform
aws_access_key = "EXAMPLEEXAMPLEEXAMPLE"
aws_secret_key = "ex4MPLE3x4AMPLEex4MPLE3x4AMPLEex4MPLE3x4AMPLE"
```
and optionally (values should be changed):
```terraform
aws_region = "eu-west-2"
ec2_instance_type = "t2.micro"
jenkins_volume_size = 20
```

No you can generate a plan and apply that plan:
```bash
terraform plan -var-file variables.tfvars -out main.plan
# Then after verifying the plan is okay
terraform apply main.plan
```







