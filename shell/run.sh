#!/bin/ksh
#Define variable

#检测的程序名称
APP_NAME="mft-cli.jar"
#当前目录
FILE_DIR=$(cd "$(dirname "$0")"; pwd)
#APP目录
APP_DIR=${FILE_DIR%/*}
#FLAG标志文件路径
FLAG_PATH=$APP_DIR/"_RESET.txt"
#update目录
UPDATE_DIR=$APP_DIR/"upgrade"
#update 任务执行标记
UPDATING_FLAG_PATH=$APP_DIR/"_updating"
#检测端口号
#APP_PORT=6081
APP_PORT=`cat $FILE_DIR/app.properties | grep HTTP_PORT | awk -F= '{print $2}'`
#LOG路径
LOG_FILE=$APP_DIR/startup.log
#心跳文件路径
HEARTBREAK_FILE=$FILE_DIR/heartbreak.txt

#JRE目录 根据linux 版本判断调用32位还是64位jre
if [ $(getconf WORD_BIT) = '32' ] && [ $(getconf LONG_BIT) = '64' ] ; then
    JAVA_HOME=$APP_DIR/jre64
else
    JAVA_HOME=$APP_DIR/jre32
fi

#ps命令用哪个 解决sunos solaris中的PS命令无法正常显示全部内容的问题 
if [ -f "/usr/ucb/ps" ];then
   PS_COMMAND="/usr/ucb/ps -auxww"
else
   PS_COMMAND="ps -ef"
fi

checkservice() {
sleep 3 
appnum=`$PS_COMMAND | grep $APP_NAME | grep -v 'grep' | awk '{print $2}' | wc -l`
portnum=`netstat -an | grep $APP_PORT | grep -i listen | wc -l`
echo "$APP_NAME[$appnum] PORT$APP_PORT[$portnum]" >> $LOG_FILE
if [ $portnum -ne 0 ] && [ $appnum -ne 0 ];then
      return 1
else
      return 0
fi
}

checkflag() {
echo [`mydate`] checkflag $FLAG_PATH ! >> $LOG_FILE
if [ -f $FLAG_PATH ];then
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
if [ -f $UPDATING_FLAG_PATH ];then
echo $UPDATING_FLAG_PATH >> $LOG_FILE
echo "UPDATING_FLAG_PATH exists ,Starting stoped" >> $LOG_FILE
return 0
fi

if [ ! -d $JAVA_HOME ];then
echo $JAVA_HOME >> $LOG_FILE
echo "jre not exists" >> $LOG_FILE
return 0
fi
export JAVA_HOME

$PS_COMMAND | grep $APP_NAME | grep -v grep | awk '{print $2}' | xargs kill -9 > /dev/null
if [ ! -x "$JAVA_HOME/bin/java" ]; then
   chmod +x $JAVA_HOME/bin/java
fi
nohup $JAVA_HOME/bin/java -jar $APP_DIR/$APP_NAME & > /dev/null
checkservice
if [  $? -ne 1 ];
then
    echo [`mydate`]FTS Service has failed to start! >> $LOG_FILE
else
    echo [`mydate`]FTS Service has been lauched. >> $LOG_FILE
fi
}

update(){
echo [`mydate`]Starting update! >> $LOG_FILE

if [ ! -d $UPDATE_DIR ];then
echo  [`mydate`]$UPDATE_DIR >> $LOG_FILE
echo "[`mydate`]UPDATE_DIR not exists" >> $LOG_FILE
return 0
fi

$PS_COMMAND | grep $APP_NAME | grep -v grep | awk '{print $2}' | xargs kill -9 > /dev/null
sleep 3
touch $UPDATING_FLAG_PATH
cp -rf $UPDATE_DIR/*  $APP_DIR
if [ $? -ne 0 ]; then
    echo [`mydate`]update failed >> $LOG_FILE
    return 0
else
   rm -f $UPDATING_FLAG_PATH
   rm -f $FLAG_PATH
   rm -fr $UPDATE_DIR/*
   return 1
fi 
}

echo `mydate` > $HEARTBREAK_FILE
checkflag
if [ $? -eq 1 ];
then
    echo [`mydate`]flag exists! >> $LOG_FILE
    update
    if [ $? -eq 1 ];then
        startup
    fi
else
    checkservice
    if [ $? -ne 1 ];
    then
        echo [`mydate`]FTS real time service was down! >> $LOG_FILE
        startup
    fi
fi