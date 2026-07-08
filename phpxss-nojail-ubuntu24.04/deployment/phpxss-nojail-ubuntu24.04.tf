module "deployment-phpxss-nojail" {
  source = "./components/deployment/single_pod" 

  replicas = 1
  deployment_name = "phpxss-nojail"
  k8s_image = "${var.k8s_registry}/template/phpxss-nojail-ubuntu24.04"
  k8s_registry_secret_name = var.k8s_registry_secret_name
  pod_security_context = {
    run_as_user     = 0
    run_as_group    = 0
    allow_privilege_escalation = false
    read_only_root_filesystem = false 
    privileged = false
  }
}

module "ingress-phpxss-nojail" {
  source = "./components/ingress/web"  
  
  k8s_namespace = var.k8s_namespace
  web_domain = "phpxss-nojail.${var.web_domain}"
  service_name = module.service-phpxss-nojail.app_label
  k8s_tls_secret_name = var.k8s_tls_secret_name
  ingress_class = local.ingress
}

module "service-phpxss-nojail" {
  source = "./components/service/web"

  k8s_namespace = var.k8s_namespace
  app_label = module.deployment-phpxss-nojail.app_label
  container_port = 80
}
