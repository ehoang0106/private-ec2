#ec2 ami

variable "ami" {
  description = "Ubuntu 24.04 LTS AMI ID"
  type        = string
  default     = "ami-014e30c8a36252ae5"
}