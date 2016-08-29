#!/bin/sh
#Define variable

#检测的程序名称
APP_NAME="mft-cli.jar"
#当前目录
FILE_DIR=$(cd "$(dirname "$0")"; pwd)
#APP目录
APP_DIR=${FILE_DIR%/*}
#JRE目录
JAVA_HOME=$APP_DIR/jre
#检测端口号
APP_PORT=6081
#LOG路径
LOG_FILE=$APP_DIR/startup.log

checkservice() {
sleep 3 
appnum=`ps -ef | grep $APP_NAME | grep -v grep | awk '{print $2}' | wc -l`
portnum=`netstat -an | grep $APP_PORT | grep -i listen | wc -l`
echo "appnum=$appnum portnum=$portnum" >> $LOG_FILE
if [ $portnum -ne 0 ] && [ $appnum -ne 0 ];then
      return 1
else
      return 0
fi
}

mydate() {
date +"%Y-%m-%d %H:%M:%S"
}

startup(){
echo [`mydate`]Starting FTS Service! >> $LOG_FILE


if [ ! -d $JAVA_HOME ];then
echo $JAVA_HOME
echo "jre not exists"
return 0
fi
export JAVA_HOME

ps -ef | grep $APP_NAME | grep -v grep | awk '{print $2}' | xargs kill -9
$JAVA_HOME/bin/java -jar $APP_DIR/$APP_NAME &

checkservice
if [  $? -ne 1 ];
then
    echo [`mydate`]FTS Service has failed to start! >> $LOG_FILE
else
    echo [`mydate`]FTS Service has been lauched. >> $LOG_FILE
fi
}

checkservice
if [ $? -ne 1 ];
then
    echo [`mydate`]FTS real time service was down! >> $LOG_FILE
    startup
fi

