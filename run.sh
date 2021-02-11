THIS_DIR="$( cd "$( dirname "$0"  )" && pwd )"
PARENT_DIR=`dirname "${THIS_DIR}"`

APP_NAME=collect-2.0.jar
JAR_PATH="$THIS_DIR/$APP_NAME";
CONF_PATH="$THIS_DIR/conf/application-dev.properties,$THIS_DIR/conf/quartz.properties"
LOG_PATH="$THIS_DIR/catalina.out"

#使用说明，用来提示输入参数
usage(){
    echo "Usage: sh switch.sh [start|stop|restart|status]"
    exit 1
}

#检查程序是否在运行
is_exist(){
  pid=`ps -ef|grep $APP_NAME|grep -v grep|awk '{print $2}'`
  #如果不存在返回1，存在返回0
  if [ -z "${pid}" ]; then
   return 1
  else
    return 0
  fi
}

#启动方法
start(){
  is_exist
  if [ $? -eq 0 ]; then
    echo "${APP_NAME} is already running. pid=${pid}"
  else
    nohup java -cp $CLASSPATH:./:$JAR_PATH:$THIS_DIR/conf org.springframework.boot.loader.JarLauncher  --spring.config.location=$CONF_PATH > $LOG_PATH 2>&1 &
    echo "nohup java -cp $CLASSPATH:./:$JAR_PATH:$THIS_DIR/conf org.springframework.boot.loader.JarLauncher  --spring.config.location=$CONF_PATH > $LOG_PATH 2>&1 &"
    echo "${APP_NAME} start success"
  fi
  tailf catalina.out
}

#停止方法
stop(){
  is_exist
  if [ $? -eq "0" ]; then
    kill -9 $pid
    echo "${APP_NAME} stop success"
  else
    echo "${APP_NAME} is not running"
  fi
}

#输出运行状态
status(){
  is_exist
  if [ $? -eq "0" ]; then
    echo "${APP_NAME} is running. Pid is ${pid}"
  else
    echo "${APP_NAME} is NOT running."
  fi
}

#重启
restart(){
  stop
  sleep 5
  start
}

#根据输入参数，选择执行对应方法，不输入则执行使用说明
case "$1" in
  "start")
    start
    ;;
  "stop")
    stop
    ;;
  "status")
    status
    ;;
  "restart")
    restart
    ;;
  *)
    usage
    ;;
esac
