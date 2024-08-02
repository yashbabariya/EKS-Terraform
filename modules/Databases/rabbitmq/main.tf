# Execute Helm command to add the bitnami repository & install rabbitmq.
resource "null_resource" "add_bitnami_repository" {
  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.region}
      helm repo add bitnami https://charts.bitnami.com/bitnami &&
      helm repo update &&
      helm install rabbitmq bitnami/rabbitmq --version ${var.chart_version} \
      --set auth.username=${var.username} \
      --set auth.password=${var.password} \
      --set persistence.size=${var.persistence_size} \
      --set persistence.storageClass=${var.storage_class} \
      --set communityPlugins=${var.communityplugins} \
      --set extraPlugins=${var.extraplugins}
    EOT
  }

  # Trigger the provisioner only once during creation
  triggers = {
    run_once = timestamp()
  }
}
