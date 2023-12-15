#!/usr/bin/env bash
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
function tmux_new(){
Tmux_Name="$1"
Shell_Command="$2"
tmux new -s ${Tmux_Name} -d "${Shell_Command}"
}
function tmux_attach(){
Tmux_Name="$1"
tmux attach -t ${Tmux_Name} > /dev/null 2>&1
}
function tmux_kill_session(){
Tmux_Name="$1"
tmux kill-session -t ${Tmux_Name}
}
function tmux_ls(){
Tmux_Name="$1"
tmux_windows=$(tmux ls 2>&1)
if echo ${tmux_windows} | grep -q ${Tmux_Name}
then
    return 0
else
    return 1
fi
}
function pkg(){
if [ ! -e package.json ];then
    echo -e ${red}对象错误${background}
    exit
fi
}
function run(){
if pnpm pm2 list | grep -q ${Bot_Name}
then
    pnpm pm2 stop ${Bot_Name}
    pnpm pm2 delete ${Bot_Name}
    echo -e ${red}进程停止 ${cyan}正在重启${background}
    return 0
else
    return 1
fi
if [ "${Bot_Path_check}" == "true" ];then
    pnpm run stop
    echo -e ${red}进程停止 ${cyan}正在重启${background}
    bh ${Bot_Name} n
fi
}
function help(){
echo -e ${green}===============================${background}
echo -e ${cyan} bh"        | "${blue}白狐脚本${background}
echo -e ${cyan} bh help"   | "${blue}白狐脚本帮助${background}
echo -e ${cyan} bh PI"     | "${blue}插件管理脚本${background}
echo -e ${cyan} bh SWPKG"  | "${blue}修复软件包依赖${background}
echo -e ${cyan} bh QS"     | "${blue}签名服务器管理脚本${background}
echo -e ${green}===============================${background}
echo -e ${cyan} bh yz ${blue}Yunzai-Bot根目录${background}
echo -e ${cyan} bh mz ${blue}Miao-Yunzai根目录${background}
echo -e ${cyan} bh tz ${blue}TRSS-Yunzai根目录${background}
echo -e ${green}===============================${background}
echo -e ${cyan} [对象]${white}==${yellow}[YZ/MZ/TZ/路径]${background}
echo -e ${green}===============================${background}
echo -e ${cyan} bh ${yellow}[对象] ${cyan}n "      | "${blue}前台启动${background}
echo -e ${cyan} bh ${yellow}[对象] ${cyan}start "  | "${blue}后台启动${background}
echo -e ${cyan} bh ${yellow}[对象] ${cyan}log "    | "${blue}后台日志${background}
echo -e ${cyan} bh ${yellow}[对象] ${cyan}stop "   | "${blue}停止运行${background}
echo -e ${cyan} bh ${yellow}[对象] ${cyan}login "  | "${blue}配置账号${background}
echo -e ${cyan} bh ${yellow}[对象] ${cyan}up bot " | "${blue}更新 BOT${background}
echo -e ${cyan} bh ${yellow}[对象] ${cyan}up pkg " | "${blue}更新依赖${background}
echo -e ${cyan} bh ${yellow}[对象] ${cyan}fix pkg "| "${blue}重装依赖${background}
echo -e ${green}===============================${background}
echo -e ${cyan} bh ${yellow}[对象] ${cyan}install [依赖名] ${blue}安装NPM依赖包${background}
echo -e ${cyan} bh ${yellow}[对象] ${cyan}qsign [签名服务器链接] ${blue}填写签名服务器链接${background}
echo -e ${green}===============================${background}
echo -e ${yellow} 脚本完全免费 打击倒卖 从你我做起${background}
echo -e ${green} QQ群:${cyan}狐狸窝:705226976${background}
echo -e ${green}=============================${background}
exit
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
    echo -e ${red}对象错误${background}
    exit
fi
}

