#!/bin/env bash
if ping -c 1 gitee.com > /dev/null 2>&1
    then
    up=true
else
    up=false
fi
export ver=0.2.3
cd $HOME
export red="\033[31m"
export green="\033[32m"
export yellow="\033[33m"
export blue="\033[34m"
export purple="\033[35m"
export cyan="\033[36m"
export white="\033[37m"
export background="\033[0m"
if [ -d /usr/local/node/bin ];then
    export PATH=$PATH:/usr/local/node/bin
    if [ ! -d $HOME/.local/share/pnpm ];then
        mkdir -p $HOME/.local/share/pnpm
    fi
    export PATH=$PATH:/root/.local/share/pnpm
    export PNPM_HOME=/root/.local/share/pnpm
fi
function QSIGN(){
if [ -d $HOME/QSignServer/qsign117e ]
then
export QSIGN_VERSION="117e"
elif [ -d $HOME/QSignServer/qsign119 ]
then
export QSIGN_VERSION="119"
fi
if [ -d $HOME/QSignServer/jdk ];then
export PATH=$PATH:$HOME/QSignServer/jdk/bin
export JAVA_HOME=$HOME/QSignServer/jdk
fi
if [ -d /usr/local/node/bin ];then
    if [ ! -d $HOME/.local/share/pnpm ];then
        mkdir -p $HOME/.local/share/pnpm
    fi
    export PATH=$PATH:$HOME/.local/share/pnpm
    export PNPM_HOME=$HOME/.local/share/pnpm
elif [ -d $HOME/QSignServer/node/bin ];then
    export PATH=$PATH:$HOME/QSignServer/node/bin
    export PNPM_HOME=$HOME/QSignServer/node/bin
elif [ -d /usr/lib/node_modules/pnpm/bin ];then
    if [ ! -d $HOME/.local/share/pnpm ];then
        mkdir -p $HOME/.local/share/pnpm
    fi
    export PATH=$PATH:$HOME/.local/share/pnpm
    export PNPM_HOME=$HOME/.local/share/pnpm
fi
if ! [ -x "$(command -v pm2)" ];then
    echo -e ${yellow}正在使用pnpm安装pm2${background}
    pnpm config set registry https://registry.npmmirror.com
    pnpm config set registry https://registry.npmmirror.com
    until pnpm install -g pm2@latest
    do
      echo -e ${red}pm2安装失败 ${green}正在重试${background}
      pnpm setup
    done
    echo
fi
if [ -d $HOME/QSignServer/qsign${QSIGN_VERSION} ];then
    ICQQ_VERSION="$(pnpm list icqq | grep icqq | sed "s/icqq //g" )"
    case ${ICQQ_VERSION} in
    0.5.3|0.5.2|0.5.1|0.5.0|0.4.14|0.4.13|0.4.12)
    export version=8.9.70
    ;;
    0.4.11)
    export version=8.9.68
    ;;
    0.4.10)
    export version=8.9.63
    ;;
    0.3.*)
    echo -e ${yellow}请更新icqq${background}
    export version=8.9.70
    ;;
    *)
    echo -e ${yellow}读取失败 请更新icqq${background}
    export version=8.9.70
    ;;
    esac
    if [ ! -e $HOME/QSignServer/txlib/${version}/config.json ];then
        echo -e ${red}文件不存在 请确认您已经部署签名服务器${background}
        exit
    fi
    file="$HOME/QSignServer/txlib/${version}/config.json"
    port="$(grep -E port ${file} | awk '{print $2}' | sed "s/\"//g" | sed "s/://g" )"
    key="$(grep -E key ${file} | awk '{print $2}' | sed "s/\"//g" | sed "s/,//g" )"
    host="$(grep -E host ${file} | awk '{print $2}' | sed "s/\"//g" | sed "s/,//g" )"
    API="http://"${host}":"${port}"/sign?key="${key}
    API=$(echo ${API})
    echo -e ${cyan}您的本地签名服务器API链接: ${green}${API}${background}
    file1="${Bot_Path}/config/config/bot.yaml"
    file2="${Bot_Path}/config/config/qq.yaml"
    equipment="platform: 2"
    if [ -e ${file1} ];then
        if ! grep -q "${API}" ${file1};then
            old_ver=$(grep ver ${file1})
            old_sign_api_addr=$(grep sign_api_addr ${file1})
            new_ver="ver: ${version}"
            new_sign_api_addr="sign_api_addr: ${API}"
            if [ ! -z ${old_ver} ];then
                sed -i "s|${old_ver}|${new_ver}|g" ${file1}
            fi
            sed -i "s|${old_sign_api_addr}|${new_sign_api_addr}|g" ${file1}
        fi
    #cd && sed -i '/sign_api_addr/d' M*/con*/con*/bot* && sed -i '$a\sign_api_addr: 127.0.0.1:6666/sign?key=fox' M*/con*/con*/bot*
    fi
    if [ -e ${file2} ];then
        if ! grep -q "${equipment}" ${file2};then
            sed -i "s/$(grep platform ${file2})/${equipment}/g" ${file2}
            sed -i "s/$(grep ver ${file2})//g" ${file2}
        fi
    fi
    API=$(echo ${API} | sed "s#/sign?key=${key}##g" )
    if pm2 list qsign${QSIGN_VERSION} | grep -q online
    then
        echo -e ${green}签名服务器 ${cyan}已启动${background}
            if curl -sL ${API} | grep -q ${version}
              then
                echo -e ${cyan}签名服务器的共享库版本 ${green}正确${background}
              else
                echo -e ${cyan}签名服务器的共享库版本 ${red}错误${background}
                echo -e ${yellow}正在重启签名服务器${background}
                pm2 delete qsign${QSIGN_VERSION}
                pm2 start --name qsign${QSIGN_VERSION} "bash $HOME/QSignServer/qsign${QSIGN_VERSION}/bin/unidbg-fetch-qsign --basePath=$HOME/QSignServer/txlib/${version}"
                sleep 5s
            fi
    else
        echo -e ${green}签名服务器 ${red}未启动${background}
        echo -e ${yellow}正在尝试启动签名服务器${background}
        pm2 start --name qsign${QSIGN_VERSION} "bash $HOME/QSignServer/qsign${QSIGN_VERSION}/bin/unidbg-fetch-qsign --basePath=$HOME/QSignServer/txlib/${version}"
        sleep 5s
    fi
