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
export PUPPETEER_SKIP_DOWNLOAD='true'
a=0
echo -e ${yellow}正在使用pnpm安装依赖${background}
cd ~/.fox@bot/${bot_name}
pnpm config set registry https://registry.npmmirror.com
pnpm config set registry https://registry.npmmirror.com
pnpm config set node_sqlite3_binary_host_mirror https://npmmirror.com/mirrors/sqlite3
pnpm config set node_sqlite3_binary_host_mirror https://npmmirror.com/mirrors/sqlite3
until echo "Y" | pnpm install -P && echo "Y" | pnpm install
do
  echo -e ${red}依赖安装失败 ${green}正在重试${background}
  pnpm setup
  source ~/.bashrc
  a=$(($a+1))
  if [ "${a}" == "3" ];then
    echo -e ${red}错误次数过多 退出${background}
    exit 
  fi
done
pnpm uninstall puppeteer -w
pnpm install puppeteer@19.0.0 -w
if [ ! -e $HOME/.fox@bot/${bot_name}/config/config/bot.yaml ];then
    cd ~/.fox@bot/${bot_name}
    echo -en ${yellow}正在初始化${background}
    pnpm run start
    sleep 5s
    pnpm run stop
    rm -rf ~/.pm2/logs/*.log
    echo -en ${yellow}初始化完成${background}
    echo
if