function QSIGN(){
if [ -d $HOME/QSignServer/qsign119 ];then
    if [ "${Bot_Name}" == "TRSS-Yunzai" ];then
        return
    fi
    for folder in $(ls -d $HOME/QSignServer/txlib/*)
    do
        file="${folder}/config.json"
        port="$(grep -E port ${file} | awk '{print $2}' )"
        key="$(grep -E key ${file} | awk '{print $2}' | sed "s/\"//g" | sed "s/,//g" )"
        host="$(grep -E host ${file} | awk '{print $2}' | sed "s/\"//g" | sed "s/,//g" )"
    done        
    API="http://"${host}":"${port}"/sign?key="${key}
    API=$(echo ${API})
    echo -e ${cyan}您的本地签名服务器API链接: ${green}${API}${background}
    if ! curl -sL 127.0.0.1:${port} > /dev/null 2>&1
    then
        export start_QSignServer="true"
        bash <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/QSignServer.sh)
    fi
    file1="${Bot_Path}/config/config/bot.yaml"
    file2="${Bot_Path}/config/config/qq.yaml"
    equipment="platform: 2"
    if [ -e ${file1} ];then
        if ! grep -q "${API}" ${file1};then
            old_sign_api_addr=$(grep sign_api_addr ${file1})
            new_sign_api_addr="sign_api_addr: ${API}"
            sed -i "s|${old_sign_api_addr}|${new_sign_api_addr}|g" ${file1}
        fi
        if ! grep -q "ver: 8.*" ${file1};then
            old_ver=$(grep ver ${file1})
            new_ver="ver: "
            if [[ ! -z ${old_ver} ]];then
                sed -i "s|${old_ver}|${new_ver}|g" ${file1}
            fi
        fi
    fi
    if [ -e ${file2} ];then
        if ! grep -q "${equipment}" ${file2};then
            sed -i "s/$(grep platform ${file2})/${equipment}/g" ${file2}
        fi
    fi
fi
}

case "$1" in
PI)
bash <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/BOT-PlugIn.sh)
;;
QS)
bash <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/QSignServer.sh)
exit
;;
SWPKG)
bash <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/BOT_INSTALL.sh)
exit
;;
YZ|Yunzai|Yunzai-Bot)
if [ -z "${Bot_Name}" ]; then
    export Bot_Name=Yunzai-Bot
    Quick_Command="true"
fi
Bot_Path_Check
cd ${Bot_Path}
;;
MZ|Miao-Yunzai)
if [ -z "${Bot_Name}" ]; then
    export Bot_Name=Miao-Yunzai
    Quick_Command="true"
fi
Bot_Path_Check
cd ${Bot_Path}
;;
TZ|TRSS-Yunzai)
if [ -z "${Bot_Name}" ]; then
    export Bot_Name=TRSS-Yunzai
    Quick_Command="true"
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
export up="false"
;;
esac

if echo "$1" | grep -q -E "/" ;then
    if [ -e "$1"/package.json ]
    then
        cd "$1"
    else
        echo -e ${red}对象错误${background}
        exit
    fi
fi

case "$2" in
n)
pkg
Redis=$(redis-cli ping)
if ! [ "${Redis}" = "PONG" ]; then
 redis-server &
 echo
fi
QSIGN
node app
if run
then
    bh ${Bot_Name} n
else
    if [ "${Quick_Command}" == "false" ];then
        echo -en ${cyan}回车退出${background};read
    fi
    exit
fi
;;
start)
pkg
Redis=$(redis-cli ping)
if ! [ "${Redis}" = "PONG" ]; then
 nohup redis-server &
 echo
fi
QSIGN
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
  git pull -f
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

if ping -c 1 gitee.com > /dev/null 2>&1
    then
    up="true"
else
    up="false"
fi

if [ ! "${up}" = "false" ];then
    old_version="0.8.6"
    
    URL=https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/version
    version_date=$(curl -sL ${URL})
    new_version="$(echo ${version_date} | grep version | awk '{print $2}' )"
    
    if [ "${new_version}" != "${old_version}" ];then
        echo -e ${cyan}正在更新${background}
        rm /usr/local/bin/bh
        curl -o bh https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/Mian.sh
        mv bh /usr/local/bin/bh
        chmod +x /usr/local/bin/bh
        if ! bh help > /dev/null 2>&1;then
            echo -e ${yellow} - ${red}更新失败${background}
            echo -e ${yellow} - ${cyan}正在尝试解决${background}
            old_bh_bash='#!/bin/env bash'
            new_bh_bash=$(command -v bash)
            sed -i "s|${old_bh_bash}|#!${new_bh_bash}|g" /usr/local/bin/bh
            
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
function tmux_gauge(){
i=0
Tmux_Name="$1"
{
until tmux_ls ${Tmux_Name} 2>&1 | grep -q ${Tmux_Name}
do
    i=$((${i}+1))
    sleep 0.05s
    echo -e ${i}
    if [[ "${i}" == "100" ]];then
        echo -e "错误: 启动失败"
        return 1
    fi
done
} | ${dialog_whiptail} --title "白狐-script" --gauge "正在"${Start_Stop_Restart}" ${Bot_Name}" 8 50 0
}

bot_tmux_start(){
tmux_new ${Tmux_Window_Name} "bh ${Tmux_Window_Name} n" > /dev/null 2>&1
tmux_gauge ${Tmux_Window_Name}
}
bot_tmux_attach_log(){
if ! tmux attach -t ${Tmux_Window_Name} > /dev/null 2>&1;then
    tmux_windows_attach=$(tmux attach -t ${Tmux_Window_Name} 2>&1)
    ${dialog_whiptail} --msgbox "${Bot_Name}打开错误 \n错误原因:${tmux_windows_attach}" 8 50
fi
}
bot_tmux_attach(){
if (${dialog_whiptail} --yesno "${Bot_Name} [已"${Start_Stop_Restart}"] \n是否打开${Bot_Name}窗口" 8 50)
then
    bot_tmux_attach_log
fi
}
if [[ $1 == log ]];then
    if tmux_ls ${Tmux_Window_Name}
    then
        bot_tmux_attach_log
    else
        if (${dialog_whiptail} --yesno "${Bot_Name} [未启动] \n是否立刻启动${Bot_Name}" 8 50)
        then
            export Start_Stop_Restart="启动"
            bot_tmux_start
        fi
    fi
elif [[ $1 == start ]];then
    if ! tmux_ls ${Tmux_Window_Name}
    then
        export Start_Stop_Restart="启动"
        bot_tmux_start
        bot_tmux_attach
    else
        bot_tmux_attach
    fi
elif [[ $1 == stop ]];then
    if tmux_ls ${Tmux_Window_Name}
    then
        tmux_kill_session ${Tmux_Window_Name}
        ${dialog_whiptail} --yesno "${Bot_Name} [已停止]" 8 50
    else
        ${dialog_whiptail} --yesno "${Bot_Name} [未启动] \n无需停止${Bot_Name}" 8 50
    fi
elif [[ $1 == restart ]];then
    if tmux_ls ${Tmux_Window_Name}
    then
        tmux_kill_session ${Tmux_Window_Name}
        export Start_Stop_Restart="重启"
        bot_tmux_start
        bot_tmux_attach
    else
        ${dialog_whiptail} --msgbox "${Bot_Name} [未启动]" 8 50
    fi
elif [[ $1 == login ]];then
    QQ=$(${dialog_whiptail} --title "白狐-BOT" --inputbox "请输入您的机器人QQ号" 10 30 3>&1 1>&2 2>&3)
    password=$(${dialog_whiptail} --title "白狐-BOT" --inputbox "请输入您的机器人QQ密码" 10 30 3>&1 1>&2 2>&3)
    ${dialog_whiptail} --title "请确认账号和密码" --yesno "\nQQ号: ${QQ} \n密码: ${password}" 10 30
    feedback=$?
    if [[ ${feedback} == "1" ]];then
        main
        exit
    fi
    platform=$(${dialog_whiptail} \
    --title "白狐 QQ群:705226976" \
    --menu "请选择您的登录设备" \
    15 32 5 \
    "1" "安卓手机 " \
    "2" "aPad " \
    "3" "安卓手表 " \
    "4" "MacOS " \
    "5" "iPad" \
    "6" "Tim" \
    3>&1 1>&2 2>&3)
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
    old_QQ=$(grep -w "qq:" ${file})
    old_QQ=$(echo ${old_QQ})
    sed -i "s/${old_QQ}/qq: ${QQ}/g" ${file}
    old_password=$(grep -w "password:" ${file})
    old_password=$(echo ${old_password})
    sed -i "s/${old_password}/password: ${password}/g" ${file}
    old_platform=$(grep -w "platform:" ${file})
    old_platform=$(echo ${old_platform})
    sed -i "s/${old_platform}/platform: ${platform}/g" ${file}
    echo -en ${green}更换成功${cyan}回车返回${background};read
elif [[ $1 == qsign ]];then
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
    old_sign_api_addr=$(grep sign_api_addr ${file})
    new_sign_api_addr="sign_api_addr: ${API}"
    sed -i "s|${old_sign_api_addr}|${new_sign_api_addr}|g" ${file}
    API=$(grep sign_api_addr ${file})
    API=$(echo ${API} | sed "s/sign_api_addr: //g")
    echo -e ${cyan}您的API链接已修改为 ${green}${API}${background}
    echo
    echo -en ${cyan}回车返回${background};read
elif [[ $1 == delete ]];then
    echo -e ${yellow}是否删除${red}${Bot_Name}${cyan}[N/y] ${background};read -p "" YN
    case $YN in
    Y|y)
        echo -e ${red}3${background}
        sleep 1
        echo -e ${red}2${background}
        sleep 1
        echo -e ${red}1${background}
        sleep 1
        echo -e ${red}正在删除${Bot_Name}${background}
        rm -rf ${Bot_Path} > /dev/null 2>&1
        rm -rf ${Bot_Path} > /dev/null 2>&1
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
if ! git pull -f
then
    echo -en ${red}${Name}更新失败 ${yellow}是否强制更新 [Y/N]${background};read YN
    case ${YN} in
    Y|y)
        remote=$(grep 'remote =' .git/config | sed 's/remote =//g')
        remote=$(echo ${remote})
        branch=$(grep branch .git/config | sed "s/\[branch \"//g" | sed 's/"//g' | sed "s/\]//g")
        branch=$(echo ${branch})
        git fetch --all
        git reset --hard ${remote}/${branch}
        git_pull
    esac
fi
}
Name=${Bot_Name}
git_pull
for folder in $(ls plugins)
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
Number=$(${dialog_whiptail} \
--title "白狐 QQ群:705226976" \
--menu "请选择您的编辑器" \
15 32 5 \
1 "micro " \
2 "vim " \
3 "nano " \
4 "emacs " \
0 "返回" \
3>&1 1>&2 2>&3)
case ${Number} in
1)
    Editor=micro
    ;;
2)
    Editor=vim
    ;;
3)
    Editor=nano
    ;;
4)
    Editor=emacs
    ;;
0)
    main
    exit
esac
if [ ! -x "$(command -v ${Editor})" ];then
    ${dialog_whiptail} --title "白狐-BOT" --msgbox "未安装${Editor}编辑器" 8 40
    main
    exit
fi
Editor_yaml(){
file="config/config/$1"
if [ ! -e config/config/"$1" ];then
    ${dialog_whiptail} --title "白狐-BOT" --msgbox "配置文件不存在" 8 40
    main
    exit
fi
${Editor} ${file}
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
if [ "${Number}" == "1" ];then
    Editor_yaml bot.yaml
elif [ "${Number}" == "2" ];then
    Editor_yaml group.yaml
elif [ "${Number}" == "3" ];then
    Editor_yaml notice.yaml
elif [ "${Number}" == "4" ];then
    Editor_yaml other.yaml
elif [ "${Number}" == "5" ];then
    Editor_yaml qq.yaml
elif [ "${Number}" == "6" ];then
    Editor_yaml redis.yaml
elif [ "${Number}" == "7" ];then
    Editor_yaml renderer.yaml
elif [ "${Number}" == "0" ];then
    main
    exit
else
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
"7" "更换饼干Yunzai" \
"8" "修复监听错误" \
3>&1 1>&2 2>&3)
if [ "${Number}" == "1" ];then
    echo -e ${yellow}正在修复${background}
    echo "Y" | pnpm install
    echo "Y" | pnpm install puppeteer@19.0.0 -w
    echo -en ${cyan}回车返回${background};read
elif [ "${Number}" == "2" ];then
    file="config/config/bot.yaml"
    old_chromium_path=$(grep chromium_path ${file})
    if /bin/chromium-browser > /dev/null 2>&1
    then
        new_chromium_path=/bin/chromium-browser
        echo 1
    elif /usr/bin/chromium-browser > /dev/null 2>&1
    then
        new_chromium_path=/usr/bin/chromium-browser
        echo 2
    else
        new_chromium_path=$(command -v chromium || command -v chromium-browser)
    fi
    if [ -z "${new_chromium_path}" ];then
        echo -en ${red}未安装浏览器${background}
        exit
    fi
    sed -i "s|${old_chromium_path}|chromium_path: ${new_chromium_path}|g" ${file}
    echo -e ${cyan}写入完成${background}
    echo -en ${cyan}回车返回${background};read
elif [ "${Number}" == "3" ];then
    echo -e ${yellow}正在修复${background}
    if ! bash <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/BOT_INSTALL.sh);then
        echo -e ${red}软件包修复出错${background}
        exit
    fi
    echo -en ${cyan}回车返回${background};read
elif [ "${Number}" == "4" ];then
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
    echo -en ${cyan}回车返回${background};read
elif [ "${Number}" == "5" ];then
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
    echo -en ${cyan}回车返回${background};read
elif [ "${Number}" == "6" ];then
    echo -e ${yellow}正在修复${background}
    if grep -q -E -i Arch /etc/issue && [ -x /usr/bin/pacman ]
    then
        rm /var/lib/pacman/db.lck
        pacman -Syu --noconfirm
    else
        echo -e ${red}您不是ArchLinux发行版${background}
        exit
    fi
    echo -en ${cyan}回车返回${background};read
elif [ "${Number}" == "7" ];then
    if grep -q 'Yunzai-Bot' .git/config
    then
        echo -e ${yellow}正在切换${background}
        git remote rm origin
        git remote add origin https://gitee.com/Yummy-cookie/Yunzai-Bot.git
        git remote set-url origin https://gitee.com/Yummy-cookie/Yunzai-Bot.git
        git fetch --all
        git branch --set-upstream-to=origin/master master
        git pull --rebase -f
        pnpm update
        pnpm install -P
        echo -e ${yellow}切换完成${background}
    else
        echo -e ${cyan}您不是Yunzai-Bot ${red}无需切换${background}
        exit
    fi
elif [ "${Number}" == "8" ];then
    echo -e ${cyan}正在删除依赖${background}
    rm -rf node_modules > /dev/null 2>&1
    rm -rf node_modules > /dev/null 2>&1
    URL="https://registry.npmmirror.com"
    sqlite3_URL="https://npmmirror.com/mirrors/sqlite3"
    echo -e ${cyan}正在换源${background}
    pnpm config set registry ${URL}
    pnpm config set registry ${URL}
    pnpm config set node_sqlite3_binary_host_mirror ${sqlite3_URL}
    pnpm config set node_sqlite3_binary_host_mirror ${sqlite3_URL}
    echo -e ${cyan}正在安装依赖${background}
    echo Y | pnpm install
    echo Y | pnpm install
    echo -en ${cyan}回车返回${background};read
else
    return
fi
}

function main(){
rm -rf *.log > /dev/null 2>&1
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
if [ "${Number}" == "1" ];then
    BOT log
    main
    exit
elif [ "${Number}" == "2" ];then
    BOT start
    main
    exit
elif [ "${Number}" == "3" ];then
    BOT stop
    main
    exit
elif [ "${Number}" == "4" ];then
    BOT restart
    main
    exit
elif [ "${Number}" == "5" ];then
    pnpm run log
    main
    exit
elif [ "${Number}" == "6" ];then
    bash <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/BOT-PlugIn.sh)
    main
    exit
elif [ "${Number}" == "7" ];then
    git_update
    echo -en ${cyan}回车返回${background};read
    main
    exit
elif [ "${Number}" == "8" ];then
    BOT login
    main
    exit
elif [ "${Number}" == "9" ];then
    bh ${Bot_Name} n
    echo -en ${cyan}回车返回${background};read
    main
    exit
elif [ "${Number}" == "10" ];then
    BOT qsign
    echo -en ${cyan}回车返回${background};read
    main
    exit
elif [ "${Number}" == "11" ];then
    configure_file
    echo -en ${cyan}回车返回${background};read
    main
    exit
elif [ "${Number}" == "12" ];then
    Fix_Error
    main
    exit
elif [ "${Number}" == "A" ];then
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
           URL="https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/QSignServer.sh"
           bash <(curl -sL ${URL})
    fi
fi
}

function Git_BOT(){
PACKAGE="https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/BOT-PACKAGE.sh"
if [ "${Bot_Name}" == "Yunzai" ] || [ "${Bot_Name}" == "Yunzai-Bot" ];then
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
elif [ "${Bot_Name}" == "Miao-Yunzai" ];then
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
elif [ "${Bot_Name}" == "TRSS-Yunzai" ];then
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
export Quick_Command="true"
export Bot_Path_check="false"
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
"1" "Yunzai[饼干版]" \
"2" "Miao-Yunzai" \
"3" "TRSS-Yunzai" \
"4" "签名服务器管理" \
"5" "使用自定义目录" \
"0" "退出" \
3>&1 1>&2 2>&3)
feedback=$?
feedback
if [ "${Number}" == "1" ];then
    if [ -d /root/TRSS_AllBot ];then
        export Bot_Name=Yunzai
        export Tmux_Window_Name=YZ
    else
        export Bot_Name=Yunzai-Bot
        export Tmux_Window_Name=YZ
    fi
    export Gitee=https://gitee.com/Yummy-cookie/Yunzai-Bot
    export Github=https://github.com/Yummy-cookie/Yunzai-Bot
    Bot_Path
elif [ "${Number}" == "2" ];then
    export Bot_Name=Miao-Yunzai
    export Tmux_Window_Name=MZ
    export Gitee=https://gitee.com/yoimiya-kokomi/Miao-Yunzai.git
    export Github=https://github.com/yoimiya-kokomi/Miao-Yunzai.git
    Bot_Path
elif [ "${Number}" == "3" ];then
    export Bot_Name=TRSS-Yunzai
    export Tmux_Window_Name=TZ
    export Gitee=https://gitee.com/TimeRainStarSky/Yunzai.git
    export Github=https://github.com/TimeRainStarSky/Yunzai.git
    Bot_Path
elif [ "${Number}" == "4" ];then
    URL="https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/QSignServer.sh"
    bash <(curl -sL ${URL})
elif [ "${Number}" == "5" ];then
    export Bot_Path=$(${dialog_whiptail} \
    --title "白狐-BOT" \
    --inputbox "请输入您BOT的根目录的绝对路径" \
    10 50 \
    3>&1 1>&2 2>&3)
    if [ ! -e ${Bot_Path}/package.json ];then
        echo -e ${red} BOT不存在 ${background}
        exit
    fi
    export Bot_Path_check="true"
    export Bot_Name=$(echo ${Bot_Path} | awk -F/ '{print $NF}')
    main
    exit
elif [ "${Number}" == "0" ];then
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