fi
}
function pkg(){
if [ ! -e package.json ];then
    echo -e ${red}参数错误${background}
    exit
fi
}
function run(){
if pnpm pm2 list | grep -q ${Bot_Name};then
    pnpm pm2 stop ${Bot_Name}
    pnpm pm2 delete ${Bot_Name}
    echo -e ${red}进程停止 ${cyan}正在重启${background}
    bash ${Bot_Name} n
fi
if [ "${Bot_Path_check}" == "true" ];then
    pnpm run stop
    echo -e ${red}进程停止 ${cyan}正在重启${background}
    bash ${Bot_Name} n
fi
}
function help(){
echo -e ${green}=============================${background}
echo -e ${cyan} bh"        | "${blue}打开白狐脚本${background}
echo -e ${cyan} help"      | "${blue}获取快捷命令${background}
echo -e ${cyan} QS"        | "${blue}管理签名服务器${background}
echo -e ${cyan} YZ/MZ/TZ"  | "${green}[大写]${blue}选择您要控制的对象${background}
echo -e ${cyan} yz/mz/tz"  | "${green}[小写]${blue}进入相应的bot文件夹${background}
echo -e ${cyan} n"         | "${blue}前台启动${background}
echo -e ${cyan} start"     | "${blue}后台启动${background}
echo -e ${cyan} log"       | "${blue}打开日志${background}
echo -e ${cyan} stop"      | "${blue}停止运行${background}
echo -e ${cyan} login"     | "${blue}重新登陆${background}
echo -e ${cyan} PI"        | "${blue}打开插件管理脚本${background}
echo -e ${cyan} install"   | "${green}[依赖名] ${blue}安装依赖${background}
echo -e ${cyan} qsign"     | "${green}[API链接] ${blue}填写签名服务器API${background}
echo -e ${green}=============================${background}
echo -e ${yellow} 脚本完全免费 如果你是购买所得 请给差评 打击倒卖 从你我做起${background}
echo -e ${green} QQ群:${cyan}狐狸窝:705226976${background}
echo -e ${green}=============================${background}
}

