module "deployment-flask-instanced" {
  source = "./components/deployment/single_pod" 

  replicas = 1
  deployment_name = "flask-instanced"
  k8s_image = "${var.k8s_registry}/template/flask-instanced-alpine3.21"
  k8s_registry_secret_name = var.k8s_registry_secret_name
  pod_security_context = {
    run_as_user     = 1000
    run_as_group    = 1000
    allow_privilege_escalation = true
    read_only_root_filesystem = false
    privileged = true
  }

  pod_resources = {
    limits = {
      cpu = "0.3"
      memory = "512Mi"
    }
    requests = {
      cpu = "0.1"
      memory = "128Mi"
    }
  }

  environment = [
    {
      name = "DOMAIN",
      value = "flask-instanced.${var.web_domain}"
    },
    {
      name = "TIMEOUT"
      value = "600"
    },
    {
      name = "PUBPORTSTART"
      value = "10000"
    },
    {
      name = "PUBPORTEND",
      value = "19999"
    },
    {
      name = "REGISTRY",
      value = "${var.k8s_registry}/template"
    },
    {
      name = "NAME",
      value = "flask-instanced-alpine3.21"
    },
    {
      name = "DOMAIN_PROT",
      value = "https" 
    }
  ]
}

module "ingress-flask-instanced" {
  source = "./components/ingress/web"  
  
  k8s_namespace = var.k8s_namespace
  web_domain = "*.flask-instanced.${var.web_domain}"
  service_name = module.service-flask-instanced-web.app_label
  k8s_tls_secret_name = var.k8s_tls_secret_name
  ingress_class = local.ingress
}

module "service-flask-instanced-tcp" {
  source = "./components/service/tcp"

  k8s_namespace = var.k8s_namespace
  app_label = module.deployment-flask-instanced.app_label
  public_port = 13373
  container_port = 1337
  public_ip = var.public_ip
}

module "service-flask-instanced-web" {
  source = "./components/service/web"

  k8s_namespace = var.k8s_namespace
  app_label = module.deployment-flask-instanced.app_label
  container_port = 8080
}

module "egress-flask-instanced" {
  source = "./components/egress/block_all"

  deployment_name = module.deployment-flask-instanced.app_label
}
