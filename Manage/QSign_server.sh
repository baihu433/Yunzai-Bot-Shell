#!/bin/env bash
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
    file1="$HOME/${Bot_Name}/config/config/bot.yaml"
    file2="$HOME/${Bot_Name}/config/config/qq.yaml"
    equipment="platform: 2"
    if [ -e ${file1} ];then
        if ! grep -q "${API}" ${file1};then
            sed -i "/ver*/d" ${file1}
            sed -i "/sign_api_addr*/d" ${file1}
            sed -i "\$a\sign_api_addr: ${API}" ${file1}
            sed -i "\$a\ver: ${version}" ${file1}
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