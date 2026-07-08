module "deployment-pwn-jail-debian12" {
  source = "./components/deployment/single_pod"

  replicas = 1
  deployment_name = "pwn-jail-debian12"
  k8s_image = "${var.k8s_registry}/template/pwn-jail-debian12.11"
  k8s_registry_secret_name = var.k8s_registry_secret_name
  pod_security_context = {
    run_as_user     = 0
    run_as_group    = 0
    read_only_root_filesystem = false 
    allow_privilege_escalation = true
    privileged = true
  }

  environment = [
    {
      name = "TIMEOUT"
      value = "30"
    },
    {
      name = "HOST"
      value = var.public_ip
    },
    {
      name = "PORT"
      value = 13387
    }
  ]
}

module "service-pwn-jail-debian12" {
  source = "./components/service/tcp"

  app_label = module.deployment-pwn-jail-debian12.app_label 
  public_ip = var.public_ip
  public_port = 13387
  container_port = 1337
}

module "egress-pwn-jail-debian12" {
  source = "./components/egress/block_all"

  deployment_name = module.deployment-pwn-jail-debian12.app_label
}
