provider "google" {
  project = var.project_id
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_instance" "default" {
  count        = length(var.instances)
  name         = var.instances[count.index]
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = "sudo apt-add-repository ppa:ansible/ansible; sudo apt update; sudo apt install ansible"
}