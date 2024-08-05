resource "local_file" "value_input" {
  content  = var.value
  filename = var.out_path
}