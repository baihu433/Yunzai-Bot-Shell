#!/usr/bin/bash
stv=v0.7.0
srv=22
PATHG=$(uname -o)
updatedt(){
    date_t=`date +"%D"`
if ! grep -q $date_t ".date_tmp.log" 2>/dev/null; then
        echo $date_t >>.date_tmp.log 2>&1
echo 软件源获取更新
sleep 1
apt update
echo 检查基础依赖
apt install curl git neofetch wget aria2c -y
fi
clear
upytu
clear
readmek
clear
if [ $gitbut = 1 ]
     then 
     echo 您的版本需要更新
     echo 建议您立刻更新
     echo 输入update即可立即更新
     fi
}
upytu(){
#git clone https://gitee.com/yudezeng/proot_proc >>l.log
echo 正在检查本脚本更新
echo 正在从服务器获取最新版本号
mkdir proot_proc
wget -o l.log -O proot_proc/version  https://gitee.com/yudezeng/proot_proc/raw/master/version
wget -o l.log -O proot_proc/ord  https://gitee.com/yudezeng/proot_proc/raw/master/ord
version=$(cat proot_proc/version)
larv=$(cat proot_proc/ord)
sleep 0.6
echo 检测到最新版本为version $version
sleep 0.6
echo 当前使用的版本为$stv
if [ $larv -gt $srv ]
then
gitbut=1
echo 当前版本需要升级
echo 您可以在主菜单手动更新
else
gitbut=0
echo 当前使用的版本为最新版本
echo 将无需升级
fi
rm -rf proot_proc
sleep 1
     
}
readmek(){
echo version v0.6.9
echo 修改了部分界面布局
echo 修复了已知bug
echo 在ubuntu/debian Linux系统上面本脚本添加了安装浏览器功能
echo 修改了获取更新的方式
echo
echo version v0.6.8
echo Arch Linux 安装结束后已经可以自动配置中文和软件源地址
echo 优化了对ubuntu/debian的支持
echo 添加了adb工具箱
echo 
echo version v0.7.0
echo 修复了已知bug
echo 优化了启动顺序
echo 优化了启动时间
echo "如果在没有安装完毕依赖的情况下，请删除.date*"
echo 再重新运行此脚本
echo 在termux端中 
echo 下载此脚本后，您可以执行yutoolsw -h
echo "会有惊喜(・ω< )★"
echo
sleep 0.6
echo 请阅读以上内容
echo 将在1秒后加载功能
sleep 1
}
ARCH_(){
	case $(uname -m) in
		arm64|aarch*)
			echo "arm64"
			ARCH=arm64 ;;
		x86_64|amd64) 
			echo "amd64"
			ARCH=amd64 
			mkdir .x
			;;
		i*86|x86)
			echo "i386"
			ARCH=i386 
			mkdir .x 
			;;
		armv7*|armv8l|arm|armhf)
			echo "armhf"
			ARCH=armhf ;;
		armv6*|armv5*|armel)
			echo "armel"
			ARCH=armel ;;
		ppc*)
			echo "ppc64el"
			ARCH=ppc64el ;;
		s390*)
			echo "s390x"
			ARCH=s390x ;;
		*)echo 
esac
}
ARCH_qp=$(ARCH_)
#####################
#install linux containers
SYS_SELECT() {
	echo -e "请选择系统
	1) debian
	2) ubuntu
	3) kali
	4) centos
	5) arch
	6) fedora
	7) 从本地安装
	0) 退出"
read -r -p "请选择:" input
case $input in
	1) echo -e "选择debian哪个版本
		1) buster
		2) bullseye
		3) sid
		9) 返回主目录
		0) 退出"
		name=debian
		mkdir debian
		TDR=debian
		read -r -p "请选择:" input
		case $input in
			1) echo "即将下载安装debian(buster)"
		sys_name=buster
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/debian/buster/$ARCH/default/" ;;
	2) echo "即将下载安装debian(bullseye)"        
		sys_name=bullseye  
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/debian/bullseye/$ARCH/default/" ;;
	3) echo "即将下载安装debian(sid)"
		sys_name=sid
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/debian/sid/$ARCH/default/" ;;
		9) MAIN ;;
		0) echo -e "\nexit"
			sleep 1                           
			exit 0 ;;                           
	*) INVALID_INPUT                                     
		SYS_SELECT ;;
esac ;;
2) echo -e "选择ubuntu哪个版本                            
	1) bionic
	2) focal
	3) impish
	0) 退出"                                
	name=ubuntu
	mkdir ubuntu
	TDR=$APKH
	read -r -p "请选择:" input                          
	case $input in
	1) echo "即将下载安装ubuntu(bionic)"
		sys_name=bionic
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/ubuntu/bionic/$ARCH/default/" ;;
	2) echo "即将下载安装ubuntu(focal)"
		sys_name=focal
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/ubuntu/focal/$ARCH/default/" ;;
	3) echo "即将下载安装ubuntu(impish)"
		sys_name=impish
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/ubuntu/impish/$ARCH/default/" ;;
	9) MAIN ;;                         
		0) echo -e "\nexit"     
			sleep 1                               
			exit 0 ;;                         
		*) INVALID_INPUT                             
			SYS_SELECT ;;
	esac ;;
	3) echo "即将下载安装kali"
                sys_name=kali
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/kali/current/$ARCH/default/" ;;
	4) echo "即将下载安装centos"
                sys_name=centos
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/centos/9-Stream/$ARCH/default/" ;;
	5) echo "即将下载安装arch"
                sys_name=arch
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/archlinux/current/$ARCH/default/" ;;
	6) echo "即将下载安装fedora"
		sys_name=fedora       
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/fedora/33/$ARCH/default/" ;;
	7) 
	lfi
	 ;;
	0) MAIN ;;

	*) echo 没有 ;;
esac
}
#############
SYS_DOWN() {
BAGNAME="rootfs.tar.xz"
        if [ -e ${BAGNAME} ]; then
                rm -rf ${BAGNAME}
	fi
	curl -o ${BAGNAME} ${DEF_CUR}
		VERSION=`cat ${BAGNAME} | grep href | tail -n 2 | cut -d '"' -f 4 | head -n 1`
		curl -o ${BAGNAME} ${DEF_CUR}${VERSION}${BAGNAME}
		if [ $? -ne 0 ]; then
			echo -e "${RED}下载失败，请重输${RES}\n"
			MAIN
		fi
        
		#mkdir $sys_name-$AH
#tar xvf rootfs.tar.xz -C ${BAGNAME}
#echo -e "正在解压系统包"
		#tar xf ${BAGNAME} -C $sys_name-$AH 2>/dev/null
		tuip
                echo -e "$sys_name-$AH系统已下载，文件夹名为$sys_name-$AH"
}
####################
SYS_SET() {
	echo "更新DNS"
	sleep 1
	echo "127.0.0.1 localhost" > $sys_name-$AH/etc/hosts
	rm -rf $sys_name-$AH/etc/resolv.conf &&
	echo "nameserver 223.5.5.5
nameserver 223.6.6.6" >$sys_name-$AH/etc/resolv.conf
echo "设置时区"
sleep 1
	echo "export  TZ='Asia/Shanghai'" >> $sys_name-$AH/root/.bashrc
	echo 检测到你没有权限读取/proc内的所有文件
	echo 正在从git仓库中拉取伪造的文件
	echo 将自动伪造新文件
	git clone https://gitee.com/yudezeng/proot_proc.git
	sleep 1
	mkdir tmp
	echo 正在解压伪造文件
	
	tar xJf proot_proc/proc.tar.xz -C tmp 
	cp -r tmp/usr/local/etc/tmoe-linux/proot_proc tmp/
	sleep 1
	echo 复制文件
	cp -r tmp/proot_proc $sys_name-$AH/etc/proc
	sleep 1
	echo 删除缓存
	rm proot_proc tmp -rf
	if grep -q 'ubuntu' "$sys_name-$AH/etc/os-release" ; then
        touch "$sys_name-$AH/root/.hushlogin"
fi
}
####################
FIN(){
echo "写入启动脚本"
echo "为了兼容性考虑已将内核信息伪造成5.17.18-perf"
sleep 1
cat > $sys_name-$AH.sh <<- EOM
#!/bin/bash
pulseaudio --start
unset LD_PRELOAD
proot --bind=/vendor --bind=/system --bind=/data/data/com.termux/files/usr --bind=/storage --bind=/storage/self/primary:/sdcard --bind=/data/data/com.termux/files/home --bind=/data/data/com.termux/cache --bind=/data/dalvik-cache --bind=$sys_name-$AH/tmp:/dev/shm --bind=$sys_name-$AH/etc/proc/vmstat:/proc/vmstat --bind=$sys_name-$AH/etc/proc/version:/proc/version --bind=$sys_name-$AH/etc/proc/uptime:/proc/uptime --bind=$sys_name-$AH/etc/proc/stat:/proc/stat --bind=$sys_name-$AH/etc/proc/loadavg:/proc/loadavg  --bind=$sys_name-$AH/etc/proc/bus/pci/00:/proc/bus/pci/00 --bind=$sys_name-$AH/etc/proc/devices:/proc/bus/devices --bind=$sys_name-$AH/etc/proc/bus/input/devices:/proc/bus/input/devices --bind=$sys_name-$AH/etc/proc/modules:/proc/modules   --bind=/sys --bind=/proc/self/fd/2:/dev/stderr --bind=/proc/self/fd/1:/dev/stdout --bind=/proc/self/fd/0:/dev/stdin --bind=/proc/self/fd:/dev/fd --bind=/proc --bind=/dev/urandom:/dev/random --bind=/dev --root-id --cwd=/root -L --kernel-release=5.17.18-perf --sysvipc --link2symlink --kill-on-exit --rootfs=$sys_name-$AH/ /usr/bin/env -i HOME=/root LANG=zh_CN.UTF-8 TERM=xterm-256color /bin/su -l root
EOM

echo "授予启动脚本执行权限"
sleep 1
chmod +x $sys_name-$AH.sh
if [ -e ${PREFIX}/etc/bash.bashrc ]; then
	if ! grep -q 'pulseaudio' ${PREFIX}/etc/bash.bashrc; then
		sed -i "1i\pkill -9 pulseaudio" ${PREFIX}/etc/bash.bashrc
	fi
else
	sed -i "1i\pkill -9 pulseaudio" $sys_name-$AH.sh
fi
case $name in
debian|ubuntu)
case $AH in 
amd64|i*86)
AUTOFIN_
;;
arm*)
AUTOFIN
;;
*)
echo
;;
esac
;;
*)
echo
;;
esac
echo -e "现在可以执行 ./$sys_name-$AH.sh 运行 $sys_name-$AH系统"
if [ $sys_name = arch ]
then
echo 更换软件源地址
echo 获取文件
case $AH in
arm*)
apq=arm
wget -o l.log -O pacman-arm.tar.xz https://pan.xb6868.com/api/v3/file/source/135/pacman.tar.xz?sign=EY4yY4V7e537I7Uh5X0trVcshPh93JlpTAbEkF84X_Q%3D%3A0
;;
amd64 | i*86 )
apq=x86
wget -o l.log -O pacman-x86.tar.xz https://pan.xb6868.com/api/v3/file/source/147/pacman-x86.tar.xz?sign=WEdHCjbTPjTndfA6FOC2t2Yi42cbp6JPMtuFcZ3gKKg%3D%3A0 
;;
esac
sleep 1
echo 复制文件
mkdir tmp
tar Jxf pacman-$apq.tar.xz -C tmp
cp -rv tmp/pacman.d/* $sys_name/etc/pacman.d/
cp -r tmp/pacman* $sys_name-$AH/etc/
rm -rf tmp pacman*
sleep 2
unset LD_PRELOAD 
proot --bind=/vendor --bind=/system --bind=/data/data/com.termux/files/usr --bind=/storage --bind=/storage/self/primary:/sdcard --bind=/data/data/com.termux/files/home --bind=/data/data/com.termux/cache --bind=/data/dalvik-cache --bind=$sys_name-$AH/tmp:/dev/shm --bind=$sys_name-$AH/etc/proc/vmstat:/proc/vmstat --bind=$sys_name-$AH/etc/proc/version:/proc/version --bind=$sys_name-$AH/etc/proc/uptime:/proc/uptime --bind=$sys_name-$AH/etc/proc/stat:/proc/stat --bind=$sys_name-$AH/etc/proc/loadavg:/proc/loadavg --bind=/sys --bind=/proc/self/fd/2:/dev/stderr --bind=/proc/self/fd/1:/dev/stdout --bind=/proc/self/fd/0:/dev/stdin --bind=/proc/self/fd:/dev/fd --bind=/proc --bind=/dev/urandom:/dev/random --bind=/dev --root-id --cwd=/root -L --kernel-release=5.17.18-perf --sysvipc --link2symlink --kill-on-exit --rootfs=$sys_name-$AH/ /usr/bin/env -i HOME=/root LANG=zh_CN.UTF-8 TERM=xterm-256color /usr/bin/pacman -Syy

unset LD_PRELOAD
proot --bind=/vendor --bind=/system --bind=/data/data/com.termux/files/usr --bind=/storage --bind=/storage/self/primary:/sdcard --bind=/data/data/com.termux/files/home --bind=/data/data/com.termux/cache --bind=/data/dalvik-cache --bind=$sys_name-$AH/tmp:/dev/shm --bind=$sys_name-$AH/etc/proc/vmstat:/proc/vmstat --bind=$sys_name-$AH/etc/proc/version:/proc/version --bind=$sys_name-$AH/etc/proc/uptime:/proc/uptime --bind=$sys_name-$AH/etc/proc/stat:/proc/stat --bind=$sys_name-$AH/etc/proc/loadavg:/proc/loadavg --bind=/sys --bind=/proc/self/fd/2:/dev/stderr --bind=/proc/self/fd/1:/dev/stdout --bind=/proc/self/fd/0:/dev/stdin --bind=/proc/self/fd:/dev/fd --bind=/proc --bind=/dev/urandom:/dev/random --bind=/dev --root-id --cwd=/root -L --kernel-release=5.17.18-perf --sysvipc --link2symlink --kill-on-exit --rootfs=$sys_name-$AH/ /usr/bin/env -i HOME=/root LANG=zh_CN.UTF-8 TERM=xterm-256color /usr/bin/pacman -Syu neofetch
unset LD_PRELOAD
proot --bind=/vendor --bind=/system --bind=/data/data/com.termux/files/usr --bind=/storage --bind=/storage/self/primary:/sdcard --bind=/data/data/com.termux/files/home --bind=/data/data/com.termux/cache --bind=/data/dalvik-cache --bind=$sys_name-$AH/tmp:/dev/shm --bind=$sys_name-$AH/etc/proc/vmstat:/proc/vmstat --bind=$sys_name-$AH/etc/proc/version:/proc/version --bind=$sys_name-$AH/etc/proc/uptime:/proc/uptime --bind=$sys_name-$AH/etc/proc/stat:/proc/stat --bind=$sys_name-$AH/etc/proc/loadavg:/proc/loadavg --bind=/sys --bind=/proc/self/fd/2:/dev/stderr --bind=/proc/self/fd/1:/dev/stdout --bind=/proc/self/fd/0:/dev/stdin --bind=/proc/self/fd:/dev/fd --bind=/proc --bind=/dev/urandom:/dev/random --bind=/dev --root-id --cwd=/root -L --kernel-release=5.17.18-perf --sysvipc --link2symlink --kill-on-exit --rootfs=$sys_name-$AH/ /usr/bin/env -i HOME=/root LANG=zh_CN.UTF-8 TERM=xterm-256color /usr/bin/neofetch
cat > setlang <<- EOM
#/bin/bash
input=y | pacman -S wget curl git neofetch tzdata 
echo 正在设置语言为中文
sed -i '/zh_CN.UTF/s/#//' /etc/locale.gen
locale-gen || /usr/sbin/locale-gen
sed -i '/^export LANG/d' /etc/profile
sed -i '1i\export LANG=zh_CN.UTF-8' /etc/profile
source /etc/profile
echo 正在修复pacman报错
    echo 请稍等....
    chmod 755 /usr/*
    chmod 755 /usr/*/*
    chmod 755 /usr/*/*/*
    chmod 755 /usr/*/*/*/*
    chmod 755 /usr/*/*/*/*/*
    chmod 755 /usr/*/*/*/*/*/*
    chmod 755 /usr/*/*/*/*/*/*/*
    chmod 755 /var/*
    chmod 755 /var/*/*
    chmod 755 /var/*/*/*
    chmod 755 /var/*/*/*/*
    chmod 755 /var/*/*/*/*/*
    chmod 755 /var/*/*/*/*/*/*
    chmod 755 /etc/*
    chmod 755 /etc/*/*/*
    chmod 755 /etc/*/*
    chmod 440 /etc/sudoers
    chmod 755 /etc
    chmod 755 /usr
    chmod 755 /var 
    sleep 2
    pacman -Syu libnewt
    if (whiptail --title "install finish" --yes-button "是的" --no-button "不用"  --yesno "即将打开yti tools" 10 60) then   
