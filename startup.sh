#!/bin/sh
# This shell is used to check the fts real time service is alive, if not, restart fts.
trap " " 2
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

checkitem="$0"
procCnt=`ps -ef|grep "$checkitem"|grep -v 'grep'|grep -v "$$"|awk '{print $2}'|wc -l`
if [ $procCnt -gt 0 ] ; then    
    echo "$0 exists [procs=${procCnt}]"
    exit 1;
fi

while [ true ];
do
   if [ ! -x "$SHELL_DIR/$SHELL_NAME" ]; then
      chmod +x $SHELL_DIR/$SHELL_NAME
   fi
   $SHELL_DIR/$SHELL_NAME
   sleep $EXEC_INTERVAL
done
