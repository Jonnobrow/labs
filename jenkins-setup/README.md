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

Now take note of the two outputs:
- `get_jenkins_password` is a command that can be executed in order to output
  the default admin password required for initial setup of Jenkins.
- `public_url` is the URL required to access Jenkins.

## Setting up Jenkins

Navigate to the `public_url` from the previous step (e.g.
`http://xx.xx.xx.xx:8080`) and enter the password obtained from running the
`get_jenkins_password` command.

Choose the **Select Plugins to Install** option, then click **Suggested** to the
left of the search bar. Now scroll down adding the following plugin(s):
- **GitHub**: Required for better integration with GitHub

You can now press the button to continue to installation.

When creating your first admin user be sure to use secure credentials as this
guide makes Jenkins publicly available.

Now click "Save and Finish" followed by "Start using Jenkins" and you're done!

## Credentials and Tool Setup

### Adding the Credentials
1. Click on "Manage Jenkins" then "Manage Credentials"
2. Click on the "Jenkins" credential store
3. Select "Global Credentials (unrestricted)"
4. Click "Add Credentials"
5. For GitHub access (requires a GitHub personal access token if 2FA is enabled)
    1. Select "Username with password" under "Kind"
    2. Insert your GitHub username in the "Username" field
    3. Insert the access token in the "Password" field
    4. Leave the remaining fields blank and press "OK"
6. For GitHub API Access (requires a GitHub personal access token, with repo
   access and hooks access)
    1. Select "Secret Text" under "Kind"
    2. Insert the access token in the "Secret" field
    3. Leave the remaining fields blank and press "OK"
7. Return to the Dashboard

### GitHub Setup
1. Click on "Manage Jenkins" then "Configure System"
2. Scroll to the "GitHub" section then click "Add GitHub Server"
3. Under name enter "GitHub"
4. Under credentials select the Secret Text credential from the previous step
5. Make sure "Manage hooks" is checked, then apply and save the changes

### Maven Setup
1. Click on "Manage Jenkins" then "Global Tool Configuration"
2. Under "Maven" click on "Add Maven" and give it a name
3. Leave "Install automatically" checked then apply and save

## Creating a Pipeline

1. From the homepage click "Create a job"
2. Under name type a sensible name e.g. the repository being build
3. Select "Freestyle Project" and continue
4. Scroll to "Source Code Manage" and select "Git"
5. Enter the repository you want to build and select the username and password
   credentials from the dropdown
6. Under "Branches to build" select the branches you wish to build, this
   defaults to `*/master` which will build the master branch, however git now
   defaults to `main` so you would need to use `*/main` if your project uses
   `main`. 
7. Scroll to "Build Triggers" and check "GitHub hook trigger for GITScm polling"
8. Scroll to "Build" and "Add build step" of type "Execute shell"
9. Enter the following:
    ```
    ls -al
    echo "This is my first pipeline"
    ```
10. Apply and save, then press "Build Now" on the left
11. Select the build on the bottom left, then click "Console Output"
12. You should see that your repository was pulled and the contents listed. Then
    a message is printed out saying "This is my first pipeline"
13. Now add some changes to the repository and push them.
14. A second build should run, check the "Console Output" for the new commit
    message.

## Destroy the infrastructure

Leaving the resources up could be expensive, so it is best to destroy when you
are done. This can be done by running the following command:

```bash
terraform destroy -var-file variables.tfvars
```

## Additional Recommendations

- Replace the shell script with the commands to run a Docker build and Docker
  push.
    - **note**: to securely do the Docker push you will need to create another
      credentials with your Docker Hub login, then in the pipeline under "Build
      Environment" you will need to inject the credentials as environment
      variables for the build.
- Explore adding a post build step to update the commit status on GitHub
  (requires admin access to the repo)








