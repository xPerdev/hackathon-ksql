curl -s "http://localhost:8083/connectors"| \
  jq '.[]'| \
  xargs -I{connector_name} curl -s "http://localhost:8083/connectors/"{connector_name}"/status" | \
  jq -c -M '[.name,.connector.state,.tasks[].state]|join(":|:")' | \
  column -s : -t | \
  sed 's/\"//g' | \
  sort
