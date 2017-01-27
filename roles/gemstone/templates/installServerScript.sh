#!/bin/bash
export GS_HOME=`pwd`
export PATH=$GS_HOME/bin:$PATH
installServer > installServer.log
