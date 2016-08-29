#!/bin/sh
# This shell is used to check the fts real time service is alive, if not, restart fts.

#Define variable
#�����ű�
SHELL_NAME="startup.sh"
#���ĳ�������
FTS_NAME="php-fpm"
#�����ű�����Ŀ¼
SHELL_DIR=`pwd`
#�����ʱ��
EXEC_INTERVAL=30
#���˿ں�
FTS_RT_PORT=9000
#LOG·��
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