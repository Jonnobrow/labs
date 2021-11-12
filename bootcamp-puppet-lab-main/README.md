# Puppet

## Terraform
- Generate two keys:
    ```bash
    ssh-keygen -ted25519 -f master_key
    ssh-keygen -ted25519 -f agent_key
    ```
- Export AWS credentials (not necessary if you have used `aws configure`)
    ```bash
    # These are not real credentials
    export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
    export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
    ```
- Run `terraform apply`
- Go to the AWS console and grab the Public IP of the agent and master

## Master Setup
- Copy script and connect to the master node:
    ```bash
    export MASTERIP=11.22.33.44 # Replace with your master IP
    scp -i master_key ./puppet-install-master.sh ubuntu@$MASTERIP
    ssh -i master_key ubuntu@$MASTERIP
    ```
- Set environment variable:
    ```bash
    export PUPPET_PASS="your_super_secret_password"
    ```
- Run the script (when prompted, press enter):
    ```bash
    chmod +x puppet-install-master.sh
    sudo ./puppet-install-master.sh
    ```

## Agent Setup
- Copy script and connect to the agent node:
    ```bash
    export AGENTIP=11.22.33.44 # Replace with your agent IP
    scp -i agent_key ./puppet-install-agent.sh ubuntu@$AGENTIP
    ssh -i agent_key ubuntu@$AGENTIP
    ```
- Set environment variables:
    ```bash
    export PUPPET_MASTER_PUBLIC_IP=11.22.33.44 # Replace with your public master IP
    export PUPPET_MASTER_PRIVATE_IP=44.33.22.11 # Replace with your private master IP
    export PUPPET_AGENT_HOSTNAME=somecleverhostname # webserver1 for example
    ```
- Run the script (follow instruction and press enter when prompted):
    ```bash
    chmod +x puppet-install-agent.sh
    sudo ./puppet-install-agent.sh
    ```


