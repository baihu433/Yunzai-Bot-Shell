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
Alpine_Script="https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/AlpineLinux/Bot-Install.sh"
Arch_Script="https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/ArchLinux/Bot-Install.sh"
Kernel_Script="https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Centos/Bot-Install.sh"
Ubuntu_Script="https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Ubuntu/Bot-Install.sh"
Debian_Script="https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Debian/Bot-Install.sh"

function redis_server(){
Redis=$(redis-cli ping)
if [ ! "${Redis}" = "PONG" ]; then
 nohup redis-server &
 echo
fi
}

function BOT(){
if [[ "$1" == log ]];then
    if tmux ls | grep ${Bot_Name}
    then
        tmux attach -t ${Bot_Name}
        main
        exit
    else
        redis_server
        if (dialog --yesno "${Bot_Name} [未启动] \n是否立刻启动${Bot_Name}" 8 50);then
            tmux new -s ${Bot_Name} "&& node app"
        fi
        main
        exit
    fi
elif [[ "$1" == start ]];then
    if tmux ls | grep ${Bot_Name}
    then
        if (dialog --yesno "${Bot_Name} [已启动] \n是否打开${Bot_Name}窗口" 8 50);then
            tmux attach -t ${Bot_Name}
        fi
        main
        exit
    else
        redis_server
        tmux new -s ${Bot_Name} "node app"
        main
        exit
    fi
elif [[ "$1" == stop ]];then
    if tmux ls | grep ${Bot_Name}
    then
        tmux kill-session -t ${Bot_Name}
        main
        exit
    else
        dialog --msgbox "${Bot_Name} [未启动]" 8 50
        main
        exit
    fi
elif [[ "$1" == restart ]];then
    if tmux ls | grep ${Bot_Name}
    then
        
        tmux kill-session -t ${Bot_Name}
        tmux new -s ${Bot_Name} "node app"
        main
        exit
    else
        dialog --msgbox "${Bot_Name} [未启动]" 8 50
        main
        exit
    fi
elif [[ "$1" == login ]];then
    QQ=$(dialog --title "白狐-BOT" --inputbox "请输入您的机器人QQ号" 10 30 3>&1 1>&2 2>&3)
    password=$(dialog --title "白狐-BOT" --inputbox "请输入您的机器人QQ密码" 10 30 3>&1 1>&2 2>&3)
    dialog --title "请确认账号和密码" --yesno "\nQQ号: ${QQ} \n密码: ${password}" 10 30
    if [ ! -e config/config/qq.yaml ];then
        dialog --msgbox "账密文件不存在" 8 50
        main
        exit
    fi
    file=config/config/qq.yaml
    old_QQ=$(grep -w "qq:" ${file} | sed 's/qq://g')
    sed -i "s/${old_QQ}/${QQ}/g" ${file}
    old_password=$(grep -w "password:" ${file} | sed 's/password://g')
    sef -i "s/${old_password}/${password}/g" ${file}
fi
}

function main(){
Number=$(dialog \
--title "白狐 QQ群:705226976" \
--menu "${Bot_Name}管理" \
23 35 11 \
"1" "打开日志" \
"2" "启动运行" \
"3" "停止运行" \
"4" "重新启动" \
"5" "插件管理" \
"6" "重新登陆" \
"7" "前台启动" \
"8" "填写签名" \
"9" "配置文件" \
"A" "我要卸崽" \
"0" "返回" \
3>&1 1>&2 2>&3)
clear
if [[ ${Number} == "1" ]];then
    BOT log
    echo -en ${cyan}回车返回${background};read
    main
    exit
elif [[ ${Number} == "2" ]];then
    BOT start
    echo -en ${cyan}回车返回${background};read
    main
    exit
elif [[ ${Number} == "3" ]];then
    BOT stop
    echo -en ${cyan}回车返回${background};read
    main
    exit
elif [[ ${Number} == "4" ]];then
    BOT restart
    echo -en ${cyan}回车返回${background};read
    main
    exit
elif [[ ${Number} == "5" ]];then
    echo -en ${cyan}还没有重构完成 回车返回${background};read
    main
    exit
elif [[ ${Number} == "6" ]];then
    BOT login
    echo -en ${cyan}回车返回${background};read
    main
    exit
elif [[ ${Number} == "7" ]];then
    redis_server
    node app
elif [[ ${Number} == "8" ]];then
    echo -en ${cyan}还没有重构完成 回车返回${background};read
    main
    exit
elif [[ ${Number} == "A" ]];then
    echo -en ${cyan}还没有重构完成 回车返回${background};read
    main
    exit
fi
}

