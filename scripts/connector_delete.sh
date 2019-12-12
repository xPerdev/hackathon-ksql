curl -s "http://localhost:8083/connectors"| \
  jq '.[]'| \
  peco | \
  xargs -I{connector_name} curl -s -XDELETE "http://localhost:8083/connectors/"{connector_name}
  