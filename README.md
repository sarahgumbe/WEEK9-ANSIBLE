# WEEK9-ANSIBLE
Setting up an automated Ansible configuration playbook that automates configurations on a GCP server.
This Ansible playbook is designed to provision a Google Cloud Compute Engine instance, install Docker, and execute a Docker playbook on the remote instance. The playbook sets up a Debian 11 instance, configures firewall rules, copies the Docker playbook to the remote instance, and executes it using Ansible

Prerequisites
Before running the playbook, ensure you have the following:

Google Cloud project ID
SSH key pair for authentication
Path to the private key file
Docker playbook (docker-playbook.yaml) located at C:/Users/SGumbe/WEEK9-ANSIBLE/
Playbook Details
Playbook: main.tf
Provisioner: Terraform
Ansible Playbook: docker-playbook.yaml

Playbook Steps
Configure the Google Cloud provider with the project ID, region, and zone.
Create a firewall rule to allow SSH access to the instance.
Create a Google Compute Engine instance named "docker-instance" with the specified machine type, zone, and network.
Set the instance's boot disk image to "debian-cloud/debian-11".
Configure the instance's network interface and access configuration.
Add SSH key metadata to the instance for authentication.
Use the file provisioner to copy the Docker playbook from the local machine to the remote instance.
Use the remote-exec provisioner to execute commands on the remote instance, including updating the package cache, installing Ansible (if not already installed), creating the necessary directory, copying the Docker playbook to the appropriate location, and executing the Docker playbook using Ansible.
Use the null_resource with local-exec provisioner to copy the Docker playbook to the remote instance after the firewall rule is created.

Usage
Set the values for the following variables in the playbook:

var.project_id: Your Google Cloud project ID.
local.private_key_path: Path to your private key file.
Run the playbook using Terraform:

bash
Copy code
terraform init
terraform apply
This will provision the Google Cloud Compute Engine instance, configure firewall rules, copy the Docker playbook, and execute it on the remote instance.

Note: Make sure to replace the placeholders with your own values and ensure that the file paths mentioned in the playbook match the actual paths on your local machine.
