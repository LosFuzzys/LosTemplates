module "deployment-sagemath-nojail-ubuntu" {
  source = "./components/deployment/single_pod"

  replicas = 1
  deployment_name = "sagemath-nojail-ubuntu"
  k8s_image = "${var.k8s_registry}/template/sagemath-nojail-ubuntu22.04"
  k8s_registry_secret_name = var.k8s_registry_secret_name
  pod_security_context = {
    run_as_user     = 0
    run_as_group    = 0
    read_only_root_filesystem = false 
    allow_privilege_escalation = false
    privileged = false
  }

  pod_resources = {
    limits = {
      cpu = "1"
      memory = "1Gi"
    }
    requests = {
      cpu = "0.1"
      memory = "128Mi"
    }
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
      value = 13386
    }
  ]
}

module "service-sagemath-nojail-ubuntu" {
  source = "./components/service/tcp"

  app_label = module.deployment-sagemath-nojail-ubuntu.app_label 
  public_ip = var.public_ip
  public_port = 13386
  container_port = 1337
}

module "egress-sagemath-nojail-ubuntu" {
  source = "./components/egress/block_all"

  deployment_name = module.deployment-sagemath-nojail-ubuntu.app_label
}
