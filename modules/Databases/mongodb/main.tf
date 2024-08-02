# Execute Helm command to add the bitnami repository & install mongodv.
resource "null_resource" "add_bitnami_repository" {
  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.region}
      helm repo add mongodb https://charts.bitnami.com/bitnami &&
      helm repo update
    EOT
  }

  # Trigger the provisioner only once during creation
  triggers = {
    run_once = timestamp()
  }
}

# Installing mongodb 
resource "helm_release" "mongodb" {
  name       = "mongodb"
  namespace  = var.namespace
  repository = "bitnami"
  chart      = "mongodb"
  version    = var.chart_version

  set {
    name = "auth.rootUser"
    value = var.rootuser_name
  }

  set {
    name  = "auth.postgresPassword"
    value = var.rootpassword
  }

  set {
    name = "architecture"
    value = var.architecture  
  }

  set {
    name = "replicaCount"
    value = var.replicacount
  }

  set {
    name = "externalAccess.service.type"
    value = var.service_type
  }

  set {
    name  = "persistence.size"
    value = var.persistence_size
  }

  set {
    name  = "persistence.storageClass"
    value = var.storage_class
  }

  set {
    name = "externalAccess.enabled"
    value = true
  }

  set {
    name = "externalAccess.autoDiscovery.enabled"
    value = true
  }

  set {
    name = "serviceAccount.create"
    value = true
  } 

  set {
    name = "automountServiceAccountToken"
    value = true
  }

  set {
    name = "rbac.create"
    value = true
  }

  set {
    name = "image.debug"
    value = true
  }
}