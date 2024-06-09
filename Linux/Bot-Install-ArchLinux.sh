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

if ! pacman -Qs xz >/dev/null 2>&1
    then
        echo -e ${yellow}安装xz解压工具${background}
        until pacman -Syy --noconfirm --needed xz
        do
            echo -e ${red}安装失败 3秒后重试${background}
            sleep 3s
        done
fi

if ! pacman -Qs chromium >/dev/null 2>&1
    then
        echo -e ${yellow}安装chromium浏览器${background}
        until pacman -Syy --noconfirm --needed chromium
        do
            echo -e ${red}安装失败 3秒后重试${background}
            sleep 3s
        done
fi

if ! pacman -Qs ttf-dejavu >/dev/null 2>&1 && ! pacman -Qs wqy-zenhei >/dev/null 2>&1
    then
        echo -e ${yellow}安装中文字体包${background}
        until pacman -Syy --noconfirm --needed ttf-dejavu wqy-zenhei
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
    WebURL="https://mirrors.bfsu.edu.cn/nodejs-release/"
    version2=$(curl ${WebURL} | grep v18.20 | grep -oP 'href=\K[^ ]+' | sed 's|"||g' | sed 's|/||g' | tail -n 1)
    NodeJS_URL="https://registry.npmmirror.com/-/binary/node/latest-${version1}.x/node-${version2}-linux-${ARCH}.tar.xz"
elif [ "${GitMirror}" == "github.com" ]
then
    WebURL="https://nodejs.org/dist/latest-v18.x/"
    version2=$(curl ${WebURL} | grep v18.20 | grep -oP 'href=\K[^ ]+' | awk -F'"' '{print $2}' | grep pkg  | sed 's|node-||g' | sed 's|.pkg||g')
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
        version1=v18
        node_install
fi

if [ ! -x "/usr/local/bin/ffmpeg" ];then
  if [ "${GitMirror}" == "github.com" ]
  then
    if [ ! -d ffmpeg ];then
      mkdir ffmpeg
    fi
    ffmpegURL=https://johnvansickle.com/ffmpeg/releases/
    ffmpegURL=${ffmpegURL}ffmpeg-release-${ARCH2}-static.tar.xz
    wget -O ffmpeg.tar.xz -c ${ffmpegURL}
    pv ffmpeg.tar.xz | tar -Jxf - -C ffmpeg
    chmod +x ffmpeg/$(ls ffmpeg)/*
    mv -f ffmpeg/$(ls ffmpeg)/ffmpeg /usr/local/bin/ffmpeg
    mv -f ffmpeg/$(ls ffmpeg)/ffprobe /usr/local/bin/ffprobe
    rm -rf ffmpeg*
  elif [ "${GitMirror}" == "gitee.com" ]
  then
    echo -e ${yellow}安装软件 ffmpeg${background}
    ffmpeg_URL=https://registry.npmmirror.com/-/binary/ffmpeg-static/b6.0/
    wget -O ffmpeg -c ${ffmpeg_URL}/ffmpeg-linux-${ARCH1}
    wget -O ffprobe -c ${ffmpeg_URL}/ffprobe-linux-${ARCH1}
    chmod +x ffmpeg ffprobe
    mv -f ffmpeg /usr/local/bin/ffmpeg
    mv -f ffprobe /usr/local/bin/ffprobe
  fi
fi