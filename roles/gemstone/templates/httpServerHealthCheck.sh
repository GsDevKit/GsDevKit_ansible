#!/bin/bash
SERVICE_TO_MONITOR={{daemontools_service_dir}}/gs_{{item.name}}-{{item.port}}
sleep 30
curl -R -O http://127.0.0.1/f{{item.port}}
RESULT=`awk 'NR=1{print $1}' f{{item.port}}`
if [ "$RESULT" != "/f{{item.port}}" ] ; then
  svc -t $SERVICE_TO_MONITOR
  echo `date` "-" $SERVICE_TO_MONITOR "was restarted." ;
fi

