resource "kubernetes_config_map" "global-config" {

    metadata {

        name      = "${ var.name }-global-config"
        namespace = var.namespace

    }

    data = {

        "prometheus.yaml" = yamlencode({

            global = {

                scrape_interval = var.scrape_interval
                scrape_timeout  = var.scrape_timeout

            }
            scrape_configs = local.merged_scrape_configs_set

        })

    }

}