function Bot_Path_Check(){
if [ -d "/root/${Bot_Name}/node_modules" ];then
    export Bot_Path="/root/${Bot_Name}"
elif [ -d "/root/.fox@bot/${Bot_Name}/node_modules" ];then
    export Bot_Path="/root/.fox@bot/${Bot_Name}"
elif [ -d "/home/lighthouse/ubuntu/${Bot_Name}/node_modules" ];then
    export Bot_Path="/home/lighthouse/ubuntu/${Bot_Name}"
elif [ -d "/home/lighthouse/centos/${Bot_Name}/node_modules" ];then
    export Bot_Path="/home/lighthouse/centos/${Bot_Name}"
elif [ -d "/home/lighthouse/debian/${Bot_Name}/node_modules" ];then
    export Bot_Path="/home/lighthouse/debian/${Bot_Name}"
elif [ -d "/root/TRSS_AllBot/${Bot_Name}/node_modules" ];then
    export Bot_Path="/root/TRSS_AllBot/${Bot_Name}"
elif [ -d "${Bot_Path}" ];then
    echo -e ${cyan}自定义路径: ${Bot_Path} ${green}判断通过${background}
else 
    echo -e ${red}参数错误${background}
    exit
fi
}

case "$1" in
QS)
bash <(curl https://gitee.com/baihu433/Ubuntu-Yunzai/raw/master/QSignServer3.0.sh)
exit
;;
YZ|Yunzai|Yunzai-Bot)
if [ -z "${Bot_Name}" ]; then
    export Bot_Name=Yunzai-Bot
fi
Bot_Path_Check
cd ${Bot_Path}
;;
MZ|Miao-Yunzai)
if [ -z "${Bot_Name}" ]; then
    export Bot_Name=Miao-Yunzai
fi
Bot_Path_Check
cd ${Bot_Path}
;;
TZ|TRSS-Yunzai)
if [ -z "${Bot_Name}" ]; then
    export Bot_Name=TRSS-Yunzai
fi
Bot_Path_Check
cd ${Bot_Path}
;;
yz)
if [ -z "${Bot_Name}" ]; then
    export Bot_Name=Yunzai-Bot
fi
Bot_Path_Check
cd ${Bot_Path} && exec bash -i
exit
;;
mz)
if [ -z "${Bot_Name}" ]; then
    export Bot_Name=Miao-Yunzai
fi
Bot_Path_Check
cd ${Bot_Path} && exec bash -i
exit
;;
tz)
if [ -z "${Bot_Name}" ]; then
    export Bot_Name=TRSS-Yunzai
fi
Bot_Path_Check
cd ${Bot_Path} && exec bash -i
exit
;;
help)
help
exit
;;
unup)
up=false
;;
PI)
bash <(curl -sL https://gitee.com/baihu433/Ubuntu-Yunzai/raw/master/plug-in.sh)
;;
esac

if echo "$1" | grep -q -E "/" ;then
    if [ -d "$1" ]
    then
        cd "$1"
    else
        echo -e ${red}参数错误${background}
        exit
    fi
fi

case "$2" in
n)
pkg
QSIGN
Redis=$(redis-cli ping)
if ! [ "${Redis}" = "PONG" ]; then
 redis-server &
 echo
fi
node app
run
echo -en ${cyan}回车退出${background};read
exit
;;
start)
pkg
QSIGN
Redis=$(redis-cli ping)
if ! [ "${Redis}" = "PONG" ]; then
 nohup redis-server &
 echo
fi
pnpm run start
exit
;;
stop)
pkg
pnpm run stop
exit
;;
log)
pkg
pnpm run log
exit
;;
login)
pkg
pnpm run login
exit
;;
install)
pkg
pnpm install
pnpm install "$3" -w
exit
;;
qsign)
pkg
sed -i '/sign_api_addr/d' config/config/bot.yaml
sed -i "\$a\sign_api_addr: $3" config/config/bot.yaml
API=$(grep sign_api_addr config/config/bot.yaml)
API=$(echo ${API} | sed "s/sign_api_addr//g")
echo -e ${cyan}您的API链接已修改为 ${green}${API}${background}
exit
;;
up)
case $3 in
  bot)
  remote=$(grep 'remote =' .git/config | sed 's/remote =//g')
  remote=$(echo ${remote})
  branch=$(grep branch .git/config | sed "s/\[branch \"//g" | sed 's/"//g' | sed "s/\]//g")
  branch=$(echo ${branch})
  git fetch --all
  git reset --hard ${remote}/${branch}
  git pull
  exit
  ;;
  pkg)
  yes "Y" | pnpm install
  yes "Y" | pnpm install puppeteer@19.0.0 -w
  exit
  ;;
