# Execute Helm command to add the bitnami repository & install postgresql.
resource "null_resource" "add_bitnami_repository" {
  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.region}
      helm repo add postgresql https://charts.bitnami.com/bitnami &&
      helm repo update
    EOT
  }

  # Trigger the provisioner only once during creation
  triggers = {
    run_once = timestamp()
  }
}

# Installing postgresql 
resource "helm_release" "Postgresql" {
  name       = "postgresql"
  namespace  = var.namespace
  repository = "postgresql"
  chart      = "postgresql"
  version    = var.chart_version

  set {
    name  = "auth.postgresPassword"
    value = var.postgresPassword
  }

  set {
    name  = "primary.persistence.size"
    value = var.persistence_size
  }

  set {
    name  = "primary.persistence.storageClass"
    value = var.storage_class
  }
}