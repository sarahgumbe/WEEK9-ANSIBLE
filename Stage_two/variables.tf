variable "docker_images" {
  description = "Images in my environment"
  type    = list(string)
  default = ["sgumbe/yolo-latest:1.1.0","sgumbe/yolo-latest:1.2.0"]
}