esac
;;
fix)
pkg
case $3 in
  pkg)
  rm -rf node_modules 
  yes "Y" | pnpm install -P
  yes "Y" | pnpm install
  yes "Y" | pnpm install puppeteer@19.0.0 -w
  exit
  ;;
esac
;;
esac

if [ ! "${up}" = "false" ];then
version=`curl -s https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/version`
    if [ "$version" != "$ver" ];then
        echo -e ${cyan}正在更新${background}
        rm /usr/local/bin/bh
        curl -o bh https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/Mian.sh
        mv bh /usr/local/bin/bh
        chmod +x /usr/local/bin/bh
        if ! bh help > /dev/null 2>&1;then
            echo -e ${yellow} - ${red}更新失败${background}
            echo -e ${yellow} - ${cyan}正在尝试解决${background}
            old_bh_bash='#!/bin/env bash'
            new_bh_bash=$(which bash)
            sed -i "s|${old_bh_bash}|#!${new_bh_bash}|g" /usr/local/bin/bh
            exit
                if ! bh help > /dev/null 2>&1;then
                    echo -e ${yellow} - ${red}解决失败${background}
                    exit
                fi
            echo -e ${yellow} - ${green}解决成功${background}
        fi
        echo -en ${cyan}更新完成 回车继续${background};read
        bh
        exit
    fi
fi

function BOT(){
if [[ "$1" == log ]];then
    if tmux ls | grep -q ${Bot_Name} > /dev/null
    then
        tmux attach -t ${Bot_Name}
        main
        exit
    else
        if (${dialog_whiptail} --yesno "${Bot_Name} [未启动] \n是否立刻启动${Bot_Name}" 8 50);then
            tmux new -s ${Bot_Name} "bh ${Bot_Name} n"
        fi
        main
        exit
    fi
elif [[ "$1" == start ]];then
    if tmux ls | grep -q ${Bot_Name} > /dev/null
    then
        if (${dialog_whiptail} --yesno "${Bot_Name} [已启动] \n是否打开${Bot_Name}窗口" 8 50);then
            tmux attach -t ${Bot_Name}
        fi
        main
        exit
    else
        tmux new -s ${Bot_Name} "bh ${Bot_Name} n"
        main
        exit
    fi
elif [[ "$1" == stop ]];then
    if tmux ls | grep -q ${Bot_Name} > /dev/null
    then
        tmux kill-session -t ${Bot_Name}
        main
        exit
    else
        ${dialog_whiptail} --msgbox "${Bot_Name} [未启动]" 8 50
        main
        exit
    fi
elif [[ "$1" == restart ]];then
    if tmux ls | grep -q ${Bot_Name} > /dev/null
    then
        tmux kill-session -t ${Bot_Name}
        tmux new -s ${Bot_Name} "bh ${Bot_Name} n"
        main
        exit
    else
        ${dialog_whiptail} --msgbox "${Bot_Name} [未启动]" 8 50
        main
        exit
    fi
elif [[ "$1" == login ]];then
    QQ=$(${dialog_whiptail} --title "白狐-BOT" --inputbox "请输入您的机器人QQ号" 10 30 3>&1 1>&2 2>&3)
    password=$(${dialog_whiptail} --title "白狐-BOT" --inputbox "请输入您的机器人QQ密码" 10 30 3>&1 1>&2 2>&3)
    ${dialog_whiptail} --title "请确认账号和密码" --yesno "\nQQ号: ${QQ} \n密码: ${password}" 10 30
    feedback=$?
    if [[ ${feedback} == "1" ]];then
        main
        exit
    fi
    if [ ! -e config/config/qq.yaml ];then
        ${dialog_whiptail} --title "白狐-BOT" --msgbox "账密文件不存在" 8 40
        main
        exit
    fi
    file=config/config/qq.yaml
    old_QQ=$(grep -w "qq:" ${file} | sed 's/qq://g')
    if [ -z "${old_QQ}" ]; then
        echo -en ${red}读取失败 回车返回${background};read
        main
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
elif [[ "$1" == qsign ]];then
    API=$(${dialog_whiptail} --title "白狐-BOT" --inputbox "请输入您的签名服务器API" 10 50 3>&1 1>&2 2>&3)
    feedback=$?
    if [[ ${feedback} == "1" ]];then
        main
        exit
    fi
    file=config/config/bot.yaml
    if [ ! -e config/config/bot.yaml ];then
        ${dialog_whiptail} --title "白狐-BOT" --msgbox "配置文件不存在" 8 40
        main
        exit
    fi
    old_qsign=$(grep sign_api_addr ${file} | sed 's/sign_api_addr: //g')
    if [ -z "${old_qsign}" ]; then
        echo -en ${red}读取失败 回车返回${background};read
        main
        exit
    fi
    sed -i "s#${old_qsign}#sign_api_addr: ${API}#g" config/config/bot.yaml
    API=$(grep sign_api_addr config/config/bot.yaml)
    API=$(echo ${API} | sed "s/sign_api_addr: //g")
    echo -e ${cyan}您的API链接已修改为 ${green}${API}${background}
elif [[ "$1" == delete ]];then
    echo -e ${yellow}是否删除${red}${Bot_Name}${cyan}[N/y] ${background};read -p "" num
    case $num in
    Y|y)
        echo -e ${red}3${background}
        sleep 1
        echo -e ${red}2${background}
        sleep 1
        echo -e ${red}1${background}
        sleep 1
        echo -e ${red}正在删除${Bot_Name}${background}
        rm -rf ~/${Bot_Name} > /dev/null
        rm -rf ~/${Bot_Name} > /dev/null
        echo -en ${cyan}删除完成 回车返回${background};read
    ;;
        n|N)
        echo -en ${cyan}回车返回${background};read
        main
        exit
    ;;
    *)
        echo -en ${red}输入错误${cyan}回车返回${background};read
        main
        exit
    ;;
    esac
