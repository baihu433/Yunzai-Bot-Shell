#!/bin/env bash
URL="https://ipinfo.io"
Address=$(curl ${URL} | sed -n 's/.*"country": "\(.*\)",.*/\1/p')
if [ "${Address}" = "CN" ]
then
  URL="https://mirrors.bfsu.edu.cn/nodejs-release/"
  URL="https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/"
  
  
  
  version=$(curl ${WebURL} | grep v18.20 | grep -oP 'href=\K[^ ]+' | sed 's|"||g' | sed 's|/||g' | tail -n 1)
  
  for DownloadURL in ${URL}
  do
    
    
    
  done
else 
  NodeMirror="github.com"
fi