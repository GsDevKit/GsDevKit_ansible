#!/bin/bash
#rm /opt/scripts/topaz.log
#touch /opt/scripts/topaz.log
rm /opt/scripts/seasideLoaded
touch /opt/scripts/seasideLoaded
export GS_HOME=/opt/git/GsDevKit_home/
source ${GS_HOME}/bin/defGsDevKit.env
stonePath=$GS_SERVER_STONES/{{stoneName}}
pushd $stonePath $stonePath >& /dev/null
source $stonePath/stone.env
popd >& /dev/null




cat /opt/scripts/topazSeasideLoadScript.st | startTopaz {{stoneName}} -l -T200000 #2>&1 >> /opt/scripts/topaz.log
exit $(<seasideLoaded)
