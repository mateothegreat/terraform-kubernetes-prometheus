locals {

    additional_scrape_configs_map = { for v in var.additional_scrape_configs : "${v.job_name}" => v }

    default_scrape_configs = [

        {

            job_name = "ingress-controller"

            kubernetes_sd_configs = [

                {

                    role       = "endpoints"
                    namespaces = {

                        names = [ "default" ]

                    }

                },

            ]

            relabel_configs = [

                {

                    action        = "keep"
                    regex         = "ingress-controller-metrics"
                    replacement   = "$1"
                    source_labels = [ "__meta_kubernetes_service_name" ]

                },
                {

                    action        = "keep"
                    regex         = "10254"
                    replacement   = "$1"
                    source_labels = [ "__meta_kubernetes_pod_container_port_number" ]

                }

            ]

        },
        {

            job_name              = "rabbitmq"
            kubernetes_sd_configs = [

                {

                    role       = "endpoints"
                    namespaces = {

                        names = [ "default" ]

                    }

                },

            ]

            relabel_configs = [

                {

                    action        = "keep"
                    regex         = "rabbitmq"
                    replacement   = "$1"
                    source_labels = [ "__meta_kubernetes_service_name" ]

                },
                {

                    action        = "keep"
                    regex         = "prometheus"
                    replacement   = "$1"
                    source_labels = [ "__meta_kubernetes_endpoint_port_name" ]

                },

            ]

        },
        {

            job_name              = "node-exporter"
            kubernetes_sd_configs = [

                {

                    role       = "endpoints"
                    namespaces = {

                        names = [ "monitoring" ]

                    }

                }

            ]

            relabel_configs = [

                {

                    action        = "keep"
                    regex         = "node-exporter"
                    replacement   = "$1"
                    source_labels = [ "__meta_kubernetes_service_name" ]

                },
                {

                    action        = "keep"
                    regex         = "node-exporter"
                    replacement   = "$1"
                    source_labels = [ "__meta_kubernetes_endpoints_name" ]

                },

            ]

        },
        {

            job_name = "kube-state-metrics"

            static_configs = [

                {

                    targets = [ "kube-state-metrics.kube-system.svc.cluster.local:8080" ]

                }

            ]

        },
        {

            job_name     = "cadvisor"
            metrics_path = "/metrics/cadvisor"
            scheme       = "https"

            tls_config = {

                ca_file              = "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
                insecure_skip_verify = true

            }

            authorization = {

                credentials_file = "/var/run/secrets/kubernetes.io/serviceaccount/token"
                type             = "Bearer"

            }

            kubernetes_sd_configs = [
                {

                    role = "node"

                }
            ]

            relabel_configs = [

                {

                    action      = "labelmap"
                    regex       = "__meta_kubernetes_node_label_(.+)"
                    replacement = "$1"
                    separator   = ";"

                },
                {

                    action       = "replace"
                    regex        = "(.*)"
                    replacement  = "kubernetes.default.svc:443"
                    separator    = ";"
                    target_label = "__address__"

                },
                {

                    action        = "replace"
                    regex         = "(.+)"
                    replacement   = "/api/v1/nodes/$${1}/proxy/metrics/cadvisor"
                    separator     = ";"
                    source_labels = [ "__meta_kubernetes_node_name" ]
                    target_label  = "__metrics_path__"

                }

            ]

            metric_relabel_configs = [

                {

                    action        = "keep"
                    regex         = "(container|machine)_(cpu|memory|network|fs)_(.+)"
                    replacement   = "$1"
                    separator     = ";"
                    source_labels = [ "__name__" ]

                },
                {

                    action        = "drop"
                    regex         = "container_memory_failures_total"
                    replacement   = "$1"
                    separator     = ";"
                    source_labels = [ "__name__" ]

                }

            ]

        }

    ]

    default_scrape_configs_map = { for v in local.default_scrape_configs : "${v.job_name}" => v }

    merged_scrape_configs_map = merge(local.default_scrape_configs_map, local.additional_scrape_configs_map)

    merged_scrape_configs_set = values(local.merged_scrape_configs_map)

}
