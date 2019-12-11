data "template_file" "ATMFraudDetection_bootstrap" {
  template = file("../utils/bootstrap_ubuntu_18_04.sh")

  vars = {
    atmfrauddetectiondemo = var.atmfrauddetectiondemo
    confluent_home_value  = var.confluent_home_value
  }
}