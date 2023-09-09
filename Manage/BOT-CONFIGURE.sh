#!/bin/env bash
export red="\033[31m"
export green="\033[32m"
export yellow="\033[33m"
export blue="\033[34m"
export purple="\033[35m"
export cyan="\033[36m"
export white="\033[37m"
export background="\033[0m"

function configure_file(){
bot_yaml(){


}

Number=$(${dialog_whiptail} \
--title "白狐 QQ群:705226976" \
--menu "配置文件管理" \
23 35 11 \
"1" "bot.yaml" \
"2" "group.yaml" \
"3" "notice.yaml" \
"4" "other.yaml" \
"5" "qq.yaml" \
"6" "redis.yaml" \
"7" "renderer.yaml" \
"0" "返回" \
3>&1 1>&2 2>&3)
if [ ${Number} == "1" ];then
    micro_yaml bot.yaml
elif [ ${Number} == "2" ];then
    micro_yaml group.yaml
elif [ ${Number} == "3" ];then
    micro_yaml notice.yaml
elif [ ${Number} == "4" ];then
    micro_yaml other.yaml
elif [ ${Number} == "5" ];then
    micro_yaml qq.yaml
elif [ ${Number} == "6" ];then
    micro_yaml redis.yaml
elif [ ${Number} == "7" ];then
    micro_yaml renderer.yaml
elif [ ${Number} == "0" ];then
    main
    exit
fi
}