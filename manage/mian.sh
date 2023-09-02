cd $HOME
export red="\033[31m"
export green="\033[32m"
export yellow="\033[33m"
export blue="\033[34m"
export purple="\033[35m"
export cyan="\033[36m"
export white="\033[37m"
export background="\033[0m"















function BOT_INSTALL(){



}





function Bot_Path(){
if [ -d "/root/${Bot_Name}" ];then
    Bot_Path="/root/${Bot_Name}"
elif [ -d "/root/.fox@bot/${Bot_Name}" ];then
    Bot_Path="/root/.fox@bot/${Bot_Name}"
elif [ -d "/home/lighthouse/ubuntu/${Bot_Name}" ];then
    Bot_Path="/home/lighthouse/ubuntu/${Bot_Name}"
elif [ -d "/home/lighthouse/centos/${Bot_Name}" ];then
    Bot_Path="/home/lighthouse/centos/${Bot_Name}"
elif [ -d "/home/lighthouse/debian/${Bot_Name}" ];then
    Bot_Path="/home/lighthouse/debian/${Bot_Name}"
elif [ -d "/root/TRSS_AllBot/${Bot_Name}" ];then
    Bot_Path="/root/TRSS_AllBot/${Bot_Name}"
else
    
    BOT_INSTALL
fi
}

Number=$(dialog \
--title "白狐 QQ群:705226976" \
--menu "请选择bot" \
20 40 10 \
"1" "Yunzai[icqq版]" \
"2" "Miao-Yunzai" \
"3" "TRSS-Yunzai" \
"4" "签名服务器管理" \
"5" "gocq-http管理"
"0" "退出" \
3>&1 1>&2 2>&3)
if [ ${Number} == "1" ];then
    if [ -d /root/TRSS_AllBot ];then
        Bot_Name=Yunzai
    else
        Bot_Name=Yunzai-Bot
    fi
    Bot_Path
elif [ ${Number} == "2" ];then
    Bot_Name=Miao-Yunzai
    Bot_Path
elif [ ${Number} == "3" ];then
    Bot_Name=TRSS-Yunzai
    Bot_Path
elif [ ${Number} == "4" ];then
    QSignServer
elif [ ${Number} == "5" ];then
    Gocq-Http
elif [ ${Number} == "0" ];then

else

fi