resource "kubernetes_deployment" "prometheus" {

    wait_for_rollout = false

    metadata {

        name      = var.name
        namespace = var.namespace

        labels = {

            app = var.name

        }

    }

    spec {

        replicas = 1

        selector {

            match_labels = {

                app = var.name

            }

        }

        template {

            metadata {

                name = var.name

                labels = {

                    app = var.name

                }

            }

            spec {

                service_account_name = var.name
                #                node_selector                    = var.node_selector
                #                termination_grace_period_seconds = 15

                init_container {

                    name    = "permissions"
                    image   = "busybox"
                    command = [ "sh", "-c", "chown -R 65534:65534 /data" ]

                    volume_mount {

                        name       = "data"
                        mount_path = "/data"

                    }

                }

                container {

                    name = "prometheus"

                    image = var.image

                    args = [

                        "--config.file=/etc/prometheus/prometheus.yml",
                        "--storage.tsdb.path=/data",
                        "--web.enable-lifecycle",
                        "--web.enable-admin-api",
                        "--web.external-url=${ var.external_url }",
                        "--storage.tsdb.retention.time=${ var.retention_time }",
                        "--web.route-prefix=${ var.route_prefix }",
                        "--web.listen-address=${ var.listen_address}"

                    ]

                    security_context {

                        run_as_user  = 65534
                        run_as_group = 65534

                    }


                    resources {

                        requests = {

                            cpu    = var.request_cpu
                            memory = var.request_memory

                        }

                        limits = {

                            cpu    = var.limit_cpu
                            memory = var.request_memory

                        }

                    }

                    port {

                        container_port = 9090
                        protocol       = "TCP"

                    }

                    readiness_probe {

                        http_get {

                            path = "/"
                            port = 9090

                        }

                        initial_delay_seconds = 15
                        timeout_seconds       = 5

                    }

                    liveness_probe {

                        http_get {

                            path = "/"
                            port = 9090

                        }

                        initial_delay_seconds = 15
                        timeout_seconds       = 5

                    }

                    volume_mount {

                        name       = "data"
                        mount_path = "/data"

                    }

                    volume_mount {

                        name       = "global-config"
                        mount_path = "/etc/prometheus/prometheus.yml"
                        sub_path   = "prometheus.yml"
                        read_only  = true

                    }

                }

                volume {

                    name = "global-config"

                    config_map {

                        name = kubernetes_config_map.global-config.metadata.0.name

                        items {

                            key  = "prometheus.yaml"
                            path = "prometheus.yml"

                        }

                    }

                }

                volume {

                    name = "data"

                    empty_dir {}

                    #                    persistent_volume_claim {
                    #
                    #                        claim_name = kubernetes_persistent_volume_claim.data.metadata.0.name
                    #
                    #                    }

                    #                    aws_elastic_block_store {
                    #
                    #                        volume_id = aws_ebs_volume.data.id
                    #                        fs_type   = "ext4"
                    #
                    #                    }

                }

            }

        }

    }

}
