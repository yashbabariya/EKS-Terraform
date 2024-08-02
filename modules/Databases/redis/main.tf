# Execute Helm command to add the bitnami repository & install redis.
resource "null_resource" "add_bitnami_repository" {
  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.region}
      helm repo add bitnami https://charts.bitnami.com/bitnami &&
      helm repo update
    EOT
  }

  # Trigger the provisioner only once during creation
  triggers = {
    run_once = timestamp()
  }
}

# Installing redis 
resource "helm_release" "redis" {
  name       = "redis"
  namespace  = var.namespace
  repository = "bitnami"
  chart      = "redis"
  version    = var.chart_version

  set {
    name = "auth.enabled"
    value = false
  }

  set {
    name = "master.persistence.enabled"
    value = true
  }

  set {
    name  = "master.persistence.size"
    value = var.master_persistence_size
  }

  set {
    name  = "global.storageClass"
    value = var.storage_class
  }

  set {
    name = "replica.persistence.enabled"
    value = true
  }

  set {
    name = "replica.persistence.size"
    value = var.replica_persistence_size
  }
}