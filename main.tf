data "http" "my_ip" {
  url = "https://ifconfig.me"
}

module "network" {
  source = "./modules/network"

  pj_name     = "training-tf"
  vpc_cidr    = "13.0.0.0/16"
  subnet_cidr = "13.0.0.0/24"
}

module "compute" {
  source = "./modules/compute"

  pj_name   = "training-tf"
  vpc_id    = module.network.vpc_id
  subnet_id = module.network.subnet_id
  security_group_ingress_rules = [
    {
      cidr      = "${data.http.my_ip.response_body}/32"
      from_port = "22"
      to_port   = "22"
    },
    {
      cidr      = "0.0.0.0/0"
      from_port = "80"
      to_port   = "80"
    }
  ]
}
