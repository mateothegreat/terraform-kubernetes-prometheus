#resource "kubernetes_persistent_volume_claim" "data" {
#
#    metadata {
#
#        namespace = var.namespace
#        name      = var.name
#
#    }
#
#    spec {
#
#        storage_class_name = "gp2"
#
#        access_modes = [ "ReadWriteOnce" ]
#
#        resources {
#
#            requests = {
#
#                storage = var.volume_size
#
#            }
#
#        }
#
#    }
#
#    wait_until_bound = false
#
#}