pacman -Syu curl git 
$(curl https://gitee.com/yudezeng/yutools/raw/master/yti)
bash
else
bash
fi
EOM
chmod 777 setlang
cp setlang $sys_name-$AH/usr/bin/setlang -rv
rm setlang
unset LD_PRELOAD
proot --bind=/vendor --bind=/system --bind=/data/data/com.termux/files/usr --bind=/storage --bind=/storage/self/primary:/sdcard --bind=/data/data/com.termux/files/home --bind=/data/data/com.termux/cache --bind=/data/dalvik-cache --bind=$sys_name-$AH/tmp:/dev/shm --bind=$sys_name-$AH/etc/proc/vmstat:/proc/vmstat --bind=$sys_name-$AH/etc/proc/version:/proc/version --bind=$sys_name-$AH/etc/proc/uptime:/proc/uptime --bind=$sys_name-$AH/etc/proc/stat:/proc/stat --bind=$sys_name-$AH/etc/proc/loadavg:/proc/loadavg --bind=/sys --bind=/proc/self/fd/2:/dev/stderr --bind=/proc/self/fd/1:/dev/stdout --bind=/proc/self/fd/0:/dev/stdin --bind=/proc/self/fd:/dev/fd --bind=/proc --bind=/dev/urandom:/dev/random --bind=/dev --root-id --cwd=/root -L --kernel-release=5.17.18-perf --sysvipc --link2symlink --kill-on-exit --rootfs=$sys_name-$AH/ /usr/bin/env -i HOME=/root LANG=zh_CN.UTF-8 TERM=xterm-256color /usr/bin/setlang
else
exit 1
fi
exit 1
}
#######
#yti arch installtion
getf(){
    trap 'onCtrlC' INT
function onCtrlC () {
        kill -9 ${do_sth_pid} ${progress_pid}
        echo
        echo 'Ctrl+C is captured'
        exit 1
}

do_sth() {
       wget -O arch-arm64.tar.xz https://pan.xb6868.com/api/v3/file/source/114/arch-arm64.tar.xz?sign=RvCvergN5oJq6IAj5yFSZIzcSY5QjGDNOta_qepIzzs%3D%3A0 -o l.log
       
}

progress() {
        local main_pid=$1
        local length=3
        local ratio=1
        while [ "$(ps -p ${main_pid} | wc -l)" -ne "1" ] ; do
                mark='.'
                progress_bar=
                for i in $(seq 1 "${length}"); do
                        if [ "$i" -gt "${ratio}" ] ; then
                                mark=' '
                        fi
                        progress_bar="${progress_bar}${mark}"
                done
                printf "获取文件 ${progress_bar}\r"
                ratio=$((ratio+1))
                #ratio=`expr ${ratio} + 1`
                if [ "${ratio}" -gt "${length}" ] ; then
                        ratio=1
                fi
                sleep 3
        done
}

do_sth &
do_sth_pid=$(jobs -p | tail -1)

progress "${do_sth_pid}" &
progress_pid=$(jobs -p | tail -1)

wait "${do_sth_pid}"
printf "获取文件 √                 \n"
}
xvft(){
    trap 'onCtrlC' INT
function onCtrlC () {
        kill -9 ${do_sth_pid} ${progress_pid}
        echo
        echo 'Ctrl+C is captured'
        exit 1
}

do_sth() {
    mkdir arch-arm64-yti
       tar xf arch-arm64.tar.xz -C arch-arm64-yti 
       
}

progress() {
        local main_pid=$1
        local length=3
        local ratio=1
        while [ "$(ps -p ${main_pid} | wc -l)" -ne "1" ] ; do
                mark='.'
                progress_bar=
                for i in $(seq 1 "${length}"); do
                        if [ "$i" -gt "${ratio}" ] ; then
                                mark=' '
                        fi
                        progress_bar="${progress_bar}${mark}"
                done
                printf "复制文件 ${progress_bar}\r"
                ratio=$((ratio+1))
                #ratio=`expr ${ratio} + 1`
                if [ "${ratio}" -gt "${length}" ] ; then
                        ratio=1
                fi
                sleep 3
        done
}

do_sth &
do_sth_pid=$(jobs -p | tail -1)

progress "${do_sth_pid}" &
progress_pid=$(jobs -p | tail -1)

wait "${do_sth_pid}"
printf "复制文件 √                 \n"
}
setp(){
echo 检测到你没有权限读取/proc内的所有文件
	echo 正在从git仓库中拉取伪造的文件
	echo 将自动伪造新文件
	git clone https://gitee.com/yudezeng/proot_proc.git
	sleep 1
	mkdir tmp
	echo 正在解压伪造文件
	
	tar xJf proot_proc/proc.tar.xz -C tmp 
	cp -r tmp/usr/local/etc/tmoe-linux/proot_proc tmp/
	sleep 1
	echo 复制文件
	cp -r tmp/proot_proc arch-arm64-yti/etc/proc
	sleep 1
	rm proot_proc tmp -rf
	sys_name=arch-arm64
	AH=yti
	echo "写入启动脚本"
echo "为了兼容性考虑已将内核信息伪造成5.17.18-perf"
sleep 1
cat > arch-arm64-yti.sh <<- EOM
#!/bin/bash
pulseaudio --start
unset LD_PRELOAD
proot --bind=/vendor --bind=/system --bind=/data/data/com.termux/files/usr --bind=/storage --bind=/storage/self/primary:/sdcard --bind=/data/data/com.termux/files/home --bind=/data/data/com.termux/cache --bind=/data/dalvik-cache --bind=$sys_name-$AH/tmp:/dev/shm --bind=$sys_name-$AH/etc/proc/vmstat:/proc/vmstat --bind=$sys_name-$AH/etc/proc/version:/proc/version --bind=$sys_name-$AH/etc/proc/uptime:/proc/uptime --bind=$sys_name-$AH/etc/proc/stat:/proc/stat --bind=$sys_name-$AH/etc/proc/loadavg:/proc/loadavg --bind=/sys --bind=/proc/self/fd/2:/dev/stderr --bind=/proc/self/fd/1:/dev/stdout --bind=/proc/self/fd/0:/dev/stdin --bind=/proc/self/fd:/dev/fd --bind=/proc --bind=/dev/urandom:/dev/random --bind=/dev --root-id --cwd=/root -L --kernel-release=5.17.18-perf --sysvipc --link2symlink --kill-on-exit --rootfs=$sys_name-$AH/ /usr/bin/env -i HOME=/root LANG=zh_CN.UTF-8 TERM=xterm-256color /bin/su -l root
EOM

echo "授予启动脚本执行权限"
sleep 1
chmod +x arch-arm64-yti.sh
}
rfch(){
    trap 'onCtrlC' INT
function onCtrlC () {
        kill -9 ${do_sth_pid} ${progress_pid}
        echo
        echo 'Ctrl+C is captured'
        exit 1
}

do_sth() {
       rm -rf arch-arm64.tar.xz
       sleep 5
}

progress() {
        local main_pid=$1
        local length=3
        local ratio=1
        while [ "$(ps -p ${main_pid} | wc -l)" -ne "1" ] ; do
                mark='.'
                progress_bar=
                for i in $(seq 1 "${length}"); do
                        if [ "$i" -gt "${ratio}" ] ; then
                                mark=' '
                        fi
                        progress_bar="${progress_bar}${mark}"
                done
                printf "清理缓存 ${progress_bar}\r"
                ratio=$((ratio+1))
                #ratio=`expr ${ratio} + 1`
                if [ "${ratio}" -gt "${length}" ] ; then
                        ratio=1
                fi
                sleep 3
        done
}

do_sth &
do_sth_pid=$(jobs -p | tail -1)

progress "${do_sth_pid}" &
progress_pid=$(jobs -p | tail -1)

wait "${do_sth_pid}"
printf "清理缓存 √                 \n"
}
####
MAIN(){
     ldp
     echo "
      1)安装$ARCH_qp容器
      2)安装恢复包
      3)导出系统
      4)安装x64架构的容器(推荐arm64)
      5)安装x86架构的容器(推荐arm64)
      6)Android-Termux额外工具
      7)qbox工具箱(本功能由雪碧提供支持)
      8)手动检查更新
      9)下载脚本到本地
      10)TUI交互界面
      0)退出
     
      "
     read -p "请选择 " opt
     case $opt in
     
     1)
     ARCH=$(ARCH_)
     AH=$(ARCH_)
     SYS_SELECT "$@"
     SYS_DOWN
     SYS_SET
     FIN
     
     ;;
     2)
    lfi
      ;;
      3)echo "请输入此目录的容器系统目录名称"
      echo 如果没有这个目录
      echo 则放弃备份
      ls
      read -p " " sys_name
      XZ_OPT="-2T 4" tar -cvJf $sys_name.tar.xz $sys_name/*
      cp $sys_name.tar.xz /sdcard/Download/$sys_name.tar.xz
      rm  $sys_name.tar.xz
      echo 容器系统已备份到/sdcard/Download/$sys_name.tar.xz
      ;;
      4)
      ARCH=amd64
      AH=amd64
      qemu=qemu-x86_64-static
      SYS_SELECT "$@"
      SYS_DOWN
      SYS_SET
      FIN_
      ;;
      5)
      ARCH=i386
      AH=i386
      qemu=qemu-i386-static
      SYSLIST "$@"
      SYS_DOWN
      SYS_SET
      FIN_
      ;;
      6)tsn
      ;;
      8 | update)
      updated
      ;;

      9)dti
      ;;
      10)
      intp
      main_ 
      
      ;;
      7)echo 正在从服务器拉取
      bash -c "$(curl https://shell.xb6868.com/xbtools.sh)"
      ;;
      0)exit ;;
      *)echo 请重新选择 ;;
      esac
}
FIN_(){
    if [ -e centos-amd64 ]
    then
    cpu=" -cpu Snowridge-v4 "
    fi
echo "配置qemu"
sleep 2
mkdir termux_tmp && cd termux_tmp
CURL_T=`curl https://mirrors.bfsu.edu.cn/debian/pool/main/q/qemu/ | grep '\.deb' | grep 'qemu-user-static' | grep arm64 | tail -n 1 | cut -d '=' -f 3 | cut -d '"' -f 2`
curl -o qemu.deb https://mirrors.bfsu.edu.cn/debian/pool/main/q/qemu/$CURL_T
apt install binutils
ar -vx qemu.deb
tar xvf data.tar.xz
cd && cp termux_tmp/usr/bin/$qemu  $sys_name-$AH/ && rm -rf termux_tmp
echo "删除临时文件"
sleep 1
echo "创建登录系统脚本"
sleep 1
echo "
#!/bin/bash
pulseaudio --start
unset LD_PRELOAD
proot --bind=/vendor --bind=/system --bind=/data/data/com.termux/files/usr --bind=/storage --bind=/storage/self/primary:/sdcard --bind=/data/data/com.termux/files/home --bind=/data/data/com.termux/cache --bind=/data/dalvik-cache --bind=$sys_name-$AH/tmp:/dev/shm --bind=$sys_name-$AH/etc/proc/vmstat:/proc/vmstat --bind=$sys_name-$AH/etc/proc/version:/proc/version --bind=$sys_name-$AH/etc/proc/uptime:/proc/uptime --bind=$sys_name-$AH/etc/proc/stat:/proc/stat --bind=$sys_name-$AH/etc/proc/loadavg:/proc/loadavg --bind=/sys --bind=/proc/self/fd/2:/dev/stderr --bind=/proc/self/fd/1:/dev/stdout --bind=/proc/self/fd/0:/dev/stdin --bind=/proc/self/fd:/dev/fd --bind=/proc --bind=/dev/urandom:/dev/random --bind=/dev --root-id --cwd=/root -L --kernel-release=5.17.18-perf --sysvipc --link2symlink --kill-on-exit  -q '$sys_name-$AH/$qemu $cpu' --rootfs=$sys_name-$AH/ /usr/bin/env -i HOME=/root LANG=C.UTF-8 TERM=xterm-256color /bin/su -l root ">$sys_name-$AH.sh
echo "赋予执行权限"
sleep 1
chmod +x $sys_name-$AH.sh
sleep 2
case $name in
debian|ubuntu)
case $AH in 
amd64|i*86)
AUTOFIN_
;;
arm*)
AUTOFIN
;;
*)
echo
;;
esac
;;
*)
echo
;;
esac
if [ $sys_name = arch ]
then
echo 更换软件源地址
echo 获取文件
case $AH in
arm*)
apq=arm
wget -o l.log -O pacman-arm.tar.xz https://pan.xb6868.com/api/v3/file/source/135/pacman.tar.xz?sign=EY4yY4V7e537I7Uh5X0trVcshPh93JlpTAbEkF84X_Q%3D%3A0
;;
amd64 | i*86 )
apq=x86
wget -o l.log -O pacman-x86.tar.xz https://pan.xb6868.com/api/v3/file/source/147/pacman-x86.tar.xz?sign=WEdHCjbTPjTndfA6FOC2t2Yi42cbp6JPMtuFcZ3gKKg%3D%3A0 
;;
esac
sleep 1
echo 复制文件
mkdir tmp
tar Jvxf pacman-$apq.tar.xz -C tmp
rm -rfv $sys_name/etc/pacman*
echo 'Server = https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.huaweicloud.com/archlinux/$repo/os/$arch' >>mirrorlist
cp -rv tmp/pacman.conf $sys_name-$AH/etc/pacman.conf
cp -r mirrorlist $sys_name-$AH/etc/pacman.d/mirrorlist
rm -rf tmp pacman*
sleep 2
unset LD_PRELOAD 
proot --bind=/vendor --bind=/system --bind=/data/data/com.termux/files/usr --bind=/storage --bind=/storage/self/primary:/sdcard --bind=/data/data/com.termux/files/home --bind=/data/data/com.termux/cache --bind=/data/dalvik-cache --bind=$sys_name-$AH/tmp:/dev/shm --bind=$sys_name-$AH/etc/proc/vmstat:/proc/vmstat --bind=$sys_name-$AH/etc/proc/version:/proc/version --bind=$sys_name-$AH/etc/proc/uptime:/proc/uptime --bind=$sys_name-$AH/etc/proc/stat:/proc/stat --bind=$sys_name-$AH/etc/proc/loadavg:/proc/loadavg --bind=/sys --bind=/proc/self/fd/2:/dev/stderr --bind=/proc/self/fd/1:/dev/stdout --bind=/proc/self/fd/0:/dev/stdin --bind=/proc/self/fd:/dev/fd --bind=/proc --bind=/dev/urandom:/dev/random --bind=/dev --root-id -q $sys_name-$AH/$qemu --cwd=/root -L --kernel-release=5.17.18-perf --sysvipc --link2symlink --kill-on-exit --rootfs=$sys_name-$AH/ /usr/bin/env -i HOME=/root LANG=zh_CN.UTF-8 TERM=xterm-256color /usr/bin/pacman -Syy

unset LD_PRELOAD
proot --bind=/vendor --bind=/system --bind=/data/data/com.termux/files/usr --bind=/storage --bind=/storage/self/primary:/sdcard --bind=/data/data/com.termux/files/home --bind=/data/data/com.termux/cache --bind=/data/dalvik-cache --bind=$sys_name-$AH/tmp:/dev/shm --bind=$sys_name-$AH/etc/proc/vmstat:/proc/vmstat --bind=$sys_name-$AH/etc/proc/version:/proc/version --bind=$sys_name-$AH/etc/proc/uptime:/proc/uptime --bind=$sys_name-$AH/etc/proc/stat:/proc/stat --bind=$sys_name-$AH/etc/proc/loadavg:/proc/loadavg --bind=/sys --bind=/proc/self/fd/2:/dev/stderr --bind=/proc/self/fd/1:/dev/stdout --bind=/proc/self/fd/0:/dev/stdin --bind=/proc/self/fd:/dev/fd --bind=/proc --bind=/dev/urandom:/dev/random --bind=/dev --root-id  -q $sys_name-$AH/$qemu  --cwd=/root -L --kernel-release=5.17.18-perf --sysvipc --link2symlink --kill-on-exit --rootfs=$sys_name-$AH/ /usr/bin/env -i HOME=/root LANG=zh_CN.UTF-8 TERM=xterm-256color /usr/bin/pacman -Syu neofetch
unset LD_PRELOAD
proot --bind=/vendor --bind=/system --bind=/data/data/com.termux/files/usr --bind=/storage --bind=/storage/self/primary:/sdcard --bind=/data/data/com.termux/files/home --bind=/data/data/com.termux/cache --bind=/data/dalvik-cache --bind=$sys_name-$AH/tmp:/dev/shm --bind=$sys_name-$AH/etc/proc/vmstat:/proc/vmstat --bind=$sys_name-$AH/etc/proc/version:/proc/version --bind=$sys_name-$AH/etc/proc/uptime:/proc/uptime --bind=$sys_name-$AH/etc/proc/stat:/proc/stat --bind=$sys_name-$AH/etc/proc/loadavg:/proc/loadavg --bind=/sys --bind=/proc/self/fd/2:/dev/stderr --bind=/proc/self/fd/1:/dev/stdout --bind=/proc/self/fd/0:/dev/stdin --bind=/proc/self/fd:/dev/fd --bind=/proc --bind=/dev/urandom:/dev/random --bind=/dev --root-id  -q $sys_name-$AH/$qemu  --cwd=/root -L --kernel-release=5.17.18-perf --sysvipc --link2symlink --kill-on-exit --rootfs=$sys_name-$AH/ /usr/bin/env -i HOME=/root LANG=zh_CN.UTF-8 TERM=xterm-256color /usr/bin/neofetch
cat > setlang <<- EOM
#/bin/bash
echo 正在设置语言为中文
sed -i '/zh_CN.UTF/s/#//' /etc/locale.gen
locale-gen || /usr/sbin/locale-gen
sed -i '/^export LANG/d' /etc/profile
sed -i '1i\export LANG=zh_CN.UTF-8' /etc/profile
source /etc/profile
echo 正在修复pacman报错
    echo 请稍等....
    chmod 755 /usr/*
    chmod 755 /usr/*/*
    chmod 755 /usr/*/*/*
    chmod 755 /usr/*/*/*/*
    chmod 755 /usr/*/*/*/*/*
    chmod 755 /usr/*/*/*/*/*/*
    chmod 755 /usr/*/*/*/*/*/*/*
    chmod 755 /var/*
    chmod 755 /var/*/*
    chmod 755 /var/*/*/*
    chmod 755 /var/*/*/*/*
    chmod 755 /var/*/*/*/*/*
    chmod 755 /var/*/*/*/*/*/*
    chmod 755 /etc/*
    chmod 755 /etc/*/*/*
    chmod 755 /etc/*/*
    chmod 440 /etc/sudoers
    chmod 755 /etc
    chmod 755 /usr
    chmod 755 /var 
    sleep 2
    pacman -Syu libnewt
    if (whiptail --title "install finish" --yes-button "是的" --no-button "不用"  --yesno "即将打开yti tools" 10 60) then   
