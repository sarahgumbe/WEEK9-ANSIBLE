locals {
  project_id       = var.project_id
  network          = "default"
  image            = "debian-cloud/debian-11"
  ssh_user         = "gumbe12"
  private_key_path = "C:/Users/SGumbe/.ssh/id_rsa"
}

provider "google" {
  project = var.project_id
  region  = "us-central1"
  zone    = "us-central1-f"
}

resource "google_compute_firewall" "ssh-firewall-rule" {
  project       = var.project_id
  name          = "docker-ssh"
  network       = "default"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["docker"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_instance" "docker-instance" {
  name         = "docker-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-f"
  tags         = ["docker"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral
    }
  }

  metadata = {
    ssh-keys = "gumbe12:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpF3ZANn4hezvz1osBIqk9AdvqStjTylh3OBDCmJl+CFBYT87oo8gyTLUH7imNzAAjELZJbhciNqnCO/LTBagHSUPcuh88XHLf8WKi0BNjI4bKuRC9ETMRxAa88nBULVy1OUqoDvvlxpiTVHTbXKj2u47+CgO5KhBE4yVdOWYF3dErOnRJkT/y3Qiby4mhE6m/OeSd3BmuJ1oGXzwsHgFZkaECvOEvJQ7NoZHcG2tiPdtd6DKotH4M2u1kO1lzZjYteJv6mOesegndrLwPD8zOl9ISgMabilD7c90OBWBr7ktTYY47CtFYvRAIDp6b/lI+IWIADfN9UbVy1/gzKf+PEU1lvbp/vlzo1FhvOXf2eBSRvn2L/83kHOGibdgyA5tcJEhKmcdybuipFizq2RO50YCkAjuJ/K5RHUSJUpSJWr0VUgJj9ENlREPDBxQUVdP/p4Pmk4OoSWYG7gl/oIl2JwUOpkJeFeu+FTZBhOMYYeSkyHjjBZsw2r09KmZ4GY8= gumbe12@gmail.com"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "gumbe12"  // Replace with your SSH username
      private_key = file(local.private_key_path)
      host        = google_compute_instance.docker-instance.network_interface[0].access_config[0].nat_ip
  }
    source      = "C:/Users/SGumbe/WEEK9-ANSIBLE/docker-playbook.yaml"
    destination =  "/tmp/ansible-playbook/docker-playbook.yaml"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "gumbe12"  // Replace with your SSH username
      private_key = file(local.private_key_path)
      host        = google_compute_instance.docker-instance.name
    }

    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y ansible",  // Install Ansible on the remote instance if not already installed
      "ansible localhost -m file -a 'path=/tmp/ansible state=directory'",  // Create the /tmp/ansible directory if it doesn't exist
      "scp -o StrictHostKeyChecking=no -i ${local.private_key_path} C:/Users/SGumbe/WEEK9-ANSIBLE/docker-playbook.yaml gumbe12@${google_compute_instance.docker-instance.network_interface[0].access_config[0].nat_ip}:/tmp/ansible-playbook/docker-playbook.yaml",
      "ansible-playbook /tmp/ansible/docker-playbook.yaml"  // Execute the playbook on the remote instance
    ]
  }
}

resource "null_resource" "copy-playbook" {
  depends_on = [google_compute_firewall.ssh-firewall-rule]

  provisioner "local-exec" {
    command = "scp -i C:/Users/SGumbe/.ssh/id_rsa C:/Users/SGumbe/WEEK9-ANSIBLE/docker-playbook.yaml gumbe12@${google_compute_instance.docker-instance.network_interface[0].access_config[0].nat_ip}:/tmp/ansible/docker-playbook.yaml"
  }
}
