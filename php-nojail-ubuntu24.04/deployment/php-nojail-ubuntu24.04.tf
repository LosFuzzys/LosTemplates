module "deployment-php-nojail" {
  source = "./components/deployment/single_pod" 

  replicas = 1
  deployment_name = "php-nojail"
  k8s_image = "${var.k8s_registry}/template/php-nojail-ubuntu24.04"
  k8s_registry_secret_name = var.k8s_registry_secret_name
  pod_security_context = {
    run_as_user     = 0
    run_as_group    = 0
    allow_privilege_escalation = false
    read_only_root_filesystem = false 
    privileged = false
  }
}

module "ingress-php-nojail" {
  source = "./components/ingress/web"  
  
  k8s_namespace = var.k8s_namespace
  web_domain = "php-nojail.${var.web_domain}"
  service_name = module.service-php-nojail.app_label
  k8s_tls_secret_name = var.k8s_tls_secret_name
  ingress_class = local.ingress
}

module "service-php-nojail" {
  source = "./components/service/web"

  k8s_namespace = var.k8s_namespace
  app_label = module.deployment-php-nojail.app_label
  container_port = 80
}

module "egress-php-nojail" {
  source = "./components/egress/block_all"

  deployment_name = module.deployment-php-nojail.app_label
}

