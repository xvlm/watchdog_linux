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
#JRE目录
JAVA_HOME=$APP_DIR/jre
#检测端口号
APP_PORT=6081
#LOG路径
LOG_FILE=$APP_DIR/startup.log
#心跳文件路径
HEARTBREAK_FILE=$FILE_DIR/heartbreak.txt

checkservice() {
sleep 3 
appnum=`ps -ef | grep "$APP_NAME" | grep -v 'grep' | awk '{print $2}' | wc -l`
portnum=`netstat -an | grep "$APP_PORT" | grep -i listen | wc -l`
echo "appnum=$appnum portnum=$portnum" >> $LOG_FILE
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

ps -ef | grep "$APP_NAME" | grep -v 'grep' | awk '{print $2}' | xargs kill -9 > /dev/null
$JAVA_HOME/bin/java -jar $APP_DIR/$APP_NAME & > /dev/null
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

ps -ef | grep $APP_NAME | grep -v grep | awk '{print $2}' | xargs kill -9 > /dev/null
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