function install_Bot(){
if (dialog --title "白狐" \
   --yes-button "安装" \
   --no-button "返回" \
   --yesno "${Bot_Name}未安装，是否开始安装?" 13 40)
   then
     if (dialog --title "白狐" \
       --yes-button "Gitee" \
       --no-button "Github" \
       --yesno "请选择${Bot_Name}的下载服务器\n国内用户建议选择Gitee" 13 40)
       then
         if ! git clone --depth=1 ${Gitee} ~/.fox@bot/${Bot_Name};then
           echo -e ${red} 克隆失败 ${cyan}试试Github ${background}
           exit
         fi
       else
         if ! git clone --depth=1 ${Github} ~/.fox@bot/${Bot_Name};then
           echo -e ${red} 克隆失败 ${cyan}试试Gitee ${background}
           exit
         fi
     fi
     ln -sf ~/.fox@bot/${Bot_Name} ~/${Bot_Name}
fi
} #install_Yunzai_Bot

function install_Miao_Plugin(){
if (dialog --title "白狐" \
--yes-button "Gitee" \
--no-button "Github" \
--yesno "请选择的miao-plugin下载服务器\n国内用户建议选择Gitee" 13 40)
  then
    if ! git clone --depth=1 https://gitee.com/yoimiya-kokomi/miao-plugin.git ~/.fox@bot/${Bot_Name}/plugins/miao-plugin
    then
      echo -e ${red} 克隆失败 ${cyan}试试Github ${background}
      exit
    fi
  else
    if ! git clone --depth=1 https://github.com/yoimiya-kokomi/miao-plugin.git ~/.fox@bot/${Bot_Name}/plugins/miao-plugin
    then
      echo -e ${red} 克隆失败 ${cyan}试试Gitee ${background}
      exit
    fi
fi
} #install_Miao_Plugin

function install_Genshin(){
if (dialog --title "白狐" \
--yes-button "Gitee" \
--no-button "Github" \
--yesno "请选择的Genshin下载服务器\n国内用户建议选择Gitee" 13 40)
  then
    if ! git clone --depth=1 https://gitee.com/TimeRainStarSky/Yunzai-genshin ~/.fox@bot/${Bot_Name}/plugins/genshin
    then
      echo -e ${red} 克隆失败 ${cyan}试试Github ${background}
      exit
    fi
  else
    if ! git clone --depth=1 https://github.com/TimeRainStarSky/Yunzai-genshin ~/.fox@bot/${Bot_Name}/plugins/genshin
    then
      echo -e ${red} 克隆失败 ${cyan}试试Gitee ${background}
      exit
    fi
fi
} #install_Genshin

function Git_BOT(){
if [ ${Bot_Name} == "Yunzai|Yunzai-Bot" ];then
    install_Bot
elif [ ${Bot_Name} == "Miao-Yunzai" ];then
    install_Bot
    install_Miao_Plugin
elif [ ${Bot_Name} == "TRSS-Yunzai" ];then
    install_Bot
    install_Miao_Plugin
    install_Genshin
fi
cd ${Bot_Name}
bash <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/blob/master/manage/BOT-PACKAGE.sh)
}

