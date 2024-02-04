#!/bin/env bash
URL="https://ipinfo.io"
info=$(curl ${URL} | \
       grep "country" | \
       sed 's/"country": //g' | \
       sed 's/"//g' | \
       sed 's/,//g')
if [ "${info}" == "CN" ]
then
  GitMirror="gitee.com"
else
  GitMirror="github.com"
fi