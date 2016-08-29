#!/bin/sh
# This shell is used to check the fts real time service is alive, if not, restart fts.

#Define variable
#检测间隔时间
EXEC_INTERVAL=60
#启动脚本所在目录
SHELL_NAME="run.sh"
#当前目录
FILE_DIR=$(cd "$(dirname "$0")"; pwd)
#APP目录
APP_DIR=$FILE_DIR
#JRE目录
SHELL_DIR=$APP_DIR/conf

while [ true ];
do
   $SHELL_DIR/run.sh
   sleep $EXEC_INTERVAL
done