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
let procCnt=`ps -A --format='%p%P%C%x%a' --width 2048 -w --sort pid|grep "$checkitem"|grep -v grep|grep -v " -c sh "|grep -v "$$" | grep -c sh|awk '{printf("%d",$1)}'`
if [ ${procCnt} -gt 0 ] ; then
    echo "$0脚本已经在运行[procs=${procCnt}],此次执行自动取消."
    exit 1;
fi

while [ true ];
do
   $SHELL_DIR/$SHELL_NAME
   sleep $EXEC_INTERVAL
done
