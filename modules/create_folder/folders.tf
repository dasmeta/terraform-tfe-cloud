resource "null_resource" "install" {
 provisioner "local-exec" {
    command = "pip install yamldirs"
  }
}

resource "null_resource" "folders" {
 provisioner "local-exec" {
    command = "/bin/bash create_folders/folders.sh"
  }
  depends_on = [
    null_resource.install
  ]
}
