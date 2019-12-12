data "template_file" "ATMFraudDetection_bootstrap" {
  template = file("../utils/bootstrap_ubuntu_18_04.sh")

  vars = {
    atmfrauddetectiondemo = var.atmfrauddetectiondemo
    cp_all_in_one_cloud_repo = var.cp_all_in_one_cloud_repo
    confluent_home_value  = var.confluent_home_value
    ccloud_broker_endpoint = var.ccloud_bootstrap_server
    ccloud_api_key = var.ccloud_api_key
    ccloud_api_secret = var.ccloud_api_secret
    ccloud_sr_endpoint = var.ccloud_schema_registry_url
    ccloud_sr_api_key = var.ccloud_schema_registry_api_key
    ccloud_sr_api_secret = var.ccloud_schema_registry_secret
  }
}