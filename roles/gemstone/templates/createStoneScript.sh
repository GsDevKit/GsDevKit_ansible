#!/bin/bash
export GS_HOME=`pwd`
export PATH=$GS_HOME/bin:$PATH
createStone {{stoneName}} {{gemstone_vers}} > createStone.log
stopStone {{stoneName}} > stopStone.log
touch {{stoneName}}{{gemstone_vers}}
