#!/bin/env bash
export red="\033[31m"
export green="\033[32m"
export yellow="\033[33m"
export blue="\033[34m"
export purple="\033[35m"
export cyan="\033[36m"
export white="\033[37m"
export background="\033[0m"

if [ -z "${GitMirror}" ];then
  URL="https://ipinfo.io"
  Address=$(curl ${URL} | sed -n 's/.*"country": "\(.*\)",.*/\1/p')
  if [ "${Address}" = "CN" ]
  then
      GitMirror="gitee.com"
  else 
      GitMirror="github.com"
  fi
fi

if ! dpkg -s xz-utils >/dev/null 2>&1
    then
        echo -e ${yellow}安装xz解压工具${background}
        until apt install -y xz-utils
        do
            echo -e ${red}安装失败 3秒后重试${background}
            sleep 3s
        done
fi

if ! dpkg -s chromium-browser >/dev/null 2>&1
    then
        echo -e ${yellow}安装chromium浏览器${background}
        until bash <(curl -sL https://gitee.com/baihu433/chromium/raw/master/chromium.sh)
        do
            echo -e ${red}安装失败 3秒后重试${background}
            sleep 3s
        done
fi

if ! dpkg -s fonts-wqy-zenhei fonts-wqy-microhei >/dev/null 2>&1
    then
        echo -e ${yellow}安装中文字体包${background}
        until apt install -y fonts-wqy*
        do
            echo -e ${red}安装失败 3秒后重试${background}
            sleep 3s
        done
fi

if [ -x "$(command -v node)" ]
then
    Nodsjs_Version=$(node -v | cut -d '.' -f1)
fi

case $(uname -m) in
    x86_64|amd64)
    ARCH=x64
;;
    arm64|aarch64)
    ARCH=arm64
;;
*)
    echo ${red}您的框架为${yellow}$(uname -m)${red},快让白狐做适配.${background}
    exit
;;
esac

function node_install(){
if [ "${GitMirror}" == "gitee.com" ]
then
    NodeJS_URL="https://registry.npmmirror.com/-/binary/node/latest-${version1}.x/node-${version2}-linux-${ARCH}.tar.xz"
elif [ "${GitMirror}" == "github.com" ]
then
    NodeJS_URL="https://nodejs.org/dist/latest-${version1}.x/node-${version2}-linux-${ARCH}.tar.xz"
fi
until wget -O node.tar.xz -c ${NodeJS_URL}
do
    if [[ ${i} -eq 3 ]]
    then
        echo -e ${red}错误次数过多 退出${background}
        exit
    fi
    i=$((${i}+1))
    echo -e ${red}安装失败 3秒后重试${background}
    sleep 3s
done
}

if ! [[ "$Nodsjs_Version" == "v16" || "$Nodsjs_Version" == "v18" ]];then
    echo -e ${yellow}安装软件 Node.JS${background}
    if awk '{print $2}' /etc/issue | grep -q -E 22.*
        then
            version1=v18
            version2=v18.19.1
            node_install
    elif awk '{print $2}' /etc/issue | grep -q -E 23.*
        then
            version1=v18
            version2=v18.19.1
            node_install
    elif awk '{print $2}' /etc/issue | grep -q -E 24.*
        then
            version1=v18
            version2=v18.19.1
            node_install
    else
            version1=v16
            version2=v16.20.2
            node_install
    fi
fi

if [ ! -x "/usr/local/bin/ffmpeg" ];then
  if [ "${GitMirror}" == "github.com" ]
  then
    if [ ! -d ffmpeg ];then
      mkdir ffmpeg
    fi
    ffmpegURL=https://johnvansickle.com/ffmpeg/releases/
    ffmpegURL=${ffmpegURL}ffmpeg-release-${ARCH2}-static.tar.xz
    wget -O ffmpeg.tar.xz ${ffmpegURL}
    pv ffmpeg.tar.xz | tar -xf ffmpeg.tar.xz -C ffmpeg
    chmod +x ffmpeg/$(ls ffmpeg)/*
    mv -f ffmpeg/$(ls ffmpeg)/ffmpeg /usr/local/bin/ffmpeg
    mv -f ffmpeg/$(ls ffmpeg)/ffprobe /usr/local/bin/ffprobe
  elif [ "${GitMirror}" == "gitee.com" ]
  then
    echo -e ${yellow}安装软件 ffmpeg${background}
    ffmpeg_URL=https://registry.npmmirror.com/-/binary/ffmpeg-static/b6.0
    ffmpegURL=${ffmpeg_URL}/ffmpeg-linux-${ARCH1}
    ffprobeURL=${ffmpeg_URL}/ffprobe-linux-${ARCH1}
    wget -O ffmpeg ${ffmpegURL}
    wget -O ffprobe ${ffprobeURL}
    chmod +x ffmpeg ffprobe
    mv -f ffmpeg /usr/local/bin/ffmpeg
    mv -f ffprobe /usr/local/bin/ffprobe
  fi
fi