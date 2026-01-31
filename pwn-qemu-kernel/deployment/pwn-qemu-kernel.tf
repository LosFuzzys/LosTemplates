# module "deployment-pwn-qemu-kernel" {
#   source = "./components/deployment/single_pod" 
#
#   replicas = 1
#   deployment_name = "pwn-qemu-kernel"
#   k8s_image = "${var.k8s_registry}/template/pwn-qemu-kernel"
#   k8s_registry_secret_name = var.k8s_registry_secret_name
#   pod_security_context = {
#     run_as_user     = 1000
#     run_as_group    = 1000
#     allow_privilege_escalation = true
#     read_only_root_filesystem = false
#     privileged = true
#   }
#
#   pod_resources = {
#     limits = {
#       cpu = "2"
#       memory = "2Gi"
#     }
#     requests = {
#       cpu = "0.1"
#       memory = "128Mi"
#     }
#   }
#
#   environment = [
#     {
#       name = "TIMEOUT"
#       value = "600"
#     },
#     {
#       name = "PUBPORTSTART"
#       value = "10000"
#     },
#     {
#       name = "PUBPORTEND",
#       value = "10999"
#     }
#   ]
# }
#
# module "service-pwn-qemu-kernel-tcp-ssh" {
#   # for_each = range(10000, 10999)
#   source = "./components/service/tcp"  
#   name = "pwn-qemu-kernel-services-tcp-ssh"
#   
#   k8s_namespace = var.k8s_namespace
#   app_label = module.deployment-pwn-qemu-kernel.app_label
#   public_port = each.value
#   container_port = each.value
#   public_ip = var.public_ip
# }
#
# module "service-pwn-qemu-kernel-tcp-spawner" {
#   source = "./components/service/tcp"
#   name = "pwn-qemu-kernel-services-tcp-spawner"
#
#   k8s_namespace = var.k8s_namespace
#   app_label = module.deployment-pwn-qemu-kernel.app_label
#   public_port = 13379
#   container_port = 1337
#   public_ip = var.public_ip
# }
#
# module "egress-pwn-qemu-kernel" {
#   source = "./components/egress/block_all"
#
#   deployment_name = module.deployment-pwn-qemu-kernel.app_label
# }
