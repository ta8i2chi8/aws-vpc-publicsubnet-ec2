variable "pj_name" {
  type        = string
  description = "PJ名"
}

variable "vpc_id" {
  type        = string
  description = "VPCのID"
}

variable "subnet_id" {
  type        = string
  description = "サブネットのID"
}

variable "security_group_ingress_rules" {
  type = list(
    object({
      cidr      = string
      from_port = string
      to_port   = string
    })
  )
}
