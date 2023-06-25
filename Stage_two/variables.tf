variable "docker_images" {
  description = "Images in my environment"
  type    = list(string)
  default = ["sgumbe/yolo-latest:1.1.0","sgumbe/yolo-latest:1.2.0"]
}

variable "instances" {
  description = "my Instances"
  type    = list(string)
  default = ["ansible-server2tf","ansible-client-1","ansible-client-2"]
}

variable "token" {
  type    = string
  default = ""
}

variable "project_id" {
  type    = string
  default = "week9-ansible"
}

