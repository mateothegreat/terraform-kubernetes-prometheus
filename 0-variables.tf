variable "name" {

    type        = string
    default     = "prometheus"
    description = "Name of the resources created."

}

variable "namespace" {

    type        = string
    default     = "default"
    description = "Namespace of the resources created."

}

variable "image" {

    type        = string
    description = "https://github.com/prometheus/prometheus/releases"
    default     = "quay.io/prometheus/prometheus:v2.31.1"

}

variable "node_selector" {

    type        = map(string)
    default     = null
    description = "Node selector for the deploymemnt (optional)."

}

variable "request_cpu" {

    type        = string
    description = "resource request for cpu"
    default     = "200m"

}

variable "request_memory" {

    type        = string
    description = "resource request for memory"
    default     = "200Mi"

}

variable "limit_cpu" {

    type        = string
    description = "resource limit for cpu"
    default     = "200m"

}

variable "limit_memory" {

    type        = string
    description = "resource limit for memory"
    default     = "200Mi"

}

variable "service_type" {

    type        = string
    default     = "LoadBalancer"
    description = "type of service for the load balancer (LoadBalancer or NodePort)"

}

variable "service_loadbalancer_internal" {

    type        = bool
    default     = true
    description = "whether or not to make this an internal only load balancer or public"

}


variable "retention_time" {

    type        = string
    description = "retention period (i.e.: 6h)"
    default     = "24h"

}

variable "block_duration" {

    type        = string
    description = "block duration period (i.e.: 6h)"
    default     = "15m"

}

variable "external_url" {

    type        = string
    description = "external url for the prometheus server"
    default     = "15m"

}

variable "route_prefix" {

    type        = string
    description = "route prefix for the prometheus server"
    default     = "/"

}

variable "volume_size" {

    type        = string
    description = "volume size for the prometheus server"
    default     = 10

}

variable "listen_address" {

    type        = string
    description = "listen address for the prometheus server"
    default     = "0.0.0.0:9090"

}

variable "scrape_interval" {

    type        = string
    description = "scrape interval for the prometheus server"
    default     = "15s"

}

variable "scrape_timeout" {

    type        = string
    description = "scrape timeout for the prometheus server"
    default     = "10s"

}

variable "additional_scrape_configs" {

    description = "additional scrape configs (see: https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config)"
    default     = [ ]

}