pacman -Syu curl git 
$(curl https://gitee.com/yudezeng/yutools/raw/master/yti)
bash
else
bash
fi
EOM
chmod 777 setlang
cp setlang $sys_name-$AH/usr/bin/setlang -rv
rm setlang
unset LD_PRELOAD
proot --bind=/vendor --bind=/system --bind=/data/data/com.termux/files/usr --bind=/storage --bind=/storage/self/primary:/sdcard --bind=/data/data/com.termux/files/home --bind=/data/data/com.termux/cache --bind=/data/dalvik-cache --bind=$sys_name-$AH/tmp:/dev/shm --bind=$sys_name-$AH/etc/proc/vmstat:/proc/vmstat --bind=$sys_name-$AH/etc/proc/version:/proc/version --bind=$sys_name-$AH/etc/proc/uptime:/proc/uptime --bind=$sys_name-$AH/etc/proc/stat:/proc/stat --bind=$sys_name-$AH/etc/proc/loadavg:/proc/loadavg --bind=/sys --bind=/proc/self/fd/2:/dev/stderr --bind=/proc/self/fd/1:/dev/stdout --bind=/proc/self/fd/0:/dev/stdin --bind=/proc/self/fd:/dev/fd --bind=/proc --bind=/dev/urandom:/dev/random --bind=/dev --root-id  -q $sys_name-$AH/$qemu  --cwd=/root -L --kernel-release=5.17.18-perf --sysvipc --link2symlink --kill-on-exit --rootfs=$sys_name-$AH/ /usr/bin/env -i HOME=/root LANG=zh_CN.UTF-8 TERM=xterm-256color /usr/bin/bash /usr/bin/setlang
else
echo -e "现在可以执行 ./$sys_name-$AH.sh 运行 $sys_name-$AH系统"
fi
exit 1
}
##
AUTOFIN(){
    APKH=ubuntu-ports
    if [ $sys_name = impish ]
     then
     cat > autoset <<- EOM
     echo 换软件源
     echo "
     deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ impish main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/$APKH/ impish main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ impish-updates main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/$APKH/ impish-updates main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ impish-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/$APKH/ impish-backports main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ impish-security main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/$APKH/ impish-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/$APKH/ impish-proposed main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/$APKH/ impish-proposed main restricted universe multiverse ">sources.list
rm -rfv /etc/apt/sources.list
cp -rv ./sources.list /etc/apt/
apt update && autofin
EOM
fi
     
     if [ $sys_name = bullseye ]
     then
     cat > autoset <<- EOM
     echo 换软件源
     echo " deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
# deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
# deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free

deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free

deb http://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free ">sources.list
rm -rfv /etc/apt/sources.list
cp -rv ./sources.list /etc/apt/
apt update && autofin
EOM
fi
     if [ $sys_name = focal ]
     then 
     cat > autoset <<- EOM
     echo 换软件源
     echo "deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ focal main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/$APKH/ focal main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ focal-updates main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/$APKH/ focal-updates main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ focal-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/$APKH/ focal-backports main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ focal-security main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/$APKH/ focal-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/$APKH/ focal-proposed main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/$APKH/ focal-proposed main restricted universe multiverse ">sources.list
rm -rfv /etc/apt/sources.list
cp -rv ./sources.list /etc/apt/
apt update && autofin
EOM
     fi
     if [ $sys_name = bionic ]
     then 
     cat > autoset <<- EOM
     echo 换软件源
     echo "deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ bionic main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/$APKH/ bionic main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ bionic-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/$APKH/ bionic-updates main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ bionic-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/$APKH/ bionic-backports main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ bionic-security main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/$APKH/ bionic-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ bionic-proposed main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/$APKH/ bionic-proposed main restricted universe multiverse ">sources.list
     rm -rfv /etc/apt/sources.list
     cp -rv ./sources.list /etc/apt/
     apt update && autofin
EOM
     fi
     if [ $sys_name = sid ]
     then 
     cat > autoset <<- EOM
     echo 换软件源
     echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ sid main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ sid main contrib non-free ">sources.list
rm -rfv /etc/apt/sources.list
cp -rv ./sources.list /etc/apt/
apt update && autofin
apt install apt-utils
apt install locale
EOM
     fi
     if [ $sys_name = buster ]
     then 
     cat > autoset <<- EOM
     echo 换软件源
     echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free
# deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free

deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free

deb http://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free ">sources.list
rm -rfv /etc/apt/sources.list
cp -rv ./sources.list /etc/apt/
apt update && autofin
EOM
     fi
     cat > autofin <<- EOM
     apt install -y apt-utils 
     apt install -y perl git wget curl 
     apt install htop locales -y
     apt install -y language-pack-zh-han* language-pack-gnome-zh-han* 
apt install -y fonts-noto-cjk*
sed -i '/zh_CN.UTF/s/#//' /etc/locale.gen
locale-gen || /usr/sbin/locale-gen
sed -i '/^export LANG/d' /etc/profile
sed -i '1i\export LANG=zh_CN.UTF-8' /etc/profile
source /etc/profile
apt install whiptail -y
apt install libnewt -y
if (whiptail --title "install finish" --yes-button "是的" --no-button "不用"  --yesno "即将打开yti tools" 10 60) then   
apt install curl -y
$(curl https://gitee.com/yudezeng/yutools/raw/master/yti)
bash
else
bash
fi
EOM
    chmod 777 autofin
    chmod 777 autoset
    cp -rv /data/data/com.termux/files/usr/bin/neofetch $sys_name-$AH/usr/bin/
    cp -rv autoset $sys_name-$AH/usr/bin/autoset
    cp -rv autofin $sys_name-$AH/usr/bin/autofin
    rm autoset autofin
    unset LD_PRELOAD
    proot --bind=/vendor --bind=/system --bind=/data/data/com.termux/files/usr --bind=/storage --bind=/storage/self/primary:/sdcard --bind=/data/data/com.termux/files/home --bind=/data/data/com.termux/cache --bind=/data/dalvik-cache --bind=$sys_name-$AH/tmp:/dev/shm --bind=$sys_name-$AH/etc/proc/vmstat:/proc/vmstat --bind=$sys_name-$AH/etc/proc/version:/proc/version --bind=$sys_name-$AH/etc/proc/uptime:/proc/uptime --bind=$sys_name-$AH/etc/proc/stat:/proc/stat --bind=$sys_name-$AH/etc/proc/loadavg:/proc/loadavg --bind=/sys --bind=/proc/self/fd/2:/dev/stderr --bind=/proc/self/fd/1:/dev/stdout --bind=/proc/self/fd/0:/dev/stdin --bind=/proc/self/fd:/dev/fd --bind=/proc --bind=/dev/urandom:/dev/random --bind=/dev --root-id --cwd=/root -L --kernel-release=5.17.18-perf --sysvipc --link2symlink --kill-on-exit  --rootfs=$sys_name-$AH/ /usr/bin/env -i HOME=/root LANG=zh_CN.UTF-8 TERM=xterm-256color /bin/autoset
}
##
AUTOFIN_(){
    if [ $ARCH=amd64 ]
    then
    APKH=ubuntu
    vm="-q $sys_name-$AH/$qemu"
    fi
    if [ $ARCH=i386 ]
    then
    APKH=ubuntu
    vm=" -q $sys_name-$AH/$qemu"
    fi
    
    if [ $sys_name = impish ]
     then
     cat > autoset <<- EOM
     echo 换软件源
     echo "
     deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ impish main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/$APKH/ impish main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ impish-updates main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/$APKH/ impish-updates main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ impish-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/$APKH/ impish-backports main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ impish-security main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/$APKH/ impish-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/$APKH/ impish-proposed main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/$APKH/ impish-proposed main restricted universe multiverse ">sources.list
rm -rfv /etc/apt/sources.list
cp -rv ./sources.list /etc/apt/
apt update
EOM
fi
     
     if [ $sys_name = bullseye ]
     then
     cat > autoset <<- EOM
     echo 换软件源
     echo " deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
# deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
# deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free

deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free

deb http://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free ">sources.list
rm -rfv /etc/apt/sources.list
cp -rv ./sources.list /etc/apt/
apt update
EOM
fi
     if [ $sys_name = focal ]
     then 
     cat > autoset <<- EOM
     echo 换软件源
     echo "deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ focal main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/$APKH/ focal main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ focal-updates main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/$APKH/ focal-updates main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ focal-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/$APKH/ focal-backports main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ focal-security main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/$APKH/ focal-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/$APKH/ focal-proposed main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/$APKH/ focal-proposed main restricted universe multiverse ">sources.list
rm -rfv /etc/apt/sources.list
cp -rv ./sources.list /etc/apt/
apt update
EOM
     fi
     if [ $sys_name = bionic ]
     then 
     cat > autoset <<- EOM
     echo 换软件源
     echo "deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ bionic main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/$APKH/ bionic main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ bionic-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/$APKH/ bionic-updates main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ bionic-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/$APKH/ bionic-backports main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ bionic-security main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/$APKH/ bionic-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb http://mirrors.tuna.tsinghua.edu.cn/$APKH/ bionic-proposed main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/$APKH/ bionic-proposed main restricted universe multiverse ">sources.list
     rm -rfv /etc/apt/sources.list
     cp -rv ./sources.list /etc/apt/
     apt update
EOM
     fi
     if [ $sys_name = sid ]
     then 
     cat > autoset <<- EOM
     echo 换软件源
     echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ sid main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ sid main contrib non-free ">sources.list
rm -rfv /etc/apt/sources.list
cp -rv ./sources.list /etc/apt/
rm -rfv ./sources.list
apt update

EOM
     fi
     if [ $sys_name = buster ]
     then 
     cat > autoset <<- EOM
     echo 换软件源
     echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free
# deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free

deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free

deb http://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free ">sources.list
rm -rfv /etc/apt/sources.list
cp -rv ./sources.list /etc/apt/
apt update
EOM
     fi
    chmod 777 autoset
    cp -rv /data/data/com.termux/files/usr/bin/neofetch $sys_name-$AH/usr/bin/
    cp -rv autoset $sys_name-$AH/usr/bin/autoset
    rm autoset
    unset LD_PRELOAD
    proot --bind=/vendor --bind=/system --bind=/data/data/com.termux/files/usr --bind=/storage --bind=/storage/self/primary:/sdcard --bind=/data/data/com.termux/files/home --bind=/data/data/com.termux/cache --bind=/data/dalvik-cache --bind=$sys_name-$AH/tmp:/dev/shm --bind=$sys_name-$AH/etc/proc/vmstat:/proc/vmstat --bind=$sys_name-$AH/etc/proc/version:/proc/version --bind=$sys_name-$AH/etc/proc/uptime:/proc/uptime --bind=$sys_name-$AH/etc/proc/stat:/proc/stat --bind=$sys_name-$AH/etc/proc/loadavg:/proc/loadavg --bind=/sys --bind=/proc/self/fd/2:/dev/stderr --bind=/proc/self/fd/1:/dev/stdout --bind=/proc/self/fd/0:/dev/stdin --bind=/proc/self/fd:/dev/fd --bind=/proc --bind=/dev/urandom:/dev/random --bind=/dev --root-id --cwd=/root -L $vm --kernel-release=5.17.18-perf --sysvipc --link2symlink --kill-on-exit  --rootfs=$sys_name-$AH/ /usr/bin/env -i HOME=/root LANG=zh_CN.UTF-8 TERM=xterm-256color /bin/autoset
}
SYSLIST(){
    echo 由于绝大部分系统不兼容x86
    echo 以下这些系统是兼容x86
     echo "
		1) buster
		2) bullseye
		3) sid
		4) bionic
		0) 退出"
		read -r -p "请选择:" input
		case $input in
			1) echo "即将下载安装debian(buster)"
		name=debian
		sys_name=buster
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/debian/buster/$ARCH/default/" ;;
	2) echo "即将下载安装debian(bullseye)"        
		name=debian
		sys_name=bullseye  
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/debian/bullseye/$ARCH/default/" ;;
	3) echo "即将下载安装debian(sid)"
		name=debian
		sys_name=sid
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/debian/sid/$ARCH/default/" ;;
	4)echo 即将下载安装ubuntu18.04
	    name=ubuntu
	    sys_name=bionic
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/ubuntu/bionic/$ARCH/default/" ;;
		0) echo -e "\nexit"
			sleep 1                           
			exit 0 ;;                           
	*) echo 您的选择有误                                      ;;
