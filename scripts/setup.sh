#!/bin/sh

confluent-hub install --component-dir ./connect-plugins/ --no-prompt jcustenborder/kafka-connect-spooldir:1.0.41
confluent-hub install --component-dir ./connect-plugins/ --no-prompt wepay/kafka-connect-bigquery:1.3.0
