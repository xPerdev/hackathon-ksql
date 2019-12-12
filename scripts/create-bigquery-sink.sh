#/bin/bash

template=$PWD/config/orders_bigquery_sink.properties

if [ "$1" = "-d" ]
then
	URL=connectors/orders-sink-connector1
	METHOD=DELETE
	curl -i -X $METHOD \
	    -H "Accept:application/json" \
	    -H  "Content-Type:application/json" \
	    http://localhost:8083/$URL
else
if [ "$1" = "-v" ]
	then
		URL=connector-plugins/BigQuerySinkConnector/config/validate
		METHOD=PUT
		
eval "cat <<EOF
$(< ${template} )
EOF
" 2> /dev/null | curl -i -X $METHOD \
		    -H "Accept:application/json" \
		    -H  "Content-Type:application/json" \
		    http://localhost:8083/$URL --data-binary @-
	else
		URL=connectors/
		METHOD=POST
		
eval "cat <<EOF
$(< ${template} )
EOF
" 2> /dev/null | curl -i -X $METHOD \
		    -H "Accept:application/json" \
		    -H  "Content-Type:application/json" \
		    http://localhost:8083/$URL --data-binary @-
	fi
fi
	
