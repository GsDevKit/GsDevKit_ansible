#! /bin/sh
#set -x
#=========================================================================
# Copyright (C) GemTalk Systems 1986-2014.  All Rights Reserved..
#
# Name - onlinebackup.sh
#
# Purpose - Example script to suspend checkpoints to allow for file system
#           backup of live extents, then resume checkpoints. Note that this
#           script is skeletal. 
#
#           In order to actually use this script for taking online backups,
#           you must add code to make copies of your live extents. This can
#           be as simple as using 'cp', but will more likely involve breaking
#           a disk mirror and then resynchronizing.
#
#           Please consult your GemStone documentation for complete details
#           and caveats for this procedure, as well as instructions on 
#           restoring your system from live extent copies.
#
# $Id: onlinebackup.sh 32752 2014-02-28 22:11:10Z stever $
#
#=========================================================================

if [ "a$GEMSTONE" = "a" ]; then
  echo "ERROR: GemStone scripts require a GEMSTONE environment variable."
  echo "       Please set it to the directory where GemStone resides."
  exit 1
fi

if [ "x$PATH" = "x" ]; then PATH=:/bin:/usr/bin:/usr/ucb; export PATH; fi 

# error control - do not allow hup
trap '' 1

comid="onlinebackup"			# this script's name

usage() {
  cat <<EOF
Usage:
$comid [-h][-m <minutes>][-p <password>][-s <stonename>][-u <username>]

-h              display this message and exit
-m <minutes>    suspend checkpoints for <minutes> (defaults to 15)
-p <password>   GemStone password (defaults to 'swordfish')
-s <stonename>  name of stone (defaults to gs64stone)
-u <username>   GemStone user name (defaults to 'DataCurator')

Description:

Example script to suspend checkpoints to allow for file system
backup of live extents, then resume checkpoints. Note that this
script is skeletal. 

In order to actually use this script for taking online backups,
you must add code to make copies of your live extents. This can
be as simple as using 'cp', but will more likely involve breaking
a disk mirror and later resynchronizing.

Please consult your GemStone documentation for complete details
and caveats for taking online backups, as well as instructions on 
restoring your system from live extent copies.
EOF
  exit $status
}

# default values
gemstone="seaside"
user="DataCurator"
pass="swordfish"
minutes=15
logfile="backup$$.log"

# process command line
while getopts "hs:m:u:p:" opt; do
  case $opt in 
    h) status=0; usage ;;
    s) gemstone=$OPTARG ;;
    m) minutes=$OPTARG ;;
    p) pass=$OPTARG ;;
    u) user=$OPTARG ;;
    \?) status=1; usage ;;
  esac
done

cat <<EOF>$logfile
# -------------------------------------------------------------------------- 
# `date` 
# beginning online backup
# ---------------------------------------------------------------------------
EOF

# ---
# suspend checkpoints
# ---
$GEMSTONE/bin/topaz -il <<EOF>> $logfile
set user $user password $pass gemstone $gemstone
display resultcheck
iferror exit
login
expectvalue true
run
System suspendCheckpointsForMinutes: $minutes
%
exit
EOF

status=$?
if [ $status -ne 0 ]; then
  cat <<EOF>>$logfile
# ---------------------------------------------------------------------------
# System suspendCheckpointsForMinutes: $minutes failed. No backup taken.
# ---------------------------------------------------------------------------
EOF
  echo "$comid: failure. Check $logfile."
  exit $status
fi

# ---
# perform the file system backup
# ---
# insert code here to take file system copies of your extents. 
backupTimeString=`date +%Y%m%d%H%M%S`.dbf
cp {{primary_extent_path}}/extent0.dbf {{primary_extent_path}}/backups/$backupTimeString
# ---
# resume checkpoints
# ---
$GEMSTONE/bin/topaz -il <<EOF>> $logfile
set user $user password $pass gemstone $gemstone
display resultcheck
iferror exit
login
expectvalue true
run
System resumeCheckpoints
%
exit
EOF

# zip up the backup, remove the uncompressed backup, and ln to the latest backup zip file.
unlink latest.zip
zip -j {{primary_extent_path}}/backups/$backupTimeString.zip {{primary_extent_path}}/backups/$backupTimeString.dbf
rm {{primary_extent_path}}/backups/$backupTimeString.dbf
ln -s $backupTimeString.zip latest.zip


status=$?
if [ $status -ne 0 ]; then
  cat <<EOF>> $logfile
# ---------------------------------------------------------------------------
# System resumeCheckpoints failed. This indicates checkpoint activity had
# resumed before file system extent copy completed.
# Copied extents are not usable.
# ---------------------------------------------------------------------------
EOF
  echo "$comid: failure. Check $logfile."
  exit $status
fi

cat <<EOF>>$logfile
# ---------------------------------------------------------------------------
# `date` 
# finished online backup
# ---------------------------------------------------------------------------
EOF
echo "$comid: online backup complete."
exit 0
