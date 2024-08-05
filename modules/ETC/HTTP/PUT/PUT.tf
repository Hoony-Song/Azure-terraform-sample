resource "null_resource" "create_user" {
  provisioner "local-exec" {
    # environment = {
    #   USERNAME = var.username
    #   PASSWORD = var.password
    # }
    command = <<EOT
      AUTH=$(echo -n $var.admin_name:$var.admin_password | base64)
      curl -X PUT \
      -H "Content-Type: application/json" \
      -H "Authorization: Basic $AUTH" \
      -d @${path.module}/${var.jsonPath}
    EOT
  }
}