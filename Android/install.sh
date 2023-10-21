#!/data/data/com.termux/files/usr/bin/bash
cd $HOME
if ! [ "$(uname -o)" = "Android" ]; then
	echo "看来你是大聪明 加Q群获取帮助吧 596660282"
	exit
fi
echo -e ${white}"====="${green}白狐-Script${white}"====="${background}
echo -e ${cyan}白狐 Script ${green}是完全可信的。${background}
echo -e ${cyan}白狐 Script ${yellow}不会执行任何恶意命令${background}
echo -e ${cyan}白狐 Script ${yellow}不会执行任何恶意命令${background}
echo -e ${cyan}白狐 Script ${yellow}不会执行任何恶意命令${background}
echo -e ${cyan}如果您同意安装 请输入 ${green}同意安装${background}
echo -e ${cyan}注意：同意安装即同意本项目的用户协议${background}
echo -e ${cyan}用户协议链接: ${background}
echo -e ${cyan}https://gitee.com/baihu433/Yunzai-Bot-Shell/blob/master/Manage/用户协议.txt${background}
echo -e ${white}"=========================="${background}
echo -en ${green}请输入:${background};read yn
if [  "${yn}" == "同意安装" ]
then
    echo -e ${green}3秒后开始安装${background}
    sleep 3s
else
    echo -e ${red}程序终止!! 脚本停止运行${background}
fi
folder=ubuntu-jammy

if grep -q "packages.termux.org" $PREFIX/etc/apt/sources.list
then
    echo '# The termux repository mirror from TUNA:
deb https://mirrors.bfsu.edu.cn/termux/apt/termux-main stable main' > $PREFIX/etc/apt/sources.list
    apt update -y
fi
if [ ! -x "$(command -v proot)" ];then
    apt install -y proot
fi
if [ ! -x "$(command -v pulseaudio)" ];then
    apt install -y pulseaudio
fi
if [ ! -x "$(command -v wget)" ];then
    apt install -y wget
fi
case $(uname -m) in
    arm64|aarch64)
    frame=arm64
    ;;
    amd64|x86_64)
    frame=amd64
    ;;
    *)
    echo "您的设备框架为$(dpkg --print-architecture),快让白狐做适配!!"
    exit
    ;;
esac
date=$(curl https://mirrors.bfsu.edu.cn/lxc-images/images/ubuntu/jammy/${frame}/default/ | grep 'class="link"><a href=' | tail -n 1 | grep -o 'title="[^"]*"' | awk -F'"' '{print $2}' )
if wget -O rootfs.tar.xz https://mirrors.bfsu.edu.cn/lxc-images/images/ubuntu/jammy/${frame}/default/${date}/rootfs.tar.xz


rootfs="ubuntu-rootfs.tar.xz"
if [ "${first}" != 1 ];then
		echo "下载rootfs，可能需要一段时间，取决于您的互联网速度."
		
		
    
      
    if ! curl -o ${rootfs} 
      then
      echo "下载失败 请检查网络!!"
      exit 1
    fi
    
	path=$(pwd)
	mkdir -p "${folder}"
	cd "${folder}"
	echo "开始解压rootfs"
	proot --link2symlink tar -xJf ${path}/${rootfs}||:
	cd "${path}"
fi

bin=start-ubuntu.sh
cat > ${bin} << EOM
#!/bin/bash
echo -e "Ubuntu 22.04.3 LTS"
cd \$(dirname \$0)
unset LD_PRELOAD
command="proot"
command+=" --link2symlink"
command+=" -0"
command+=" -r ubuntu"
command+=" -b /dev"
command+=" -b /proc"
command+=" -b ubuntu/root:/dev/shm"
command+=" -b /sdcard"
command+=" -w /root"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
command+=" TERM=\${TERM}"
command+=" LANG=C.UTF-8"
command+=" /bin/bash --login"
com="\$@"
if [ -z "\$1" ];then
    exec \${command}
else
    \${command} -c "\${com}"
fi
EOM
if grep -q "anonymous" ~/../usr/etc/pulse/default.pa;then
    echo "模块已存在"
else
    echo "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" >> ~/../usr/etc/pulse/default.pa
fi
echo "exit-idle-time = -1" >> ~/../usr/etc/pulse/daemon.conf
echo "autospawn = no" >> ~/../usr/etc/pulse/client.conf
echo "export PULSE_SERVER=127.0.0.1" >> ~/ubuntu/etc/profile
echo > ~/ubuntu/root/.hushlogin
sed -i "s/ports.ubuntu.com/mirrors.bfsu.edu.cn/g" ~/ubuntu/etc/apt/sources.list
rm ~/ubuntu/etc/resolv.conf > /dev/null
echo "nameserver 114.114.114.114" > ~/ubuntu/etc/resolv.conf
termux-fix-shebang ${bin}
chmod +x ${bin}
rm ${rootfs}
curl -o YZ.sh https://gitee.com/baihu433/Ubuntu-Yunzai/raw/master/YZ.sh
mv YZ.sh ~/ubuntu/root/YZ.sh
mkdir ~/ubuntu/root/.fox@bot > /dev/null
ln -sf ~/ubuntu/root/.fox@bot $HOME/fox@bot > /dev/null
echo "bash YZ.sh" >> ~/ubuntu/root/.bashrc
echo "./${bin}" > .bashrc
./${bin}