esac 
mkdir $name
	
}
#############
#TUI
#termux TUI
LODU(){
     case $opt in
     1)
     ARCH=$(ARCH_)
     AH=$(ARCH_)
     SYS_SELECT_"$@"
     SYS_DOWN
     SYS_SET
     FIN
     
     ;;
     3)
     lfi
      ;;
      4)echo "请输入此目录的容器系统目录名称"
      echo 如果没有这个目录
      echo 则放弃备份
      ls
      read -p " " sys_name
      XZ_OPT="-2T 4" | tar -cvJf $sys_name.tar.xz $sys_name/*
      cp $sys_name.tar.xz /sdcard/Download/$sys_name.tar.xz
      rm  $sys_name.tar.xz
      echo 容器系统已备份到/sdcard/Download/$sys_name.tar.xz
      ;;
      5)
      ARCH=amd64
      AH=amd64
      qemu=qemu-x86_64-static
      SYS_SELECT_ "$@"
      SYS_DOWN
      SYS_SET
      FIN_
      ;;
      6)
      ARCH=i386
      AH=i386
      qemu=qemu-i386-static
      SYSLIST_ "$@"
      SYS_DOWN
      SYS_SET
      FIN_
      ;;
      0)ts ;;
      7 | update)
      updated
      ;;

      8)dti
      ;;
      2)
      clear
      MAIN
      
      ;;
      00)echo 此脚本作者为雪碧
      sleep 1
      echo 联系方式为
      echo "qq:1651930562"
      sleep 1
      echo 如有bug可以直接反馈
      bash -c "$(curl https://shell.xb6868.com/xbtools.sh )"
      ;;
      02)
      if (whiptail --backtitle "yti arch installtion setup(arm64)" --title "欢迎使用本作者制作的arch-arm64安装程序" --yes-button "继续" --no-button "退出"  --yesno "即将安装本作者制作的arch-arm64" 10 60) then   
     getf
     sleep 2
     xvft
     sleep 2
     setp
     sleep 2
     rfch
     sleep 2
     setarch 
     sleep 2
     whiptail --backtitle "yti arch install setup" --title "install finish" --msgbox "安装已结束您可以输入./arch-arm64-yti.sh来启动此系统" 10 60
else
     exit 1
     fi
      
      ;;
      10)exit ;;
      *)echo 退出
      exit 1;;
      esac
}
ldp(){
     echo version is $stv
     date
     echo "ps:在安装Arch/ubuntu/debian系统的时候会自动将软件源换成国内"
    echo "centos 跨CPU架构(arm64模拟x64)已经可以正常使用"
     echo 部分界面已经适配了交互菜单
     echo 如果出现报错，请谅解
     echo 将在后续版本中修复
     echo "由于手头上没有armhf架构的设备"
     echo "所以导致安装x86/x64架构容器"
     echo "标题上写着(推荐arm64)"
     sleep 0.5
     echo "welcome to yutools"
     
     if [ $PATHG = GNU/Linux ]
     then 
     echo 警告信息:
     echo 本脚本暂未开发出兼容所有GNU/Linux的版本
     echo 可能会出现严重的兼容性错误
     echo 在Android Termux上运行的兼容性会更好
     sleep 2
     echo 将继续加载脚本.....
     sleep 2
     fi
     sleep 0.5
     echo "It's running on $ARCH_qp $PATHG"
}
main_(){
clear
ldp
sleep 0.5
opt=$(whiptail --clear --title "主菜单" --menu "请选择你要执行的功能" 18 56 10 "0" "Android-Termux工具(内置修复termux openssl)" "1" "安装$ARCH_qp Linux 系统 (proot容器)" "02" "yti-arch(Arch Linux ARM)(arm64)" "2" "返回到旧版本页面" "00" "xbtools(雪碧提供支持)" "3" "安装恢复包" "4" "导出系统" "5" "arm64设备安装Linux x86_64系统(proot+qemu)" "6" "arm64设备安装Linux x86系统(proot+qemu)" "7" "检查更新" "8" "下载脚本到本地" "10" "退出"  3>&1 1>&2 2>&3)
LODU
}
####
setup(){
    INFO=$(uname -o)
    if [ $INFO = GNU/Linux ]
    then
   aptu=$(ls /usr/bin/apt)
   if [ $aptu = "/usr/bin/apt" ]
   then
   echo 检测到您可能正在使用$info_sys $ARCH_qp
    intp
    echo 加载界面
    sleep 0.5
    MENU
    else
    echo 警告 :
    echo 您当前使用的不是ubuntu/debian/arch
    echo 本工具暂未支持您当前使用的系统
    echo 即将退出
    sleep 1
    exit 1
    fi
    else
    intp
    main_
    fi
}
####
#ubuntu/debian TUI
MENU(){
opt=$(whiptail --clear --title "主菜单" --menu "请选择你要执行的功能" 20 50 10 "00" "yti adb tools(beta)" "01" "安装软件(当前仅支持安装浏览器chromium)" "0" "xbtool(qbox工具箱)" "1" "换源" "2" "安装桌面(当前仅支持xfce4)" "3" "新建用户" "4" "containers工具" "5" "下载脚本到本地" "6" "检查更新" "7"  "切换默认语言为中文" "8" "仅配置VNC"  "10" "退出"  3>&1 1>&2 2>&3)
LODU_
}
LODU_(){
    case $opt in
00)
adb_tools
;;
1)
read_infosys(){
sysinfon=$(cat /etc/os-release | grep PRETTY_NAME |awk -F'=' '{print $2}')
syscoden=$(cat /etc/os-release | grep VERSION_CODENAME |awk -F'=' '{print $2}' )
case $(uname -m) in
         arm64|aarch*)
         archinfo=ubuntu-ports
         sysarchinfo=arm64
			;;
		x86_64|amd64) 
		archinfo=ubuntu	
		sysarchinfo=x64
			;;
		i*86|x86)
		archinfo=ubuntu
		sysarchinfo=x86
			;;
		armv7*|armv8l|arm|armhf)
		archinfo=ubuntu-ports
		sysarchinfo=arm32
		;;
esac
}
list_io(){
oiyu=$(whiptail --clear --title "更换软件源(选择镜像站)" --menu "请选择你要更换哪一镜像站的软件原地址" 15 45 5 "1" "阿里云(aliyun)" "2" "清华源(tuna)" "3" "网易云(163)" "4" "中科大(ustc)" "10" "返回上一级"  3>&1 1>&2 2>&3)
case $oiyu in
	1)
		sourceweb='http://mirrors.aliyun.com'
	;;
	2)
		sourceweb='https://mirrors.tuna.tsinghua.edu.cn'
	;;
	3)
		sourceweb='http://mirrors.163.com'
	;;
	4)
		sourceweb='http://mirrors.ustc.edu.cn'
	;;
	10) MENU ;;
esac
}
update_source(){
# 3.备份换源
echo "备份sources.list..."
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo rm -rf /etc/apt/sources.list
echo "设置新的镜像源..."
okinfo(){
info=$(cat /etc/os-release | grep '^NAME' |awk -F'=' '{print $2}') 
echo $info
if [ $info = '"Ubuntu"' ]
then
echo "deb $sourceweb/$archinfo/ $syscoden main restricted universe multiverse
deb $sourceweb/$archinfo/ $syscoden-security main restricted universe multiverse
deb $sourceweb/$archinfo/ $syscoden-updates main restricted universe multiverse
deb $sourceweb/$archinfo/ $syscoden-proposed main restricted universe multiverse
deb $sourceweb/$archinfo/ $syscoden-backports main restricted universe multiverse
">>sources.list
fi
if [ $info = '"Debian"' ]
then
echo "deb https://$sourceweb/debian/ $syscoden main contrib non-free

deb https://$sourceweb/debian/ $syscoden-updates main contrib non-free

deb https://$sourceweb/debian/ $syscoden-backports main contrib non-free

deb https://$sourceweb/debian-security $syscoden/updates main contrib non-free
">>sources.list
fi
}
okinfo
cp -v sources.list /etc/apt/sources.list
rm sources.list
sleep 1.5
echo "更新源..."
sudo apt-get update
MENU
}
read_info(){
    ipo=$(whiptail --title "换软件源(确定操作系统代号)" --inputbox "请输入你的系统代号" 10 50 3>&1 1>&2 2>&3)
    list_io
    update_source
}
read_infosys
if (whiptail --backtitle "yutools sources upgrade" --title "更换软件源(确定系统)" --yes-button "是的" --no-button "不是"  --yesno "检测到当前系统为$sysinfon $sysarchinfo" 10 60) then
list_io
update_source
else
read_info
fi
;;
3)
do_you_want_to_create_a_new_user() {
		if (whiptail --title "NEW USER" --yes-button "YES" --no-button "NO" --yesno 'Do you want to create a new sudo user?\n请问您是否想要新建一个sudo用户呢?' 0 0); then
			TIPS_01="请输入用户名(可以为英文或数字,不能为特殊字符)\n please type the user name."
			please_type_the_user_name
		fi
}
please_type_the_user_name() {
	unset USER_NAME
	USER_NAME=$(whiptail --inputbox "${TIPS_01}" 0 0 --title "USER NAME" 3>&1 1>&2 2>&3)
	if [[ "$?" != "0" || -z "${USER_NAME}" ]]; then
		printf "%s\n" "The value is empty,please re-enter.Press enter to return."
		read
		do_you_want_to_create_a_new_user
	elif [[ ${USER_NAME} = root ]]; then
		printf "%s\n" "Sorry,please re-enter.Press enter to return."
		read
		do_you_want_to_create_a_new_user
	elif [[ ! ${USER_NAME} =~ ^[0-9A-Za-z]+$ ]]; then
		printf "%s\n" "检测到特殊字符,请输入英文或数字,请勿输入特殊字符。"
		printf "%s\n" "Please re-enter.Press enter to return"
		read
		please_type_the_user_name
	else
		if [ $(command -v useradd) ]; then
			useradd -m "${USER_NAME}"
		else
			adduser -D "${USER_NAME}"
		fi

		please_type_the_passwd
	fi
}
###################
please_type_the_passwd() {
	PASSWORD_01=$(whiptail --inputbox "Please type the password" 9 40 --title "PASSWORD/密鑰/密码/Пароль/암호" 3>&1 1>&2 2>&3)
	if [[ "$?" != "0" || -z "${PASSWORD_01}" ]]; then
		printf "%s\n" "The value is empty,please re-enter.Press enter to return."
		read
		please_type_the_passwd
	else
		change_the_password
	fi
}
change_the_password() {
	# PASSWORD_02=$(whiptail --passwordbox "Please retype the password" 9 40 --title "PASSWORD" 3>&1 1>&2 2>&3)
	# if [[ "$?" != "0" || -z "${PASSWORD_02}" ]]; then
	# 	printf "%s\n" "The value is empty,please re-enter.Press enter to return."
	# 	read
	# 	change_the_password
	# elif [[ ${PASSWORD_01} != ${PASSWORD_02} ]]; then
	# 	printf "%s\n" "${RED}Sorry${RESET}, the two passwords are ${PURPLE}inconsistent${RESET}"
	# 	printf "%s\n" "Please re-enter.Press enter to return"
	# 	read
	# 	do_you_want_to_create_a_new_user
	# else
	printf "%s\n" "${USER_NAME}:${PASSWORD_01}" | chpasswd
	printf "%s\n" "root:${PASSWORD_01}" | chpasswd
	unset PASSWORD_01 PASSWORD_02
	TMOE_ROOT_SUDO_LINE=$(grep 'root.*ALL' -n /etc/sudoers | tail -n 1 | cut -d ':' -f 1)
	#TMOE_USER_SUDO_LINE=$((TMOE_ROOT_SUDO_LINE + 1))
	if [ -z "${TMOE_ROOT_SUDO_LINE}" ]; then
		sed -i "$ a ${USER_NAME}    ALL=(ALL:ALL) NOPASSWD:ALL" /etc/sudoers
	else
		sed -i "${TMOE_ROOT_SUDO_LINE}a ${USER_NAME}    ALL=(ALL:ALL) NOPASSWD:ALL" /etc/sudoers
	fi
	sed -n p /etc/sudoers
	for i in /sdcard /storage/self/primary /storage/emulated/0 /sd; do
		if [[ -e ${i} ]]; then
			ln -svf ${i} /home/${USER_NAME}/sd
			break
		fi
	done
	for i in /media/termux /root/termux; do
		if [[ -e ${i} ]]; then
			ln -svf ${i} /home/${USER_NAME}/termux
			break
		fi
	done
	for i in /storage/sdcard1 /root/tf; do
		if [[ -e ${i} ]]; then
			ln -svf ${i} /home/${USER_NAME}/tf
			break
		fi
	done
	if [[ -e /usr/local/bin/startvnc ]]; then
		ln -svf /usr/local/bin/startvnc /home/${USER_NAME}/startvnc
	fi
	touch /home/${USER_NAME}/.hushlogin
	chmod 666 /home/${USER_NAME}/.hushlogin
	chown -v "${USER_NAME}":"${USER_NAME}" /home/${USER_NAME}/.hushlogin
}
do_you_want_to_create_a_new_user
echo 现在您可以输入su -l 进入$USER_NAME用户了
exit 1
;;
2)
sudo apt install xfce4 xfce4-goodies dbus-x11 xfonts-100dpi -y
apt remove xfce4-power-*
MENU
;;
4)

sudo apt install -y proot zstd pulseaudio
main_
;;
5)
dti
;;
6)
updated
;;
8)
setvnc
;;
7)
apt install -y language-pack-zh-han* language-pack-gnome-zh-han* 
apt install -y fonts-noto-cjk*
sed -i '/zh_CN.UTF/s/#//' /etc/locale.gen
locale-gen || /usr/sbin/locale-gen
sed -i '/^export LANG/d' /etc/profile
sed -i '1i\export LANG=zh_CN.UTF-8' /etc/profile
source /etc/profile
export LANG=zh_CN.UTF-8
MENU
;;
10)
echo 退出
exit 1
;;
0)echo 此脚本作者为雪碧
      sleep 1
      echo 联系方式为
      echo "qq:1651930562"
      sleep 1
      echo 如有bug可以直接反馈
      apt install curl -y 
      bash -c "$(curl https://shell.xb6868.com/xbtools.sh )"
      ;;
01)
itu=$(whiptail --clear --title "install app" --menu "请选择需要安装的app" 15 45 7 "0" "媒体播放器" "1" "系统工具" "2" "浏览器" "10" "退出"  3>&1 1>&2 2>&3)
case $itu in
2)
WEB_BROWSER
;;
*)
echo 提示:
echo 正在开发
sleep 2
MENU
;;
10)
exit 1
;;

esac
;;
esac
}
##
WEB_BROWSER(){
	apui=$(whiptail --clear --title "install app" --menu "请选择需要安装的浏览器" 15 45 7 "1" "Google Chrome" "2" "FireFox 火狐浏览器" "10" "退出"  3>&1 1>&2 2>&3)
	case $apui in
	1)
		echo -e "安装谷歌浏览器chromium"
		if grep -q 'ID=debian' "/etc/os-release"; then
			$sudo_t apt install chromium -y
		elif grep -q 'ID=kali' "/etc/os-release"; then
			$sudo_t apt install chromium -y
		elif grep -q 'bionic' "/etc/os-release"; then
			$sudo_t apt install chromium-browser chromium-codecs-ffmpeg-extra -y
		elif grep -q 'ID=ubuntu' "/etc/os-release"; then 
		sleep 2
CURL="http://ppa.launchpad.net/xalt7x/chromium-deb-vaapi/ubuntu/pool/main/c/chromium-browser/"
BRO="$(curl $CURL | grep $ARCH_qp | head -n 2 | tail -n 1 | cut -d '"' -f 8)"
aria2c -x 8 -d ./  -o chromium.deb ${CURL}${BRO}
BRO_FF="$(curl $CURL | grep $ARCH_qp.deb | grep ffmpeg | tail -n 3 | head -n 1 | cut -d '"' -f 8)"
aria2c -x 8 -d ./ -o chromium_ffmpeg.deb ${CURL}${BRO_FF}
aria2c -x 8 -d ./ -o chromium-browser-l10n.deb http://ppa.launchpad.net/xalt7x/chromium-deb-vaapi/ubuntu/pool/main/c/chromium-browser/$(curl http://ppa.launchpad.net/xalt7x/chromium-deb-vaapi/ubuntu/pool/main/c/chromium-browser/ | grep chromium-browser-l10n | awk -F 'href="' '{print $2}' | cut -d '"' -f 1 | tail -n 1)
$sudo_t dpkg -i chromium.deb
$sudo_t dpkg -i chromium_ffmpeg.deb
$sudo_t dpkg -i chromium-browser-l10n.deb
rm chromium*
sudo echo "chromium-browser hold" | sudo dpkg --set-selections
sudo echo "chromium-browser-l10n hold" | sudo dpkg --set-selections
sudo echo "chromium-codecs-ffmpeg-extra hold" | sudo dpkg --set-selections
$sudo_t apt --fix-broken install -y
echo -e "如安装失败，请重试"
WEB_BROWSER 
else
        echo -e "${RED}你用的不是Debian或Ubuntu系统，操作将中止...${RES}"
sleep 2
WEB_BROWSER
fi
	if [ -e /usr/share/applications/chromium.desktop ]; then
		sed -i "s/Exec=\/usr\/bin\/chromium %U/Exec=\/usr\/bin\/chromium --no-sandbox \%U/g" /usr/share/applications/chromium.desktop
	elif [ -e /usr/share/applications/chromium-browser.desktop ]; then
		sed -i "s/Exec=chromium-browser %U/Exec=chromium-browser --no-sandbox \%U/g" /usr/share/applications/chromium-browser.desktop
		fi
		echo -e "${YELLOW}done..${RES}"
	sleep 1
	WEB_BROWSER
	;;
2)
	echo -e "${YELLOW}安装火狐浏览器firefox${RES}"
	if grep -q 'ID=debian' "/etc/os-release"; then                 $sudo_t apt install firefox-esr -y && sed -i "s/firefox-esr %u/firefox-esr --no-sandbox \%u/g" /usr/share/applications/firefox-esr.desktop 2>/dev/null
		elif grep -q 'ID=kali' "/etc/os-release"; then
			$sudo_t apt install firefox-esr -y && sed -i "s/firefox-esr %u/firefox-esr --no-sandbox \%u/g" /usr/share/applications/firefox-esr.desktop 2>/dev/null
	elif grep -q 'ID=ubuntu' "/etc/os-release"; then
		$sudo_t apt install firefox firefox-locale-zh-hans ffmpeg
	else
		echo -e "${RED}你用的不是Debian或Ubuntu系统，操作将中止...${RES}"
		sleep 2
		WEB_BROWSER
	fi
	if grep -q '^ex.*MOZ_FAKE_NO_SANDBOX=1' /etc/environment; then
		printf "%s\n" "MOZ_FAKE_NO_SANDBOX=1" /etc/environment
	else
		echo 'export MOZ_FAKE_NO_SANDBOX=1' >>/etc/environment
	fi
	if ! grep -q 'PATH' /etc/environment; then
		sed -i '1i\PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"' /etc/environment
	fi
	if ! grep -q 'environment' /etc/profile; then
		echo 'source /etc/environment' >>/etc/profile
	fi
	WEB_BROWSER
	;;
	10)MENU ;;
	*)
		WEB_BROWSER
		;;
esac
}
intp(){
    date_t=`date +"%D"`
    hiopk="$date_t+1"
if ! grep -q $hiopk ".date_tmp1.log" 2>/dev/null; then
      echo $hiopk >>.date_tmp1.log 2>&1
      if [ $PATHG = GNU/Linux ]
      then
      echo 检查执行此功能所需要的依赖
      apt update
      apt install -y zstd
      apt install -y dialog
      apt install -y whiptail
      apt install -y whoopsie
      else
      echo 检查执行此功能所需要的依赖
      apt update
      apt install -y zstd
      apt install -y proot
      apt install -y dialog
      apt install -y whiptail
      apt install -y pulseaudio
      fi
      fi
      }
###
updated(){
#git clone https://gitee.com/yudezeng/proot_proc 
echo 从服务器获取最新版本..
mkdir proot_proc
wget -o l.log -O proot_proc/version  https://gitee.com/yudezeng/proot_proc/raw/master/version
wget -o l.log -O proot_proc/ord  https://gitee.com/yudezeng/proot_proc/raw/master/ord
version=$(cat proot_proc/version)
larv=$(cat proot_proc/ord)
sleep 1
echo 检测到最新版本为version $version
sleep 1
echo 当前版本为$stv
if [ $larv -gt $srv ]
then
echo 当前版本需要升级
echo 开始拉取最新版本
#git clone https://gitee.com/yudezeng/yutools
newm=yutoolsv$version.sh 
wget -o l.log -O yutools.sh https://gitee.com/yudezeng/yutools/raw/master/$newm
#cp yutools/$newm ./yutools.sh
chmod 777  -v yutools.sh
rm -rf yutools proot_proc
      if [ $PATHG = Android ]
      then
      cp -v ./yutools.sh  /data/data/com.termux/files/usr/bin/yutoolsw
      else
      cp -v ./yutools.sh /usr/bin/yutoolsw
      fi
      echo 下载完成，您可以输入./yutools.sh 来打开此脚本
      echo 或者直接输入yutoolsw
exit 1
sleep 1
else
echo 本地版本为最新版本
echo 将无需升级
fi
rm -rf proot_proc
echo "是否继续使用？ [y/n]"
read -p " " up
case $up in 
y | yes | Y )
if [ $PATHG = "GNU/Linux" ]
then
if [ $archok = "arch" ]
then
menui
else
MENU
fi
else
main_
fi
;;
n | no | N )exit 1
;;
esac
}
###
dti(){
#git clone https://gitee.com/yudezeng/proot_proc 
echo 正在从服务器获取最新的版本号
mkdir proot_proc
wget -o l.log -O proot_proc/version  https://gitee.com/yudezeng/proot_proc/raw/master/version
wget -o l.log -O proot_proc/ord  https://gitee.com/yudezeng/proot_proc/raw/master/ord
version=$(cat proot_proc/version)
larv=$(cat proot_proc/ord)
sleep 1
echo 检测到最新版本为version $version
sleep 1
echo 开始下载云端最新版本至本地
#git clone https://gitee.com/yudezeng/yutools
newm=yutoolsv$version.sh
#cp yutools/$newm ./yutools.sh
wget -o l.log -O yutools.sh  https://gitee.com/yudezeng/yutools/raw/master/$newm
chmod 777  -v yutools.sh
rm -rf yutools proot_proc
      if [ $PATHG = Android ]
      then
      cp -v ./yutools.sh  /data/data/com.termux/files/usr/bin/yutoolsw
      else
      cp -v ./yutools.sh /usr/bin/yutoolsw
      fi
      echo 下载完成，您可以输入./yutools.sh 来打开此脚本
      echo 或者直接输入yutoolsw
      echo 启动此脚本
    exit 1
}
setvnc(){
    echo setting vnc
apt install tigervnc* 
mkdir .vnc 
rm -rfv ./.vnc/xstartup
cat > xstartup <<- EOM
#!/bin/sh
xrdb "$HOME/.Xresources"
xsetroot -solid grey
xfce4-session
#x-terminal-emulator -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
#x-window-manager &
# Fix to make GNOME work
export XKL_XMODMAP_DISABLE=1
/etc/X11/Xsession
EOM
chmod -v 777 xstartup
cp -v xstartup ./.vnc/
rm -v xstartup
echo 完成配置
cat > svnc.sh <<- EOM
if [ -e .2 ]
then
echo 正在关闭vnc
tigervncserver -kill :2
rm -rf .2
else
echo 本机连接地址为 localhost:2
tigervncserver :2
mkdir .2
fi
EOM
chmod  -v 777 svnc.sh
echo 输入./svnc.sh可以启动VNC
echo 输入./svnc.sh可以关闭VNC
sleep 4
}
##
SYS_SELECT_(){
opti=$(whiptail --clear --title "选择系统" --menu "选择你要安装的系统" 15 45 7 "1" "debian" "2" "ubuntu" "3" "kali" "4" "centos" "5" "arch" "6" "fedora"  "7" "从本地安装" "10" "退出"  3>&1 1>&2 2>&3)
case $opti in
	1)input=$(whiptail --clear --title "选择debian的哪个系统？" --menu "请选择" 15 45 7 "1" "debian 10 (buster)" "2" "debian 11 (bullseye)" "3" "debian sid" "0" "退出" 3>&1 1>&2 2>&3)
		name=debian
		mkdir debian
		case $input in
			1) echo "即将下载安装debian(buster)"
		sys_name=buster
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/debian/buster/$ARCH/default/" ;;
	2) echo "即将下载安装debian(bullseye)"        
		sys_name=bullseye  
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/debian/bullseye/$ARCH/default/" ;;
	3) echo "即将下载安装debian(sid)"
		sys_name=sid
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/debian/sid/$ARCH/default/" ;;
		9) MAIN ;;
		0) echo -e "\nexit"
			sleep 1                           
			exit 0 ;;                           
	*) INVALID_INPUT                                     
		SYS_SELECT ;;
esac ;;
2) input=$(whiptail --clear --title "选择ubuntu的哪个系统？" --menu "请选择" 15 45 7 "1" "ubuntu 18.04 (bionic)" "2" "ubuntu 20.04 (focal)" "3" "ubuntu 22.04 (impish)" "0" "退出"  3>&1 1>&2 2>&3 )                     
	name=ubuntu
	mkdir ubuntu
	case $input in
	1) echo "即将下载安装ubuntu(bionic)"
		sys_name=bionic
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/ubuntu/bionic/$ARCH/default/" ;;
	2) echo "即将下载安装ubuntu(focal)"
		sys_name=focal
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/ubuntu/focal/$ARCH/default/" ;;
	3) echo "即将下载安装ubuntu(impish)"
		sys_name=impish
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/ubuntu/impish/$ARCH/default/" ;;
	9) MAIN ;;                         
		0) echo -e "\nexit"     
			sleep 1                               
			exit 0 ;;                         
		*) INVALID_INPUT                             
			SYS_SELECT ;;
	esac ;;
	3) echo "即将下载安装kali"
                sys_name=kali
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/kali/current/$ARCH/default/" ;;
	4) echo "即将下载安装centos"
                sys_name=centos
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/centos/9-Stream/$ARCH/default/" ;;
	5) echo "即将下载安装arch"
                sys_name=arch
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/archlinux/current/$ARCH/default/" ;;
	6) echo "即将下载安装fedora"
		sys_name=fedora       
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/fedora/35/$ARCH/default/" ;;
	7) 
	lfi ;;
	10) #echo -e "\nexit..."
		sleep 1
		main_;;

	*)echo 没有此选项 
	;;
esac
}
lfi(){
    echo 请确保您的文件已经放入
     echo "/sdcard/download/"目录
     echo 请输入要安装的文件名
     echo 默认格式为 .tar.xz
     echo 如果不是此格式的文件可能将无法解压
     ls /sdcard/Download/
     echo 请输入文件名:
     read -p " " namel
     echo 请输入要安装的系统名字
     echo 是rootfs文件的所属的系统
     echo 尽量是系统版本代号
     
     read -p " " sys_name
     echo 请输入架构
     read -p " " AH
     
     echo "获取: /sdcard/download/$namel "
      intsr
      SYS_SET
      if [ $AH = $ARCH_qp ]
      then
      FIN
      else
      echo 例如
      echo "x86 = i386"
      echo "x64 = x86_64"
      echo "arm(armhf)(armv7) = arm "
      echo "arm64(aarch64)(armv8)(armv9) = aarch64 "
      echo 请输入使用的qemu架构
      read -p " " apou
      qemu=qemu-$apou-static
      FIN_
      fi
      sleep 1
}
tuip(){
trap 'onCtrlC' INT
function onCtrlC () {
        kill -9 ${do_sth_pid} ${progress_pid}
        echo
        echo 'Ctrl+C is captured'
        exit 1
}

do_sth() {
        
		if [ -e $sys_name-$AH ]; then
			echo 检测到之前已安装的系统
			echo "正在删除之前的系统        "			
		rm -rf $sys_name-$AH
		fi
        mkdir $sys_name-$AH
echo -e "正在解压系统包            "
		tar xf ${BAGNAME} -C $sys_name-$AH 2>/dev/null
		rm ${BAGNAME}
}

progress() {
        local main_pid=$1
        local length=20
        local ratio=1
        while [ "$(ps -p ${main_pid} | wc -l)" -ne "1" ] ; do
                mark='#'
                progress_bar=
                for i in $(seq 1 "${length}"); do
                        if [ "$i" -gt "${ratio}" ] ; then
                                mark='-'
                        fi
                        progress_bar="${progress_bar}${mark}"
                done
                printf "当前进度: ${progress_bar}\r"
                ratio=$((ratio+1))
                #ratio=`expr ${ratio} + 1`
                if [ "${ratio}" -gt "${length}" ] ; then
                        ratio=1
                fi
                sleep 1
        done
}

do_sth &
do_sth_pid=$(jobs -p | tail -1)

progress "${do_sth_pid}" &
progress_pid=$(jobs -p | tail -1)

wait "${do_sth_pid}"
printf "操作已结束                     \n"
}
SYSLIST_(){
     input=$(whiptail --clear --title "选择哪个系统？" --menu "由于绝大部分系统不兼容x86，以下这些系统是兼容x86" 15 45 5 "1" "ubuntu 18.04 (bionic)" "2" "debian 10 (buster)" "3" "debian sid" "4" "debian 11 (bullseye)" "0" "退出"  3>&1 1>&2 2>&3 )
		case $input in
			2) echo "即将下载安装debian(buster)"
		name=debian
		sys_name=buster
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/debian/buster/$ARCH/default/" ;;
	4) echo "即将下载安装debian(bullseye)"        
		name=debian
		sys_name=bullseye  
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/debian/bullseye/$ARCH/default/" ;;
	3) echo "即将下载安装debian(sid)"
		name=debian
		sys_name=sid
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/debian/sid/$ARCH/default/" ;;
	1)echo "即将下载安装ubuntu18.04 (bionic)"
	    name=ubuntu
	    sys_name=bionic
		DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/ubuntu/bionic/$ARCH/default/" ;;
		0) echo -e "\nexit"
			sleep 1                           
			exit 0 ;;                           
	*) echo 您的选择有误                                      ;;
esac 
mkdir $name
	
}
ts(){
    pot=$(whiptail --clear --title "主菜单" --menu "请选择你要执行的功能" 15 45 7 "0" "yti adb tools (beta)" "1" "换源" "2" "修复termux openSSL 3.0报错" "10" "退出"  3>&1 1>&2 2>&3)
opk
}    
opk(){
    case $pot in
    0)
    adb_tools
    ;;
    1)
    if (whiptail --title "你是否要继续？" --yes-button "继续" --no-button "取消"  --yesno "此操作会修改源地址文件" 10 45) then  
    
echo 
echo set apps sources
sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.bfsu.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list &&sed -i 's@^\(deb.*games stable\)$@#\1\ndeb https://mirrors.bfsu.edu.cn/termux/game-packages-24 games stable@' $PREFIX/etc/apt/sources.list.d/game.list &&sed -i 's@^\(deb.*science stable\)$@#\1\ndeb https://mirrors.bfsu.edu.cn/termux/science-packages-24 science stable@' $PREFIX/etc/apt/sources.list.d/science.list &&apt update && apt upgrade
else
main_
fi
;;
2)
echo 开始修复
git clone -b master https://gitee.com/yudezeng/proot_proc
cp -rv proot_proc/src/openssl.tar.xz ./openssl.tar.xz
rm -rf proot_proc
mkdir tmp
tar xvf openssl.tar.xz -C tmp
mv /data/data/com.termux/files/usr/etc/ssl /data/data/com.termux/files/usr/etc/ssl_old -v
#mv /data/data/com.termux/files/usr/etc/ssl /data/data/com.termux/files/usr/etc/ssl_old -v
cp -rv  tmp/etc/ssl /data/data/com.termux/files/usr/etc/ssl
cp -rv  tmp/usr/* /data/data/com.termux/files/usr/
sleep 2
echo 修复完成
sleep 4
rm -rf tmp
main_
;;
10)exit 1;;
esac
}
tsn(){
    echo "1)换源"
    echo "10)退出"
    read -p " " pot
    opk
}
#####
fio(){
    rm debian ubuntu .x -rf
}
###
new_user(){
do_you_want_to_create_a_new_user() {
		if (whiptail --title "NEW USER" --yes-button "YES" --no-button "NO" --yesno 'Do you want to create a new sudo user?\n请问您是否想要新建一个sudo用户呢?' 0 0); then
			TIPS_01="请输入用户名(可以为英文或数字,不能为特殊字符)\n please type the user name."
			please_type_the_user_name
		fi
}
please_type_the_user_name() {
	unset USER_NAME
	USER_NAME=$(whiptail --inputbox "${TIPS_01}" 0 0 --title "USER NAME" 3>&1 1>&2 2>&3)
	if [[ "$?" != "0" || -z "${USER_NAME}" ]]; then
		printf "%s\n" "The value is empty,please re-enter.Press enter to return."
		read
		do_you_want_to_create_a_new_user
	elif [[ ${USER_NAME} = root ]]; then
		printf "%s\n" "Sorry,please re-enter.Press enter to return."
		read
		do_you_want_to_create_a_new_user
	elif [[ ! ${USER_NAME} =~ ^[0-9A-Za-z]+$ ]]; then
		printf "%s\n" "检测到特殊字符,请输入英文或数字,请勿输入特殊字符。"
		printf "%s\n" "Please re-enter.Press enter to return"
		read
		please_type_the_user_name
	else
		if [ $(command -v useradd) ]; then
			useradd -m "${USER_NAME}"
		else
			adduser -D "${USER_NAME}"
		fi

		please_type_the_passwd
	fi
}
please_type_the_passwd() {
	PASSWORD_01=$(whiptail --inputbox "Please type the password" 9 40 --title "PASSWORD/密鑰/密码/Пароль/암호" 3>&1 1>&2 2>&3)
	if [[ "$?" != "0" || -z "${PASSWORD_01}" ]]; then
		printf "%s\n" "The value is empty,please re-enter.Press enter to return."
		read
		please_type_the_passwd
	else
		change_the_password
	fi
}
change_the_password() {
	# PASSWORD_02=$(whiptail --passwordbox "Please retype the password" 9 40 --title "PASSWORD" 3>&1 1>&2 2>&3)
	# if [[ "$?" != "0" || -z "${PASSWORD_02}" ]]; then
	# 	printf "%s\n" "The value is empty,please re-enter.Press enter to return."
	# 	read
	# 	change_the_password
	# elif [[ ${PASSWORD_01} != ${PASSWORD_02} ]]; then
	# 	printf "%s\n" "${RED}Sorry${RESET}, the two passwords are ${PURPLE}inconsistent${RESET}"
	# 	printf "%s\n" "Please re-enter.Press enter to return"
	# 	read
	# 	do_you_want_to_create_a_new_user
	# else
	printf "%s\n" "${USER_NAME}:${PASSWORD_01}" | chpasswd
	printf "%s\n" "root:${PASSWORD_01}" | chpasswd
	unset PASSWORD_01 PASSWORD_02
	TMOE_ROOT_SUDO_LINE=$(grep 'root.*ALL' -n /etc/sudoers | tail -n 1 | cut -d ':' -f 1)
	#TMOE_USER_SUDO_LINE=$((TMOE_ROOT_SUDO_LINE + 1))
	if [ -z "${TMOE_ROOT_SUDO_LINE}" ]; then
		sed -i "$ a ${USER_NAME}    ALL=(ALL:ALL) NOPASSWD:ALL" /etc/sudoers
	else
		sed -i "${TMOE_ROOT_SUDO_LINE}a ${USER_NAME}    ALL=(ALL:ALL) NOPASSWD:ALL" /etc/sudoers
	fi
	sed -n p /etc/sudoers
	for i in /sdcard /storage/self/primary /storage/emulated/0 /sd; do
		if [[ -e ${i} ]]; then
			ln -svf ${i} /home/${USER_NAME}/sd
			break
		fi
	done
	for i in /media/termux /root/termux; do
		if [[ -e ${i} ]]; then
			ln -svf ${i} /home/${USER_NAME}/termux
			break
		fi
	done
	for i in /storage/sdcard1 /root/tf; do
		if [[ -e ${i} ]]; then
			ln -svf ${i} /home/${USER_NAME}/tf
			break
		fi
	done
	if [[ -e /usr/local/bin/startvnc ]]; then
		ln -svf /usr/local/bin/startvnc /home/${USER_NAME}/startvnc
	fi
	touch /home/${USER_NAME}/.hushlogin
	chmod 666 /home/${USER_NAME}/.hushlogin
	chown -v "${USER_NAME}":"${USER_NAME}" /home/${USER_NAME}/.hushlogin
}
maian_(){
do_you_want_to_create_a_new_user
echo 现在您可以输入su -l $USER_NAME 进入刚刚创建的用户
}
maian_
}
###
intsr(){
         echo 请确保您的文件已经放入
     echo "/sdcard/download/"目录
     echo 请输入要安装的文件名
     echo 默认格式为 .tar.xz
     echo 如果不是此格式的文件可能将无法解压
     ls /sdcard/Download/
     echo 请输入文件名:
     read -p " " namel
     echo 请输入要安装的系统名字
     echo 是rootfs文件的所属的系统
     echo 尽量是系统版本代号
     
     read -p " " sys_name
     echo 请输入架构
     read -p " " AH
     
     echo "获取: /sdcard/Download/$namel "
      #cp -rv /sdcard/Download/$namel    ./$namel
      tupio
      mkdir $sys_name-$AH
	 tupior
	 # tar xvf $namel -C $sys_name 2>/dev/null
	 # cp -rv $sys_name/*/*  $sys_name-$AH/
 # rm -rf $sys_name
  #rm -rfv $namel
  tupiop
      
      sleep 1
}
tupiop(){   
trap 'onCtrlC' INT
function onCtrlC () {
        kill -9 ${do_sth_pid} ${progress_pid}
        echo
        echo 'Ctrl+C is captured'
        exit 1
}

do_sth() {
       rm -rf $sys_name
       rm -rf $namel
}

progress() {
        local main_pid=$1
        local length=3
        local ratio=1
        while [ "$(ps -p ${main_pid} | wc -l)" -ne "1" ] ; do
                mark='.'
                progress_bar=
                for i in $(seq 1 "${length}"); do
                        if [ "$i" -gt "${ratio}" ] ; then
                                mark=' '
                        fi
                        progress_bar="${progress_bar}${mark}"
                done
                printf "清理缓存 ${progress_bar}\r"
                ratio=$((ratio+1))
                #ratio=`expr ${ratio} + 1`
                if [ "${ratio}" -gt "${length}" ] ; then
                        ratio=1
                fi
                sleep 3
        done
}

do_sth &
do_sth_pid=$(jobs -p | tail -1)

progress "${do_sth_pid}" &
progress_pid=$(jobs -p | tail -1)

wait "${do_sth_pid}"
printf "清理缓存 √                 \n"
}
tupior(){   
trap 'onCtrlC' INT
function onCtrlC () {
        kill -9 ${do_sth_pid} ${progress_pid}
        echo
        echo 'Ctrl+C is captured'
        exit 1
}

do_sth() {
       XZ_OPT="-T 8"
       tar -xJf $namel -C $sys_name-$AH 2>/dev/null
}

progress() {
        local main_pid=$1
        local length=3
        local ratio=1
        while [ "$(ps -p ${main_pid} | wc -l)" -ne "1" ] ; do
                mark='.'
                progress_bar=
                for i in $(seq 1 "${length}"); do
                        if [ "$i" -gt "${ratio}" ] ; then
                                mark=' '
                        fi
                        progress_bar="${progress_bar}${mark}"
                done
                printf "复制文件 ${progress_bar}\r"
                ratio=$((ratio+1))
                #ratio=`expr ${ratio} + 1`
                if [ "${ratio}" -gt "${length}" ] ; then
                        ratio=1
                fi
                sleep 3
        done
}

do_sth &
do_sth_pid=$(jobs -p | tail -1)

progress "${do_sth_pid}" &
progress_pid=$(jobs -p | tail -1)

wait "${do_sth_pid}"
printf "复制文件 √                 \n"
}
tupio(){   
trap 'onCtrlC' INT
function onCtrlC () {
        kill -9 ${do_sth_pid} ${progress_pid}
        echo
        echo 'Ctrl+C is captured'
        exit 1
}

do_sth() {
       cp -rv /sdcard/Download/$namel    ./$namel
}

progress() {
        local main_pid=$1
        local length=3
        local ratio=1
        while [ "$(ps -p ${main_pid} | wc -l)" -ne "1" ] ; do
                mark='.'
                progress_bar=
                for i in $(seq 1 "${length}"); do
                        if [ "$i" -gt "${ratio}" ] ; then
                                mark=' '
                        fi
                        progress_bar="${progress_bar}${mark}"
                done
                printf "正在准备安装文件 ${progress_bar}\r"
                ratio=$((ratio+1))
                #ratio=`expr ${ratio} + 1`
                if [ "${ratio}" -gt "${length}" ] ; then
                        ratio=1
                fi
                sleep 3
        done
}

do_sth &
do_sth_pid=$(jobs -p | tail -1)

progress "${do_sth_pid}" &
progress_pid=$(jobs -p | tail -1)

wait "${do_sth_pid}"
printf "正在准备安装文件 √                      \n"
}
######
#adb tools
adb_tools(){
    apt install android-tools -y
    apt install android-tools-adb -y
menu_adb(){
    plk=$(whiptail --clear --backtitle "yti adb tools" --title " yti adb tools menu" --menu "请选择你要执行的功能" 15 65 7 "0" "配对并连接(需要安卓11及以上系统)" "1" "无线连接(需要先有线连接开启服务)通用办法" "10" "退出"  3>&1 1>&2 2>&3)
case $plk in
0)
connect_wlan_p
;;
1)
connect_wlan
;;
10)
exit 1
;;
esac
    
}
connect_wlan_p(){
    ipl=$(whiptail --backtitle "adb tools in yutools "  --title "ADB 无线调试配对" --inputbox "请先将termux分屏并在设置中打开无线调试中六位数的配对选项,在输入框内输入配对IP" 15 45 3>&1 1>&2 2>&3)
     echo "ip= $ipl "
     echo 请输入六位数配对码
     adb pair $ipl
     ipo=$(whiptail --backtitle "adb tools in yutools "  --title "ADB 连接" --inputbox "请先将termux分屏并在设置中打开无线调试,在输入框内输入IP地址和端口号" 15 45 3>&1 1>&2 2>&3)
     echo "ip= $ipo "
     adb connect $ipo
     if adb devices | grep -q devices ;then
     
     echo 已成功连接上此设备，您可以使用更多adb命令
     sleep 1
     echo 将自动打开shell
     adb shell
     else 
     if (whiptail --title "adb 连接失败" --yes-button "退出" --no-button "继续使用"  --yesno "未成功连接上此设备，请检查无线调试是否启用或IP和端口号输入正常" 10 60) then   
exit 1
else
menu_adb
fi
     fi
}
connect_wlan(){
    ipo=$(whiptail --backtitle "adb tools in yutools "  --title "ADB 连接" --inputbox "在输入框内输入IP地址和端口号" 10 60 3>&1 1>&2 2>&3)
     echo "ip= $ipo "
     adb connect $ipo
     if adb devices | grep -q devices ;then
     
     echo 已成功连接上此设备，您可以使用更多adb命令
     sleep 1
     echo 将自动打开shell
     adb shell
     else 
     if (whiptail --title "adb 连接失败" --yes-button "退出" --no-button "继续使用"  --yesno "未成功连接上此设备，请检查无线调试是否启用或IP和端口号输入正常" 10 60) then   
exit 1
else
menu_adb
fi
     fi
}
echo yti adb tools 测试版
sleep 2
echo 正在加载环境
sleep 3
menu_adb
     
     
     
    
}
######
#use arch
use_arch(){
updated_(){
    date_t=`date +"%D"`
if ! grep -q $date_t ".date_tmp.log" 2>/dev/null; then
        echo 检查软件更新
pacman -Syy
pacman -Syu git neofetch curl wget libnewt
        echo $date_t >>.date_tmp.log 2>&1
fi
     clear
     upytu
     readmek
     clear
     menui
}
menui(){
opt=$(whiptail --clear --backtitle "It's running on GNU/Linux for Arch " --title "主菜单" --menu "请选择你要执行的功能" 18 48 8 "0" "安装yay(针对没有yay的arch rootfs)" "01" "小白模式(只用输入安装的程序包名)" "1" "换源" "2" "安装桌面(当前仅支持xfce4)(仅安装)" "3" "新建用户" "4" "containers工具(没有适配)" "5" "下载脚本到本地" "6" "检查更新" "7"  "切换默认语言为中文(set language)" "8" "仅配置VNC(暂未适配）"  "10" "退出"  3>&1 1>&2 2>&3)
case $opt in
1)
echo reset app software ..
archd=$(file /bin/bash)
if (whiptail --backtitle "yutools for arch" --title "set app software" --yes-button "x86_64" --no-button "arm64"  --yesno "请选择你的架构" 10 60)
then
sudo pacman -S pacman-mirrorlist
sudo pacman -Syy
else
sudo pacman -S pacman-mirrorlist
sudo pacman -Syy
fi
exit 1
;;
3)
new_user
;;
2)
echo 如果出现选择按回车即可
pacman -Syu xfce4 xfce4-goodies 
pacman -Rsu xfce4-power-manager
exit 1
;;
4)
echo 暂时不支持此功能
#sudo apt install -y proot zstd pulseaudio
#main_
exit 1
;;
5)
dti
;;
6)
updated
;;
8)echo 暂时不支持此功能
exit 1
;;
7)
pacman -Syu noto-fonts-cjk
sed -i '/zh_CN.UTF/s/#//' /etc/locale.gen
locale-gen || /usr/sbin/locale-gen
sed -i '/^export LANG/d' /etc/profile
sed -i '1i\export LANG=zh_CN.UTF-8' /etc/profile
source /etc/profile
export LANG=zh_CN.UTF-8
exit 1
;;
10)
echo 退出
fio
exit 1
;;
0)git clone https://gitee.com/yudezeng/proot_proc/
pacman -Syu pv
pv ./proot_proc/src/yay.tar.xz >>./yay.tar.xz
pacman -U ./yay.tar.xz
rm -rf yay.tar.xz
rm -rf proot_proc
exit 1
;;
01)
if (whiptail --backtitle "yutools for arch" --title "install or uninstall" --yes-button "安装软件包" --no-button "卸载软件包"  --yesno "你想要做什么？" 10 60) then 
PET=$(whiptail --title "安装软件包" --inputbox "请输入软件包名" 10 60 3>&1 1>&2 2>&3)
pacman -Syu $PET
else
PETR=$(whiptail --title "卸载软件包" --inputbox "请输入软件包名" 10 60 3>&1 1>&2 2>&3)
pacman -Rsu $PETR
fi
exit 1
;;
esac
}
#####
updated_ "$@"
}
####
#yutools config
#please wait..
####### 
ls_old(){
if [ $PATHG = GNU/Linux ]
then
info_sys=$(cat /etc/os-release | grep PRETTY_NAME |awk -F'=' '{print $2}')
uert=$(whoami)
archok=$(cat /etc/os-release | grep ID_LIKE |awk -F'=' '{print $2}')
#pacmanu=$(ls /usr/bin/pacman)
echo 当前用户是$uert
sleep 2
echo 开始执行环境检测
if [ $archok = "arch" ]
then
echo 检测到你可能在使用$info_sys
echo 正在加载此环境适用的脚本
echo 检查当前用户是否有权限执行一些系统级别操作
if [ $uert = "root" ]
then
echo 当前用户是$uert，具有本脚本所需的权限
sleep 1
echo 本脚本可正常使用
use_arch
else
echo "错误:检测到当前使用的不是root用户"
echo "脚本可能会出现严重的兼容性错误,请使用root用户"
sleep 3
#echo 为了保障功能的使用，将自动退出
echo 为了保障功能的使用，将自动切换用户
sleep 2
echo 为了避免出现此错误，请使用sudo来运行此脚本
echo 或者使用Root用户来运行此脚本
sleep 1
echo 正在重新执行脚本，请稍等...
if [ `ls /usr/bin/yutoolsw 2>/dev/null` = "/usr/bin/yutoolsw" ]
then
sudo yutoolsw
else
sudo bash -c "$(curl https://gitee.com/yudezeng/yutools/raw/master/yti)"
fi
fi
#bash -c "$(curl -L https://gitee.com/yudezeng/yutools/raw/master/src/yutools_arch.sh)"
else
if [ $uert = "root" ]
then
echo 检测到您可能正在使用$info_sys
date_t=`date +"%D"`
if ! grep -q $date_t ".date_tmp.log" 2>/dev/null; then
apt update 
      apt install curl git neofetch  -y
        echo $date_t >>.date_tmp.log 2>&1
fi
#apt install curl git neofetch  -y
updatedt
echo 当前用户是$uert，具有本脚本所需的权限
sleep 1
echo 本脚本可正常使用
setup 
else
echo "错误:检测到当前使用的不是root用户"
echo "脚本可能会出现严重的兼容性错误,请使用root用户"
sleep 3
#echo 为了保障功能的使用，将自动退出
echo 为了保障功能的使用，将自动切换用户
sleep 2
echo 为了避免此错误的发生，请使用sudo来运行此脚本
echo 或者使用Root用户来运行此脚本
sleep 1
echo 正在重新执行脚本，请稍等...
if [ `ls /usr/bin/yutoolsw 2>/dev/null` = "/usr/bin/yutoolsw" ]
then
sudo yutoolsw
else
sudo bash -c "$(curl https://gitee.com/yudezeng/yutools/raw/master/yti)"
fi
#exit 1
fi
fi
else
apt install pulseaudio
updatedt
setup 
fi
fio
#main_"$@"
}
##
ls_(){
if [ $PATHG = GNU/Linux ]
then
info_sys=$(cat /etc/os-release | grep PRETTY_NAME |awk -F'=' '{print $2}')
uert=$(whoami)
archok=$(cat /etc/os-release | grep LOGO |awk -F'=' '{print $2}')
archx86=$(cat /etc/os-release | grep IMAGE_ID |awk -F'=' '{print $2}')
echo 当前用户是$uert
sleep 1
echo 开始执行环境检测
sleep 1
echo 检测到你可能在使用$info_sys
sleep 0.5
echo 正在加载此环境适用的功能
sleep 0.5
echo 检查当前用户是否有权限执行一些系统级别操作
sleep 1
if [ $uert = "root" ]
then
echo 当前用户是$uert，具有本脚本所需的权限
sleep 1
echo 本脚本可正常使用
if [ $archok = "archlinux-logo" ]
then
use_arch
else
date_t=`date +"%D"`
if ! grep -q $date_t ".date_tmp.log" 2>/dev/null; then
apt update 
      apt install curl git neofetch  -y
        echo $date_t >>.date_tmp.log 2>&1
fi
updatedt
setup
fi
else
echo "错误:检测到当前使用的不是root用户"
echo "脚本可能会出现严重的兼容性错误,请使用root用户"
sleep 3
#echo 为了保障功能的使用，将自动退出
echo 为了保障功能的使用，将自动切换用户
sleep 2
echo 为了避免此错误的发生，请使用sudo来运行此脚本
echo 或者使用Root用户来运行此脚本
sleep 1
echo 正在重新执行脚本，请稍等...
sleep 2
clear
if [ `ls /usr/bin/yutoolsw 2>/dev/null` = "/usr/bin/yutoolsw" ]
then
sudo yutoolsw
else
sudo bash -c "$(curl https://gitee.com/yudezeng/yutools/raw/master/yti)"
fi
exit 1
fi
else
updatedt
setup 
fi
fio
}
############
mainl(){
    case "$1" in
    -h* | --h*)
     echo "警告:此帮助信息仅针对于Android-termux"
     echo -h --help 显示帮助信息
     echo -p -proot 安装proot容器
     echo -px64 --proot-x86_64 安装arm64模拟x86_64proot容器
     echo -adb 打开yutools adb tools
     echo "* 按照默认顺序执行启动此脚本"
     ;;
    --proot-x86_64 | -px64 ) 
     ARCH=amd64
      AH=amd64
      qemu=qemu-x86_64-static
      SYS_SELECT_ 
      SYS_DOWN
      SYS_SET
      FIN_
     ;;
     -p | -proot )
     ARCH=$(ARCH_)
     AH=$(ARCH_)
     SYS_SELECT_
     SYS_DOWN
     SYS_SET
     FIN
     ;;
     -adb)
     adb_tools
     ;;
     -readme | --readme)
     readmek
     ;;
     -U | --list-update)
     upytu
     ;;
    *)ls_ ;;
    esac
}
########
mainl "$@"
#ls_old
#ls_