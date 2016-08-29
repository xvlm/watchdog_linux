#!/bin/sh
# This shell is used to check the fts real time service is alive, if not, restart fts.

#Define variable
#启动脚本
SHELL_NAME="startup.sh"
#检测的程序名称
FTS_NAME="php-fpm"
#启动脚本所在目录
SHELL_DIR=`pwd`
#检测间隔时间
EXEC_INTERVAL=30
#检测端口号
FTS_RT_PORT=9000
#LOG路径
WATCHDOG_LOG_FILE=$HOME/ftswatch.log


#Define function
. $SHELL_DIR/checkservice.public

mydate() {
date +"%Y-%m-%d %H:%M:%S"
}

startup(){
echo [`mydate`]Starting FTS Service! >> $WATCHDOG_LOG_FILE
$SHELL_DIR/$SHELL_NAME
checkservice
if [  $? -ne 1 ];
then
    echo [`mydate`]FTS Service has failed to start! >> $WATCHDOG_LOG_FILE
else
    echo [`mydate`]FTS Service has been lauched. >> $WATCHDOG_LOG_FILE
fi
}

while [ true ];
do
   checkservice
   if [ $? -ne 1 ];
   then
       echo [`mydate`]FTS real time service was down! >> $WATCHDOG_LOG_FILE
       startup
   fi
   sleep $EXEC_INTERVAL
done