fi
}

function git_update(){
cd ${Bot_Path}
git_pull(){
echo -e ${yellow}正在更新 ${Name}${background}
if ! git pull
then
    echo -e ${red}${Name}更新失败 ${yellow}是否强制更新 [Y/N]${background};read YN
    if [[ ${YN} == "Y|y" ]];then
        remote=$(grep 'remote =' .git/config | sed 's/remote =//g')
        remote=$(echo ${remote})
        branch=$(grep branch .git/config | sed "s/\[branch \"//g" | sed 's/"//g' | sed "s/\]//g")
        branch=$(echo ${branch})
        git fetch --all
        git reset --hard ${remote}/${branch}
        git_pull
    fi
fi
}
Name=${Bot_Name}
git_pull
for folder in $(ls -I example -I bin -I other -I system plugins)
do
    if [ -d plugins/${folder}/.git ];then
        cd plugins/${folder}
        Name=${folder}
        git_pull
        cd ../../
    fi
done
}

function configure_file(){
micro_yaml(){
file=config/config/"$1"
if [ ! -e config/config/"$1" ];then
    ${dialog_whiptail} --title "白狐-BOT" --msgbox "配置文件不存在" 8 40
    main
    exit
fi
micro ${file}
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

function Fix_Error(){
Number=$(${dialog_whiptail} \
--title "白狐 QQ群:705226976" \
--menu "${Bot_Name}管理" \
23 35 15 \
"1" "降级Puppeteer" \
"2" "修复浏览器错误" \
"3" "检查软件包依赖" \
"4" "dpkg依赖包错误" \
"5" "dpkg安装被中断" \
"6" "无法锁定数据库" \
3>&1 1>&2 2>&3)
if [[ ${Number} == "1" ]];then
    echo -e ${yellow}正在修复${background}
    echo "Y" | pnpm install
    echo "Y" | pnpm install puppeteer@19.0.0 -w
elif [[ ${Number} == "2" ]];then
    file="config/config/bot.yaml"
    old_chromium_path=$(grep chromium_path ${file})
    new_chromium_path=$(which chromium || which chromium-browser)
    if [ -z "${new_chromium_path}" ];then
        echo -en ${red}未安装浏览器${background}
        exit
    fi
    sed -i "s|${old_chromium_path}|chromium_path: ${new_chromium_path}|g" ${file}
    echo -e ${cyan}写入完成${background}
elif [[ ${Number} == "3" ]];then
    echo -e ${yellow}正在修复${background}
    if ! bash <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/BOT_INSTALL.sh);then
        echo -e ${red}软件包修复出错${background}
        exit
    fi
elif [[ ${Number} == "4" ]];then
    if grep -q -E -i "Debian|Ubuntu|Kali" /etc/os-release && [ -x /usr/bin/apt ]
    then
        echo -e ${yellow}正在修复${background}
        apt update -y
        apt --fix-broken -y install
        dpkg --configure -a
        apt-get --reinstall install
    else
        echo -e ${red}您不是debian系Linux发行版${background}
        exit
    fi
elif [[ ${Number} == "5" ]];then
    if grep -q -E -i "Debian|Ubuntu|Kali" /etc/os-release && [ -x /usr/bin/apt ]
    then
        echo -e ${yellow}正在修复${background}
        rm -rf /var/lib/dpkg/lock
        rm -rf /var/lib/apt/lists/lock
        rm -rf /var/cache/apt/archives/lock
        dpkg –configure -a
        apt update -y
        apt-get update -y
    else
        echo -e ${red}您不是debian系Linux发行版${background}
        exit
    fi
elif [[ ${Number} == "6" ]];then
    echo -e ${yellow}正在修复${background}
    if grep -q -E -i Arch /etc/issue && [ -x /usr/bin/pacman ]
    then
        rm /var/lib/pacman/db.lck
        pacman -Syu --noconfirm
    else
        echo -e ${red}您不是ArchLinux发行版${background}
        exit
    fi
else
    return
fi
}

function main(){
Number=$(${dialog_whiptail} \
--title "白狐 QQ群:705226976" \
--menu "${Bot_Name}管理" \
23 35 15 \
"1" "打开窗口" \
"2" "启动运行" \
"3" "停止运行" \
"4" "重新启动" \
"5" "打开日志" \
"6" "插件管理" \
"7" "全部更新" \
"8" "重新登陆" \
"9" "前台启动" \
"10" "填写签名" \
"11" "配置文件" \
"12" "报错修复" \
"A" "我要卸崽" \
"0" "返回" \
3>&1 1>&2 2>&3)
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
    pnpm run log
    main
    exit
elif [[ ${Number} == "6" ]];then
    bash <(curl -sL https://gitee.com/baihu433/Ubuntu-Yunzai/raw/master/plug-in.sh)
    main
    exit
elif [[ ${Number} == "7" ]];then
    git_update
    echo -en ${cyan}回车返回${background};read
    main
    exit
elif [[ ${Number} == "8" ]];then
    BOT login
    echo -en ${cyan}回车返回${background};read
    main
    exit
elif [[ ${Number} == "9" ]];then
    bh ${Bot_Name} n
    echo -en ${cyan}回车返回${background};read
    main
    exit
elif [[ ${Number} == "10" ]];then
    BOT qsign
    echo -en ${cyan}回车返回${background};read
    main
    exit
elif [[ ${Number} == "11" ]];then
    configure_file
    echo -en ${cyan}回车返回${background};read
    main
    exit
elif [[ ${Number} == "12" ]];then
    Fix_Error
    echo -en ${cyan}执行完成 回车返回${background};read
    main
    exit
elif [[ ${Number} == "A" ]];then
    BOT delete
else
    return
fi
}

function install_Bot(){
if (${dialog_whiptail} --title "白狐" \
  --yes-button "Gitee" \
  --no-button "Github" \
  --yesno "请选择${Bot_Name}的下载服务器\n国内用户建议选择Gitee" 13 40)
  then
    if ! git clone --depth=1 ${Gitee} ~/${Bot_Name};then
      echo -e ${red} 克隆失败 ${cyan}试试Github ${background}
      exit
    fi
  else
    if ! git clone --depth=1 ${Github} ~/${Bot_Name};then
      echo -e ${red} 克隆失败 ${cyan}试试Gitee ${background}
      exit
    fi
fi
} #install_Yunzai_Bot

function install_Miao_Plugin(){
if (${dialog_whiptail} --title "白狐" \
--yes-button "Gitee" \
--no-button "Github" \
--yesno "请选择的miao-plugin下载服务器\n国内用户建议选择Gitee" 13 40)
  then
    if ! git clone --depth=1 https://gitee.com/yoimiya-kokomi/miao-plugin.git ~/${Bot_Name}/plugins/miao-plugin
    then
      echo -e ${red} 克隆失败 ${cyan}试试Github ${background}
      exit
    fi
  else
    if ! git clone --depth=1 https://github.com/yoimiya-kokomi/miao-plugin.git ~/${Bot_Name}/plugins/miao-plugin
    then
      echo -e ${red} 克隆失败 ${cyan}试试Gitee ${background}
      exit
    fi
fi
} #install_Miao_Plugin

function install_Genshin(){
if (${dialog_whiptail} --title "白狐" \
--yes-button "Gitee" \
--no-button "Github" \
--yesno "请选择的Genshin下载服务器\n国内用户建议选择Gitee" 13 40)
  then
    if ! git clone --depth=1 https://gitee.com/TimeRainStarSky/Yunzai-genshin ~/${Bot_Name}/plugins/genshin
    then
      echo -e ${red} 克隆失败 ${cyan}试试Github ${background}
      exit
    fi
  else
    if ! git clone --depth=1 https://github.com/TimeRainStarSky/Yunzai-genshin ~/${Bot_Name}/plugins/genshin
    then
      echo -e ${red} 克隆失败 ${cyan}试试Gitee ${background}
      exit
    fi
fi
} #install_Genshin

function qsign_server(){
if [ ! -d $HOME/QSignServer ];then
    if (${dialog_whiptail} --title "白狐" \
       --yes-button "马上部署" \
       --no-button "暂不部署" \
       --yesno "是否部署本地签名服务器?" 10 50)
       then
           export install_QSignServer=true
           URL="https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/QSignServer3.0.sh"
           bash <(curl -sL ${URL})
    fi
fi
}

function Git_BOT(){
PACKAGE="https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/BOT-PACKAGE.sh"
if [ ${Bot_Name} == "Yunzai|Yunzai-Bot" ];then
    if [ ! -e ~/${Bot_Name}/package.json ];then
        install_Bot
    fi
    if [ ! -d ~/${Bot_Name}/node_modules ];then
        cd ~/${Bot_Name}
        bash <(curl -sL ${PACKAGE})
    fi
    if [ ! -d ~/QSignServer ];then
        qsign_server
    fi
    Bot_Path
elif [ ${Bot_Name} == "Miao-Yunzai" ];then
    if [ ! -e ~/${Bot_Name}/package.json ];then
        install_Bot
    fi
    if [ ! -e ~/${Bot_Name}/plugins/miao-plugin/index.js ];then
        install_Miao_Plugin
    fi
    if [ ! -d ~/${Bot_Name}/node_modules ];then
        cd ~/${Bot_Name}
        bash <(curl -sL ${PACKAGE})
    fi
    if [ ! -d ~/QSignServer ];then
        qsign_server
    fi
    Bot_Path
elif [ ${Bot_Name} == "TRSS-Yunzai" ];then
    if [ ! -e ~/${Bot_Name}/package.json ];then
        install_Bot
    fi
    if [ ! -e ~/${Bot_Name}/plugins/miao-plugin/index.js ];then
        install_Miao_Plugin
    fi
    if [ ! -e ~/${Bot_Name}/plugins/genshin/index.js ];then
        install_Genshin
    fi
    if [ ! -d ~/${Bot_Name}/node_modules ];then
        cd ~/${Bot_Name}
        bash <(curl -sL ${PACKAGE})
    fi
    if [ ! -d ~/QSignServer ];then
        qsign_server
    fi
    Bot_Path
fi
}

function BOT_INSTALL(){
if ! bash <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/BOT_INSTALL.sh)
    then
        echo -e ${red}软件包安装出错${background}
        exit
fi
Git_BOT
}

function Bot_Path(){
if [ -d "/root/${Bot_Name}/node_modules" ];then
    export Bot_Path="/root/${Bot_Name}"
    cd ${Bot_Path}
    main
elif [ -d "/root/.fox@bot/${Bot_Name}/node_modules" ];then
    export Bot_Path="/root/.fox@bot/${Bot_Name}"
    cd ${Bot_Path}
    main
elif [ -d "/home/lighthouse/ubuntu/${Bot_Name}/node_modules" ];then
    export Bot_Path="/home/lighthouse/ubuntu/${Bot_Name}"
    cd ${Bot_Path}
    main
elif [ -d "/home/lighthouse/centos/${Bot_Name}/node_modules" ];then
    export Bot_Path="/home/lighthouse/centos/${Bot_Name}"
    cd ${Bot_Path}
    main
elif [ -d "/home/lighthouse/debian/${Bot_Name}/node_modules" ];then
    export Bot_Path="/home/lighthouse/debian/${Bot_Name}"
    cd ${Bot_Path}
    main
elif [ -d "/root/TRSS_AllBot/${Bot_Name}/node_modules" ];then
    export Bot_Path="/root/TRSS_AllBot/${Bot_Name}"
    cd ${Bot_Path}
    main
else
    if (${dialog_whiptail} --title "白狐-Script" \
       --yes-button "安装" \
       --no-button "取消" \
       --yesno "未能找到${Bot_Name}根目录 \n请问是否立刻安装${Bot_Name}?" 10 50)
       then
           BOT_INSTALL
    fi
fi
}

function feedback(){
if [ ! ${feedback} == "0" ];then
    exit
fi
}

function master(){
Number=$(${dialog_whiptail} \
--title "白狐 QQ群:705226976" \
--menu "请选择bot" \
20 38 10 \
"1" "Yunzai[icqq版]" \
"2" "Miao-Yunzai" \
"3" "TRSS-Yunzai" \
"4" "签名服务器管理" \
"5" "gocq-http管理" \
"6" "编辑器使用方法" \
"7" "使用自定义目录" \
"0" "退出" \
3>&1 1>&2 2>&3)
feedback=$?
feedback
if [[ ${Number} == "1" ]];then
    export Bot_Path_check=false
    if [ -d /root/TRSS_AllBot ];then
        export Bot_Name=Yunzai
    else
        export Bot_Name=Yunzai-Bot
    fi
    export Gitee=https://gitee.com/yoimiya-kokomi/Yunzai-Bot.git
    export Github=https://github.com/yoimiya-kokomi/Yunzai-Bot.git
    Bot_Path
elif [[ ${Number} == "2" ]];then
    export Bot_Path_check=false
    export Bot_Name=Miao-Yunzai
    export Gitee=https://gitee.com/yoimiya-kokomi/Miao-Yunzai.git
    export Github=https://github.com/yoimiya-kokomi/Miao-Yunzai.git
    Bot_Path
elif [[ ${Number} == "3" ]];then
    export Bot_Path_check=false
    export Bot_Name=TRSS-Yunzai
    export Gitee=https://gitee.com/TimeRainStarSky/Yunzai.git
    export Github=https://github.com/TimeRainStarSky/Yunzai.git
    Bot_Path
elif [[ ${Number} == "4" ]];then
    URL="https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/QSignServer3.0.sh"
    bash <(curl -sL ${URL})
elif [[ ${Number} == "5" ]];then
    URL="https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/Gocq-Http.sh"
    bash <(curl -sL ${URL})
elif [[ ${Number} == "6" ]];then
    echo
    echo
    echo -e ${white}==================${background}
    echo -e ${green} Ctrl + ${yellow}S  ${blue}保存${background}
    echo -e ${green} Ctrl + ${yellow}Q  ${blue}退出${background}
    echo -e ${green} Ctrl + ${yellow}C  ${blue}复制${background}
    echo -e ${green} Ctrl + ${yellow}V  ${blue}粘贴${background}
    echo -e ${green} Ctrl + ${yellow}X  ${blue}剪切${background}
    echo -e ${green} Ctrl + ${yellow}/  ${blue}注释${background}
    echo -e ${green} Ctrl + ${yellow}Z  ${blue}撤销${background}
    echo -e ${green} Ctrl + ${yellow}Y  ${blue}重做${background}
    echo -e ${green} Ctrl + ${yellow}L  ${blue}跳转指定行${background}
    echo -e ${green} Ctrl + ${yellow}F  ${blue}搜索${background}
    echo -e ${green} Ctrl + ${yellow}N  ${blue}搜索下一个${background}
    echo -e ${green} Ctrl + ${yellow}P  ${blue}搜索上一个${background}
    echo -e ${white}==================${background}
    echo -en ${cyan}回车返回${background};read
elif [[ ${Number} == "7" ]];then
    export Bot_Path=$(${dialog_whiptail} \
    --title "白狐-BOT" \
    --inputbox "请输入您BOT的根目录的绝对路径" \
    10 50 \
    3>&1 1>&2 2>&3)
    if [ ! -e ${Bot_Path}/package.json ];then
        echo -e ${red} BOT不存在 ${background}
        exit
    fi
    export Bot_Path_check=true
    export Bot_Name=$(echo ${Bot_Path} | awk -F/ '{print $NF}')
    main
    exit
elif [[ ${Number} == "0" ]];then
    exit
else
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
       master
       mainbak
   done
}
mainbak