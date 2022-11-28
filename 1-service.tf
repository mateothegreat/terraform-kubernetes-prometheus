resource "kubernetes_service" "prometheus" {

    metadata {

        name      = var.name
        namespace = var.namespace

        labels = {

            app = var.name

        }

        annotations = {

            "service.beta.kubernetes.io/aws-load-balancer-type"     = "nlb"
            "service.beta.kubernetes.io/aws-load-balancer-internal" = "true"

        }

    }

    spec {

        type = var.service_type

        selector = {

            app = var.name

        }

        port {

            name        = "prom"
            port        = 9090
            target_port = 9090

        }

    }

}
