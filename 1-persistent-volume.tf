#resource "kubernetes_persistent_volume" "data" {
#
#    metadata {
#
#        name = var.name
#
#    }
#
#    spec {
#
#        access_modes = [ "ReadWriteOnce" ]
#
#        capacity = {
#
#            storage = var.volume_size
#
#        }
#
#        persistent_volume_source {
#
#            aws_elastic_block_store {
#
#                volume_id = aws_ebs_volume.data.id
#
#            }
#
#        }
#
#    }
#
#}
