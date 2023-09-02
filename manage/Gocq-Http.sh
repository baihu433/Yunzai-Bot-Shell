#!/bin/env bash
cd $HOME
export red="\033[31m"
export green="\033[32m"
export yellow="\033[33m"
export blue="\033[34m"
export purple="\033[35m"
export cyan="\033[36m"
export white="\033[37m"
export background="\033[0m"

function Gocq_Http_Install(){
cd $HOME
bash <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/manage/BOT-PKG.sh)
source <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/manage/BOT-ARCH.sh)
URL="https://gitee.com/baihu433/Yunzai-Bot-Shell/releases/download/go-cqhttp-dev/linux_${ARCH}.zip"
until wget -q --show-progress -O go-cqhttp.zip -c ${URL}
do
    echo -e ${red}下载失败 3秒后重试${background}
    sleep 3s
done
unzip go-cqhttp.zip -d go-cqhttp
rm go-cqhttp.zip
mv go-cqhttp/go-cqhttp* go-cqhttp/go-cqhttp
chmod +x go-cqhttp/go-cqhttp
cd go-cqhttp
./go-cqhttp
QQ=$(${dialog_whiptail} --title "白狐-BOT" --inputbox "请输入您的机器人QQ号" 10 30 3>&1 1>&2 2>&3)
password=$(${dialog_whiptail} --title "白狐-BOT" --inputbox "请输入您的机器人QQ密码" 10 30 3>&1 1>&2 2>&3)
${dialog_whiptail} --title "请确认账号和密码" --yesno "\nQQ号: ${QQ} \n密码: ${password}" 10 30
feedback=$?
if [[ ${feedback} == "1" ]];then
    echo -en ${cyan}回车返回${background};read
    exit
fi
file=config.yml
old_QQ=$(grep -w "uin:" ${file} | sed 's/uin://g')
if [ -z "${old_QQ}" ]; then
    echo -en ${red}读取失败 回车返回${background};read
    exit
fi
old_QQ=$(echo ${old_QQ})
sed -i "s/${old_QQ}/${QQ}/g" ${file}
old_password=$(grep -w "password:" ${file} | sed 's/password://g')
if [ -z "${old_password}" ]; then
    echo -en ${red}读取失败 回车返回${background};read
    main
    exit
fi
old_password=$(echo ${old_password})
sed -i "s/${old_password}/${password}/g" ${file}
}

function GOCQ_HTTP(){
if [[ "$1" == log ]];then
    if tmux ls | grep go-cqhttp
    then
        tmux attach -t go-cqhttp
        main
        exit
    else
        redis_server
        if (${dialog_whiptail} --yesno "go-cqhttp [未启动] \n是否立刻启动go-cqhttp" 8 50);then
            tmux new -s go-cqhttp "node app"
        fi
        main
        exit
    fi
elif [[ "$1" == start ]];then
    if tmux ls | grep go-cqhttp
    then
        if (${dialog_whiptail} --yesno "go-cqhttp [已启动] \n是否打开go-cqhttp窗口" 8 50);then
            tmux attach -t go-cqhttp
        fi
        main
        exit
    else
        redis_server
        tmux new -s go-cqhttp "node app"
        main
        exit
    fi
elif [[ "$1" == stop ]];then
    if tmux ls | grep go-cqhttp
    then
        tmux kill-session -t go-cqhttp
        main
        exit
    else
        ${dialog_whiptail} --msgbox "go-cqhttp [未启动]" 8 50
        main
        exit
    fi
elif [[ "$1" == restart ]];then
    if tmux ls | grep go-cqhttp
    then
        tmux kill-session -t go-cqhttp
        tmux new -s go-cqhttp "node app"
        main
        exit
    else
        ${dialog_whiptail} --msgbox "go-cqhttp [未启动]" 8 50
        main
        exit
    fi
fi
}

function feedback(){
if [ ! ${feedback} == "0" ];then
    exit
fi
}
function main(){
Number=$(${dialog_whiptail} \
--title "白狐 QQ群:705226976" \
--menu "请选择操作" \
20 38 13 \
"1" "部署go-cqhttp" \
"2" "启动go-cqhttp" \
"3" "日志go-cqhttp" \
"4" "停止go-cqhttp" \
"5" "重启go-cqhttp" \
"6" "配置go-cqhttp" \
"7" "卸载go-cqhttp" \
"0" "退出" \
3>&1 1>&2 2>&3)
feedback=$?
feedback
if [ ${feedback} == "1" ];then
    exit
elif [ ${feedback} == "255" ];then
    exit
fi
if [[ ${Number} == "1" ]];then
    if [ ! -x $HOME/go-cqhttp/go-cqhttp ];then
        Gocq_Http_Install
    fi
elif [[ ${Number} == "2" ]];then
    GOCQ_HTTP start
elif [[ ${Number} == "3" ]];then
    GOCQ_HTTP log
elif [[ ${Number} == "4" ]];then
    GOCQ_HTTP stop
elif [[ ${Number} == "5" ]];then
    GOCQ_HTTP restart
elif [[ ${Number} == "6" ]];then
    if [ -e $HOME/go-cqhttp/config.yml ]
    then
        micro $HOME/go-cqhttp/config.yml
    else
        ${dialog_whiptail} --msgbox "go-cqhttp 配置文件 [不存在]" 8 50
    fi
elif [[ ${Number} == "7" ]];then
    rm -rvf $HOME/go-cqhttp > /dev/null
    rm -rvf $HOME/go-cqhttp > /dev/null
elif [[ ${Number} == "0" ]];then
    exit
fi
}
if [ -x "$(command -v whiptail)" ];then
    export dialog_whiptail=whiptail
elif [ -x "$(command -v dialog)" ];then
    export dialog_whiptail=dialog
fi
function mainbak()
{
   while true
   do
       main
       mainbak
   done
}
mainbak