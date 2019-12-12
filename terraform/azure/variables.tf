variable "azure_tenant_id" {
    type = string
    description = "Azure tenant id for azure account"
}

variable "azure_subscription_id" {
    type = string
    description = "Azure subscription id in azure account to be used"
}

variable "location" {}

variable "admin_username" {
    type = string
    description = "Administrator user name for virtual machine"
}

variable "admin_password" {
    type = string
    description = "Password must meet Azure complexity requirements"
}

variable "prefix" {
    type = string
    default = "hax"
}

variable "tags" {
    type = map

    default = {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
        Environment = "<ENVIRIONMENT>"
        Owner       = "<EMAIL>"
  }
}

variable "sku" {
    default = {
        westeurope = "18.04-LTS"

    }
}

variable "atmfrauddetectiondemo" {
  default = "https://github.com/xPerdev/hackathon-ksql/archive/master.zip"
}

variable "cp_all_in_one_cloud_repo" {
  default = "https://github.com/confluentinc/examples/archive/master.zip"
}

variable "confluent_home_value" {
  default = "/home/confluent/opt"
}

variable "instance_count" {
  type = map(string)
  default = {
    vms = 1
    lbs = 0
  }
}

variable "ccloud_bootstrap_server" {
  type = string
  description = "Bootstrap server URL for the Confluent Cloud Kafka Cluster"
}

variable "ccloud_api_key" {
  type = string
  description = "API Key for the principal to connect to the Confluent Cloud Kafka Cluster"
}

variable "ccloud_api_secret" {
  type = string
  description = "Secret for the principal to connect to the Confluent Cloud Kafka Cluster"
}

variable "ccloud_schema_registry_url" {
  type = string
  description = "URL to connect to the Confluent Cloud managed Schema Registry"  
}

variable "ccloud_schema_registry_api_key" {
  type = string
  description = "API Key for the principal to connect to the Confluent Cloud managed Schema Registry"
}

variable "ccloud_schema_registry_secret" {
  type = string
  description = "API Key for the principal to connect to the Confluent Cloud managed Schema Registry"
}