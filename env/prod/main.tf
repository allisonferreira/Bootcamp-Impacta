module "prod" {
  source = "../../infraestrutura"

  nome_repositorio = "bootcampimpacta"
  cargoIAM         = "bootcampimpacta"
  ambiente         = "bootcampimpacta"
}

output "IP_alb" {
  value = module.prod.IP
}