Play Setup
The playbook is named "Install Docker on Debian 11 & start the containers."
The playbook is configured to run with escalated privileges using become: yes.
The playbook targets the hosts defined under the group "docker-instance" using the hosts parameter.
Variables
The playbook defines several variables in the vars section:

client_image: Specifies the Docker image for the client container.
backend_image: Specifies the Docker image for the backend container.
app_folder: Specifies the path to the application folder.
compose_file_src: Specifies the source path of the Docker Compose file.
compose_file_dest: Specifies the destination path of the Docker Compose file
Tasks
Update the cache: Uses the apt module to update the package cache and upgrade installed packages on the target system.

Install packages on Debian-based systems: Uses the apt module to install several required packages on Debian-based systems.

Add Docker official GPG key to the system: Uses the apt_key module to add the Docker official GPG key to the system.

Add Docker repository to the system: Uses the apt_repository module to add the Docker repository to the system's package sources.
Update the cache: Again, updates the package cache to include the Docker packages from the newly added repository.

Install Docker-related packages: Uses the apt module to install Docker-related packages, including Docker CE, Docker CLI, containerd.io, docker-buildx-plugin, docker-compose-plugin, and docker-compose.

Install the Docker module for Python: Uses the pip module to install the Docker module required by Ansible for interacting with Docker.
Pull the client image: Uses the community.docker.docker_image module to pull the specified client Docker image from the Docker registry.

Pull the backend image: Uses the community.docker.docker_image module to pull the specified backend Docker image from the Docker registry.

Create app folder: Uses the file module to create the specified application folder.

Create backend folder: Uses the file module to create a folder named "backend" inside the application folder.

Create app directory for client container: Uses the docker_container module to create and start a Docker container named "yolo-client." The container runs the specified client image and mounts the client app folder.

Create app directory for backend container: Uses the docker_container module to create and start a Docker container named "yolo-backend." The container runs the specified backend image and mounts the backend app folder.

Create client directories: Uses the file module to create additional directories within the client container's app folder.
Copy backend Dockerfile: Uses the copy module to copy the backend Dockerfile from a source location to the backend app folder.

Copy backend environment file: Uses the copy module to copy the backend environment file from a source location to the backend app folder.

Copy docker-compose file to target hosts: Uses the copy module to copy the Docker Compose file from the specified source path to the destination path on the target hosts.

Create client container: Uses the docker_container module to create and start the client container, specifying the client image, command, ports, and volume mounts.

Create backend container: Uses the docker_container module to create and start the backend container, specifying the backend image, command, ports, and volume mounts.

Print Docker container status: Uses the command module to execute the docker ps -a command and registers the output in the variable docker_output.

Verify backend container status: Uses the assert module to check if the backend container is running based on the output of the previous task. Fails the playbook if the container is not running.

Verify client container status: Uses the assert module to check if the client container is running based on the output of the previous task. Fails the playbook if the container is not running.







