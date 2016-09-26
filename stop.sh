#!/bin/sh
# This shell is used to check the fts real time service is alive, if not, restart fts.
#Define variable
#检测的程序名称
APP_NAME="mft-cli.jar"
#启动脚本名称
STARTUP_NAME="startup.sh"
#APP目录
APP_DIR=$(cd "$(dirname "$0")"; pwd)
#LOG路径
LOG_FILE=$APP_DIR/stop.log

mydate() {
date +"%Y-%m-%d %H:%M:%S"
}

checkservice() {
sleep 1 
appnum=`ps -ef | grep $APP_NAME | grep -v grep | awk '{print $2}' | wc -l`
echo "appnum=$appnum" >> $LOG_FILE
if [ $appnum -ne 0 ];then
      return 1
else
      return 0
fi
}

killapp(){
echo [`mydate`]stoping startup.sh! >> $LOG_FILE
ps -ef | grep $STARTUP_NAME | grep -v 'grep' | awk '{print $2}' | xargs kill -9 > /dev/null 
if [  $? -eq 0 ];
then
    echo [`mydate`]startup.sh Service stop success! >> $LOG_FILE
else
    echo [`mydate`]startup.sh Service stop failed. >> $LOG_FILE
fi

ps -ef | grep $APP_NAME | grep -v grep | awk '{print $2}' | xargs kill -9 > /dev/null 
checkservice
if [  $? -ne 1 ];
then
    echo [`mydate`]FTS Service stop success! >> $LOG_FILE
else
    echo [`mydate`]FTS Service stop failed. >> $LOG_FILE
fi

}

killapp
exit