function BOT_INSTALL(){
if grep -q -E Alpine /etc/issue && [ -x /sbin/apk ];then
    bash <(curl -sL ${Alpine_Script})
    Git_BOT
elif grep -q -E Arch /etc/issue && [ -x /usr/bin/pacman ];then
    bash <(curl -sL ${Arch_Script})
    Git_BOT
elif grep -q -E Kernel /etc/issue && [ -x /usr/bin/dnf ];then
    bash <(curl -sL ${Kernel_Script})
    Git_BOT
elif grep -q -E Kernel /etc/issue && [ -x /usr/bin/yum ];then
    bash <(curl -sL ${Kernel_Script})
    Git_BOT
elif grep -q -E Ubuntu /etc/issue && [ -x /usr/bin/apt ];then
    bash <(curl -sL ${Ubuntu_Script})
    Git_BOT
elif grep -q -E Debian /etc/issue && [ -x /usr/bin/apt ];then
    bash <(curl -sL ${Debian_Script})
    Git_BOT
fi
}

function Bot_Path(){
if [ -d "/root/${Bot_Name}" ];then
    Bot_Path="/root/${Bot_Name}"
    cd ${Bot_Path}
    main
elif [ -d "/root/.fox@bot/${Bot_Name}" ];then
    Bot_Path="/root/.fox@bot/${Bot_Name}"
    cd ${Bot_Path} 
    main
elif [ -d "/home/lighthouse/ubuntu/${Bot_Name}" ];then
    Bot_Path="/home/lighthouse/ubuntu/${Bot_Name}"
    cd ${Bot_Path}
    main
elif [ -d "/home/lighthouse/centos/${Bot_Name}" ];then
    Bot_Path="/home/lighthouse/centos/${Bot_Name}"
    cd ${Bot_Path}
    main
elif [ -d "/home/lighthouse/debian/${Bot_Name}" ];then
    Bot_Path="/home/lighthouse/debian/${Bot_Name}"
    cd ${Bot_Path}
    main
elif [ -d "/root/TRSS_AllBot/${Bot_Name}" ];then
    Bot_Path="/root/TRSS_AllBot/${Bot_Name}"
    cd ${Bot_Path}
    main
else
    if (dialog --title "白狐-Script" \
       --yes-button "安装" \
       --no-button "取消" \
       --yesno "未能找到${Bot_Name}根目录 \n请问是否立刻安装${Bot_Name}?" 10 50)
       then
           BOT_INSTALL
    fi
fi
}

function feedback(){
if [ ${feedback} == "1" ];then
    exit
elif [ ${feedback} == "255" ];then
    exit
fi
}

Number=$(dialog \
--title "白狐 QQ群:705226976" \
--menu "请选择bot" \
20 38 10 \
"1" "Yunzai[icqq版]" \
"2" "Miao-Yunzai" \
"3" "TRSS-Yunzai" \
"4" "签名服务器管理" \
"5" "gocq-http管理" \
"0" "退出" \
3>&1 1>&2 2>&3)
clear
feedback=$?
feedback
if [[ ${Number} == "1" ]];then
    if [ -d /root/TRSS_AllBot ];then
        export Bot_Name=Yunzai
    else
        export Bot_Name=Yunzai-Bot
    fi
    Gitee=https://gitee.com/yoimiya-kokomi/Yunzai-Bot.git
    Github=https://github.com/yoimiya-kokomi/Yunzai-Bot.git
    Bot_Path
elif [[ ${Number} == "2" ]];then
    export Bot_Name=Miao-Yunzai
    Gitee=https://gitee.com/yoimiya-kokomi/Miao-Yunzai.git
    Github=https://github.com/yoimiya-kokomi/Miao-Yunzai.git
    Bot_Path
elif [[ ${Number} == "3" ]];then
    export Bot_Name=TRSS-Yunzai
    Gitee=https://gitee.com/TimeRainStarSky/Yunzai.git
    Github=https://github.com/TimeRainStarSky/Yunzai.git
    Bot_Path
elif [[ ${Number} == "4" ]];then
    QSignServer
elif [[ ${Number} == "5" ]];then
    Gocq-Http
elif [[ ${Number} == "0" ]];then
    exit
else
    exit
fi