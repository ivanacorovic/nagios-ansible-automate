#!/bin/bash
#===============================================================================
#
#          FILE:  check_nginx_status.sh
# 
#         USAGE:  ./check_nginx_status.sh 
# 
#   DESCRIPTION: Check Nginx Status 
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:   (), 
#       COMPANY:  
#       VERSION:  1.0
#       CREATED:  2009-5-8 14:22:33 中国标准时间
#      REVISION:  ---
#===============================================================================

if [ $# -ne 3 ] ; then
	echo "Usage $0 Host Port URI"
	exit 3
fi

TMPDir=/var/tmp
host=$1
port=$2
status_uri=$3
url="http://$host:$port/$status_uri"
status_uri=`echo $status_uri|sed 's/\//_/g'`
status_file="$TMPDir/$host.$port.$status_uri"

wget -T 90 $url -O $status_file -o /dev/null
if [ $? -ne 0 ];then
	echo "Unkonw - Get status from $url error"
	exit 3
fi
AC=`head -n 1  $status_file |awk '{print $3}'`
RD=`tail -n 1  $status_file |awk '{print $2}'`
WR=`tail -n 1  $status_file |awk '{print $4}'`
WA=`tail -n 1  $status_file |awk '{print $6}'`
output="Nginx Status at $url OK. Active connections: $AC Reading: $RD Writing: $WR Waiting: $WA"
perfdata="AC=$AC;0;0;0;0 RD=$RD;0;0;0;0 WR=$WR;0;0;0;0 WA=$WA;0;0;0;0"
echo "$output|$perfdata"
exit 0 