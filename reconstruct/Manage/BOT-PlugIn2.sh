#!/bin/env bash
export grey="\033[30m"
export red="\033[31m"
export green="\033[32m"
export yellow="\033[33m"
export blue="\033[34m"
export purple="\033[35m"
export cyan="\033[36m"
export white="\033[37m"
export background="\033[0m"

Install_GIT_Plugin(){
    
    number=
    
    function dialog_whiptail_page(){
        if (${dialog_whiptail} \
        --title "白狐-Bot-Plugin" \
        --yes-button "单选" \
        --no-button "多选" \
        --yesno "           请选择Git插件安装方式" \
        10 50)
        then
            Single_Choice="true"
            checklist_menu=menu
            OFF=
            tips=
        else
            Single_Choice="false"
            checklist_menu=checklist
            OFF=OFF
            tips="[空格选择 回车确定 空选取消]"
        fi
        if ! number=$(${dialog_whiptail} \
        --title "白狐-QQ群:705226976" \
        --${checklist_menu} "选择您喜欢的插件吧! ${tips}" \
        26 60 20 \
        "1" "miao-plugin                    喵喵插件" ${OFF} \
        "2" "xiaoyao-cvs-plugin             逍遥图鉴" ${OFF} \
        "3" "Guoba-Plugin                   锅巴插件" ${OFF} \
        "4" "zhi-plugin                     白纸插件" ${OFF} \
        "5" "xitian-plugin                  戏天插件" ${OFF} \
        "6" "Akasha-Terminal-plugin         虚空插件" ${OFF} \
        "7a" "xiuxian-plugin                 修仙插件" ${OFF} \
        "7b" "xiuxian-association            修仙-宗门" ${OFF} \
        "7c" "xiuxian-home                   修仙-家园" ${OFF} \
        "8" "Yenai-Plugin                   椰奶插件" ${OFF} \
        "9" "xiaofei-plugin                 小飞插件" ${OFF} \
        "10" "earth-k-plugin                 土块插件" ${OFF} \
        "11" "py-plugin                      py插件" ${OFF} \
        "12" "xianxin-plugin                 闲心插件" ${OFF} \
        "13" "lin-plugin                     麟插件" ${OFF} \
        "14" "L-plugin                       L插件" ${OFF} \
        "15" "qianyu-plugin                  千羽插件" ${OFF} \
        "16" "ql-plugin                      清凉图插件" ${OFF} \
        "17" "flower-plugin                  抽卡插件" ${OFF} \
        "18" "auto-plugin                    自动化插件" ${OFF} \
        "19" "recreation-plugin              娱乐插件" ${OFF} \
        "20" "suiyue-plugin                  碎月插件" ${OFF} \
        "21" "windoge-plugin                 风歌插件" ${OFF} \
        "22" "Atlas                          原神图鉴" ${OFF} \
        "23" "zhishui-plugin                 止水插件" ${OFF} \
        "24" "TRSS-Plugin                    trss插件" ${OFF} \
        "25" "Jinmaocuicuisha                脆脆鲨插件" ${OFF} \
        "26" "useless-plugin                 无用插件" ${OFF} \
        "27" "liulian-plugin                 榴莲插件" ${OFF} \
        "28" "xiaoye-plugin                  小叶插件" ${OFF} \
        "29" "rconsole-plugin                R插件" ${OFF} \
        "30" "expand-plugin                  扩展插件" ${OFF} \
        "31" "XiaoXuePlugin                  小雪插件" ${OFF} \
        "32" "Icepray                        冰祈插件" ${OFF} \
        "33" "Tlon-Sky                       光遇插件" ${OFF} \
        "34" "hs-qiqi-plugin                 枫叶插件" ${OFF} \
        "35" "call_of_seven_saints           七圣召唤插件" ${OFF} \
        "36" "QQGuild-Plugin                 QQ频道插件" ${OFF} \
        "37" "xiaoyue-plugin                 小月插件" ${OFF} \
        "38" "FanSky_Qs                      繁星插件" ${OFF} \
        "39" "phi-plugin                     phigros辅助插件" ${OFF} \
        "40" "ap-plugin                      ap绘图插件" ${OFF} \
        "41" "sanyi-plugin                   三一插件" ${OFF} \
        "42" "chatgpt-plugin                 聊天插件" ${OFF} \
        "43" "y-tian-plugin                  阴天插件" ${OFF} \
        "44" "xianyu-plugin                  咸鱼插件" ${OFF} \
        "45" "StarRail-plugin                星穹铁道插件" ${OFF} \
        "46" "panel-plugin                   面板图插件" ${OFF} \
        "47" "hanhan-plugin                  憨憨插件" ${OFF} \
        "48" "avocado-plugin                 鳄梨插件" ${OFF} \
        "49" "cunyx-plugin                   寸幼萱插件" ${OFF} \
        "50" "TianRu-plugin                  天如插件" ${OFF} \
        "51" "ws-plugin                      ws连接插件" ${OFF} \
        "52" "WeLM-plugin                    AI对话插件" ${OFF} \
        "53" "Yunzai-Kuro-Plugin             库洛插件" ${OFF} \
        "54" "mj-plugin                      AI绘图插件" ${OFF} \
        "55" "qinghe-plugin                  卿何插件" ${OFF} \
        "56" "BlueArchive-plugin             碧蓝档案插件" ${OFF} \
        "57" "impart-pro-plugin              牛牛大作战" ${OFF} \
        "58" "Gi-plugin                      群互动插件" ${OFF} \
        "59" "MC-PLUGIN                      MC服务器插件" ${OFF} \
        "60" "mz-plugin                      名字插件" ${OFF} \
        "61" "nsfwjs-plugin                  涩图监听插件" ${OFF} \
        "62" "biscuit-plugin                 饼干插件" ${OFF} \
        "63" "xrk-plugin                     向日葵插件" ${OFF} \
        "64" "WeChat-Web-plugin              微信插件" ${OFF} \
        "65" "btc-memz-plugin                BTC插件" ${OFF} \
        "66" "wind-plugin                    风插件" ${OFF} \
        "67" "ttsapi-yunzai-Plugin           TTS语音合成" ${OFF} \
        "68" "Xs-plugin                      XS插件" ${OFF} \
        "69" "GT-Manual                      米游社手动验证" ${OFF} \
        3>&1 1>&2 2>&3)
        then
            main
            exit
        fi
        if [[ -z ${number} ]];then
            echo
            echo -en ${red}输入错误 ${cyan}回车返回${background};read
            main
            exit
        fi
    }
    function echo_page(){
        echo
        echo
        echo -e ${white}"#######"${green}白狐-Plug-In${white}"#######"${background}
        echo -e ${green_red}1.  ${cyan}miao-plugin"               "喵喵插件${background}
        echo -e ${green_red}2.  ${cyan}xiaoyao-cvs-plugin"        "逍遥图鉴${background}
        echo -e ${green_red}3.  ${cyan}Guoba-Plugin"              "锅巴插件${background}
        echo -e ${green_red}4.  ${cyan}zhi-plugin"                "白纸插件${background}
        echo -e ${green_red}5.  ${cyan}xitian-plugin"             "戏天插件${background}
        echo -e ${green_red}6.  ${cyan}Akasha-Terminal-plugin"    "虚空插件${background}
        echo -e ${green_red}7a.  ${cyan}xiuxian-plugin"           "修仙插件${background}
        echo -e ${green_red}7b.  ${cyan}xiuxian-association"      "修仙-宗门${background}
        echo -e ${green_red}7c.  ${cyan}xiuxian-home"             "修仙-家园${background}
        echo -e ${green_red}8.  ${cyan}Yenai-Plugin"              "椰奶插件${background}
        echo -e ${green_red}9.  ${cyan}xiaofei-plugin"            "小飞插件${background}
        echo -e ${green_red}10. ${cyan}earth-k-plugin"           "土块插件${background}
        echo -e ${green_red}11. ${cyan}py-plugin"                "py插件${background}
        echo -e ${green_red}12. ${cyan}xianxin-plugin"           "闲心插件${background}
        echo -e ${green_red}13. ${cyan}lin-plugin"               "麟插件${background}
        echo -e ${green_red}14. ${cyan}L-plugin"                 "L插件${background}
        echo -e ${green_red}15. ${cyan}qianyu-plugin"            "千羽插件${background}
        echo -e ${green_red}16. ${cyan}ql-plugin"                "清凉图插件${background}
        echo -e ${green_red}17. ${cyan}flower-plugin"            "抽卡插件${background}
        echo -e ${green_red}18. ${cyan}auto-plugin"              "自动化插件${background}
        echo -e ${green_red}19. ${cyan}recreation-plugin"        "娱乐插件${background}
        echo -e ${green_red}20. ${cyan}suiyue-plugin"            "碎月插件${background}
        echo -e ${green_red}21. ${cyan}windoge-plugin"           "风歌插件${background}
        echo -e ${green_red}22. ${cyan}Atlas"                    "原神图鉴${background}
        echo -e ${green_red}23. ${cyan}zhishui-plugin"           "止水插件${background}
        echo -e ${green_red}24. ${cyan}TRSS-Plugin"              "trss插件${background}
        echo -e ${green_red}25. ${cyan}Jinmaocuicuisha"          "脆脆鲨插件${background}
        echo -e ${green_red}26. ${cyan}useless-plugin"           "无用插件${background}
        echo -e ${green_red}27. ${cyan}liulian-plugin"           "榴莲插件${background}
        echo -e ${green_red}28. ${cyan}xiaoye-plugin"            "小叶插件${background}
        echo -e ${green_red}29. ${cyan}rconsole-plugin"          "R插件${background}
        echo -e ${green_red}30. ${cyan}expand-plugin"            "扩展插件${background}
        echo -e ${green_red}31. ${cyan}XiaoXuePlugin"            "小雪插件${background}
        echo -e ${green_red}32. ${cyan}Icepray"                  "冰祈插件${background}
        echo -e ${green_red}33. ${cyan}Tlon-Sky"                 "光遇插件${background}
        echo -e ${green_red}34. ${cyan}hs-qiqi-plugin"           "枫叶插件${background}
        echo -e ${green_red}35. ${cyan}call_of_seven_saints"     "七圣召唤插件${background}
        echo -e ${green_red}36. ${cyan}QQGuild-Plugin"           "QQ频道插件${background}
        echo -e ${green_red}37. ${cyan}xiaoyue-plugin"           "小月插件${background}
        echo -e ${green_red}38. ${cyan}FanSky_Qs"                "繁星插件${background}
        echo -e ${green_red}39. ${cyan}phi-plugin"               "phigros辅助插件${background}
        echo -e ${green_red}40. ${cyan}ap-plugin"                "AI绘图插件${background}
        echo -e ${green_red}41. ${cyan}sanyi-plugin"             "三一插件${background}
        echo -e ${green_red}42. ${cyan}chatgpt-plugin"           "聊天插件${background}
        echo -e ${green_red}43. ${cyan}y-tian-plugin"            "阴天插件${background}
        echo -e ${green_red}44. ${cyan}xianyu-plugin"            "咸鱼插件${background}
        echo -e ${green_red}45. ${cyan}StarRail-plugin"          "星穹铁道插件${background}
        echo -e ${green_red}46. ${cyan}panel-plugin"             "面板图插件${background}
        echo -e ${green_red}47. ${cyan}hanhan-plugin"            "憨憨插件${background}
        echo -e ${green_red}48. ${cyan}avocado-plugin"           "鳄梨插件${background}
        echo -e ${green_red}49. ${cyan}cunyx-plugin"             "寸幼萱插件${background}
        echo -e ${green_red}50. ${cyan}TianRu-plugin"            "天如插件${background}
        echo -e ${green_red}51. ${cyan}ws-plugin"                "ws连接插件${background}
        echo -e ${green_red}52. ${cyan}WeLM-plugin"              "AI对话插件${background}
        echo -e ${green_red}53. ${cyan}Yunzai-Kuro-Plugin"       "库洛插件${background}
        echo -e ${green_red}54. ${cyan}mj-plugin"                "AI绘图插件${background}
        echo -e ${green_red}55. ${cyan}qinghe-plugin"            "卿何插件${background}
        echo -e ${green_red}56. ${cyan}BlueArchive-plugin"       "碧蓝档案插件${background}
        echo -e ${green_red}57. ${cyan}impart-pro-plugin"        "牛牛大作战${background}
        echo -e ${green_red}58. ${cyan}Gi-plugin"                "群互动插件${background}
        echo -e ${green_red}59. ${cyan}MC-PLUGIN"                "MC服务器插件${background}
        echo -e ${green_red}60. ${cyan}mz-plugin"                "名字插件${background}
        echo -e ${green_red}61. ${cyan}nsfwjs-plugin"            "涩图监听插件${background}
        echo -e ${green_red}62. ${cyan}biscuit-plugin"           "饼干插件${background}
        echo -e ${green_red}63. ${cyan}xrk-plugin"               "向日葵插件${background}
        echo -e ${green_red}64. ${cyan}WeChat-Web-plugin"        "微信插件${background}
        echo -e ${green_red}65. ${cyan}btc-memz-plugin"          "BTC插件${background}
        echo -e ${green_red}66. ${cyan}wind-plugin"              "风插件${background}
        echo -e ${green_red}67. ${cyan}ttsapi-yunzai-Plugin"     "TTS语音合成${background}
        echo -e ${green_red}68. ${cyan}Xs-plugin"                "XS插件${background}
        echo -e ${green_red}69. ${cyan}GT-Manual"                "米游社手动验证${background}
        echo
        echo -e ${green}0. ${cyan}返回${background}
        echo "#####################################"
        echo
        echo -en ${green}请输入您需要安装插件的序号,可以多选,用[空格]分开:${background}
        number=
        Single_Choice="false"
        read -p " " number
        if [ "${Number}" == "0" ];then
            main
            exit
        elif [ -z "${Number}" ];then
            echo
            echo -en ${red}输入错误 ${cyan}回车返回${background};read
            main
            exit
        fi
        } #echo_page
        choose_page
        number=$(echo ${number} | sed 's|"||g')
        for plugin_number in ${number}
        do
          case ${plugin_number} in
           1)
             Name="${Name} 喵喵插件"
             ;;
           2)
             Name="${Name} 逍遥图鉴"
             ;;
           3)
             Name="${Name} 锅巴插件"
             ;;
           4)
             Name="${Name} 白纸插件"
             ;;
           5)
             Name="${Name} 戏天插件"
             ;;
           6)
             Name="${Name} 虚空插件"
             ;;
           7a)
             Name="${Name} 修仙插件"
             ;;
           7b)
             Name="${Name} 修仙插件-宗门扩展"
             ;;
           7c)
             Name="${Name} 修仙插件-家园扩展"
             ;;
           8)
             Name="${Name} 椰奶插件"
             ;;
           9)
             Name="${Name} 小飞插件"
             ;;
           10)
             Name="${Name} 土块插件"
             ;;
           11)
             Name="${Name} py插件"
             ;;   
           12)
             Name="${Name} 闲心插件"
             ;;
           13)
             Name="${Name} 麟插件"
             ;;
           14)
             Name="${Name} L插件"
             ;;
           15)
             Name="${Name} 千羽插件"
             ;;
           16)
             Name="${Name} 清凉图插件"
             ;;
           17)
             Name="${Name} 抽卡插件"
             ;;
           18)
             Name="${Name} 自动化插件"
             ;;
           19)
             Name="${Name} 娱乐插件"
             ;;
           20)
             Name="${Name} 碎月插件"
             ;;
           21)
             Name="${Name} 风歌插件"
             ;;
           22)
             Name="${Name} Atlas[图鉴]"
             ;;
           23)
             Name="${Name} 止水插件"
             ;;
           24)
             Name="${Name} trss插件"
             ;;
           25)
             Name="${Name} 脆脆鲨插件"
             ;;
           26)
             Name="${Name} 无用插件"
             ;;
           27)
             Name="${Name} 榴莲插件"
             ;;
           28)
             Name="${Name} 小叶插件"
             ;;
           29)
             Name="${Name} R插件"
             ;;
           30)
             Name="${Name} 扩展插件"
             ;;
           31)
             Name="${Name} 小雪插件"
             ;;
           32)
             Name="${Name} 冰祈插件"
             ;;
           33)
             Name="${Name} 光遇插件"
             ;;
           34)
             Name="${Name} 枫叶插件"
             ;;
           35)
             Name="${Name} 七圣召唤插件"
             ;;
           36)
             Name="${Name} QQ频道插件"
             ;;
           37)
             Name="${Name} 小月插件"
             ;;
           38)
             Name="${Name} 繁星插件"
             ;;
           39)
             Name="${Name} phigros辅助插件"
             ;;
           40)
             Name="${Name} ap绘图插件"
             ;;
           41)
             Name="${Name} 三一插件"
             ;;
           42)
             Name="${Name} 聊天插件"
             ;;
           43)
             Name="${Name} 阴天插件"
             ;;
           44)
             Name="${Name} 咸鱼插件"
             ;;
           45)
             Name="${Name} 星穹铁道插件"
             ;;
           46)
             Name="${Name} 面板图插件"
             ;;
           47)
             Name="${Name} 憨憨插件"
             ;;
           48)
             Name="${Name} 鳄梨插件"
             ;;
           49)
             Name="${Name} 寸幼萱插件"
             ;;
           50)
             Name="${Name} 天如插件"
             ;;
           51)
             Name="${Name} ws连接插件"
             ;;
           52)
             Name="${Name} AI对话插件"
             ;;
           53)
             Name="${Name} 库洛插件"
             ;;
           54)
             Name="${Name} mj绘图插件"
             ;;
           55)
             Name="${Name} 卿何插件"
             ;;
           56)
             Name="${Name} 碧蓝档案插件"
             ;;
           57)
             Name="${Name} 牛牛大作战"
             ;;
           58)
             Name="${Name} 群互动插件"
             ;;
           59)
             Name="${Name} MC服务器插件"
             ;;
           60)
             Name="${Name} 名字插件"
             ;;
           61)
             Name="${Name} 涩图监听插件"
             ;;
           62)
             Name="${Name} 饼干插件"
             ;;
           63)
             Name="${Name} 向日葵插件"
             ;;
           64)
             Name="${Name} 微信插件"
             ;;
           65)
             Name="${Name} BTC插件"
             ;;
           66)
             Name="${Name} 风插件"
             ;;
           67)
             Name="${Name} TTS语音合成"
             ;;
           68)
             Name="${Name} XS插件"
             ;;
           69)
             Name="${Name} 米游社手动验证"
             ;;
           0)
             echo
             main
             ;;
          esac
        done
    






}






function main(){
function dialog_whiptail_page(){
number=$(${dialog_whiptail} \
--title "白狐" \
--menu "白狐的QQ群:705226976" \
20 40 10 \
"1" "安装GIT插件" \
"2" "安装JS插件" \
"3" "更新GIT插件" \
"4" "删除GIT插件" \
"5" "删除JS插件" \
"0" "返回/退出" \
3>&1 1>&2 2>&3)
feedback=$?
feedback
}
function echo_page(){
    echo
    echo
    echo -e ${white}"#####"${green}白狐-Yunzai-Bot${white}"#####"${background}
    echo -e ${blue}请选择您要为哪一个bot管理插件${background}
    echo "#########################"
    echo -e ${green}1.  ${cyan}安装GIT插件${background}
    echo -e ${green}2.  ${cyan}安装JS插件${background}
    echo -e ${green}3.  ${cyan}更新GIT插件${background}
    echo -e ${green}4.  ${cyan}删除GIT插件${background}
    echo -e ${green}5.  ${cyan}删除JS插件${background}
    echo -e ${green}0.  ${cyan}返回\/退出${background}
    echo "#########################"
    echo -e ${green}QQ群:${cyan}狐狸窝:705226976${background}
    echo "#########################"
    echo
    echo -en ${green}请输入您的选项: ${background};read number
}
choose_page
if [ -z ${number} ];then
    main
    exit
fi
if [ "${number}" == "1" ];then
    Install_GIT_Plugin
elif [ "${number}" == "2" ];then
    Install_JS_Plugin
elif [ "${number}" == "3" ];then
    Update_GIT_Plugin
elif [ "${number}" == "4" ];then
    Delete_GIT_Plugin
elif [ "${number}" == "5" ];then
    Delete_JS_Plugin
elif [ "${number}" == "0" ];then
    return
fi
}
}

function choose_path(){
function dialog_whiptail_page(){
    number=$(${dialog_whiptail} \
    --title "白狐 QQ群:705226976" \
    --menu "请选择您要为哪一个bot管理插件" \
    20 40 10 \
    "1" "Yunzai-Bot" \
    "2" "Miao-Yunzai" \
    "3" "yunzai-bot-lite" \
    "4" "TRSS-Yunzai" \
    "5" "Yxy-Bot" \
    "6" "切换文字版菜单" \
    "0" "退出" \
    3>&1 1>&2 2>&3)
feedback=$?
feedback
}
function echo_page(){
    echo
    echo
    echo -e ${white}"#####"${green}白狐-Yunzai-Bot${white}"#####"${background}
    echo -e ${blue}请选择您要为哪一个bot管理插件${background}
    echo "#########################"
    echo -e ${green}1.  ${cyan}Yunzai-Bot${background}
    echo -e ${green}2.  ${cyan}Miao-Yunzai${background}
    echo -e ${green}3.  ${cyan}yunzai-bot-lite${background}
    echo -e ${green}4.  ${cyan}TRSS-Yunzai${background}
    echo -e ${green}5.  ${cyan}Yxy-Bot${background}
    echo -e ${green}0.  ${cyan}退出${background}
    echo "#########################"
    echo -e ${green}QQ群:${cyan}狐狸窝:705226976${background}
    echo "#########################"
    echo
    echo -en ${green}请输入您的选项: ${background};read number
    #clear
}
choose_page

case ${number} in
1)
if [ -d /root/TRSS_AllBot ];then
  Bot_Name=Yunzai
else
  Bot_Name=Yunzai-Bot
fi
;;
2)
Bot_Name=Miao-Yunzai
;;
3)
Bot_Name=yunzai-bot-lite
;;
4)
Bot_Name=TRSS-Yunzai
;;
5)
Bot_Name=yxybot
;;
6)
Linux
export page=echo_page
pnpm_install
path
main
;;
0)
exit
;;
*)
echo
echo -e ${red}输入错误${background}
exit
;;
esac
if [ -d "/root/${Bot_Name}/node_modules" ];then
    export Plugin_Path="/root/${Bot_Name}"
    cd ${Plugin_Path}
elif [ -d "/root/.fox@bot/${Bot_Name}/node_modules" ];then
    export Plugin_Path="/root/.fox@bot/${Bot_Name}"
    cd ${Plugin_Path}
elif [ -d "/home/lighthouse/ubuntu/${Bot_Name}/node_modules" ];then
    export Plugin_Path="/home/lighthouse/ubuntu/${Bot_Name}"
    cd ${Plugin_Path}
elif [ -d "/home/lighthouse/centos/${Bot_Name}/node_modules" ];then
    export Plugin_Path="/home/lighthouse/centos/${Bot_Name}"
    cd ${Plugin_Path}
elif [ -d "/home/lighthouse/debian/${Bot_Name}/node_modules" ];then
    export Plugin_Path="/home/lighthouse/debian/${Bot_Name}"
    cd ${Plugin_Path}
elif [ -d "/root/TRSS_AllBot/${Bot_Name}/node_modules" ];then
    export Plugin_Path="/root/TRSS_AllBot/${Bot_Name}"
    cd ${Plugin_Path}
else
    function dialog_whiptail_page(){
        ${dialog_whiptail} --title "白狐≧▽≦" \
        --msgbox "自动判断路径失败 \n请进入${Bot_Name}目录后 使用本脚本" 10 43
        exit
    }
    function echo_page(){
        echo
        echo -e ${red}未在此目录下找到${name}的插件文件夹${background}
        echo -e ${red}请进入 ${name}目录 之后使用本脚本${background}
        exit
    }
    choose_page
fi
}

function package_install(){
if [ $(command -v apt) ];then
    pkg_install="apt install -y"
elif [ $(command -v yum) ];then
    pkg_install="yum install -y"
elif [ $(command -v dnf) ];then
    pkg_install="dnf install -y"
elif [ $(command -v pacman) ];then
    pkg_install="pacman -Syy --noconfirm --needed"
fi

function pkg_install(){
i=0
echo -e ${yellow}未安装${pkg} 开始安装${background}
if [ ! -z "$1" ];then
    pkg="$1"
fi
until ${pkg_install} ${pkg}
do
    if [ "${i}" == "3" ]
        then
            echo -e ${red}错误次数过多 退出${background}
            exit
    fi
    i=$((${i}+1))
    echo -en ${red}命令执行失败 ${green}3秒后重试${background}
    sleep 3s
    echo
done
}

pkg_list=("curl" "git")

for package in ${pkg_list[@]}
do
    if [ -x "$(command -v pacman)" ];then
        if ! pacman -Qs "${package}" > /dev/null 2>&1;then
            pkg="${package} ${pkg}" 
        fi
    elif [ -x "$(command -v apt)" ];then
        if ! dpkg -s "${package}" > /dev/null 2>&1;then
            pkg="${package} ${pkg}"
        fi
    elif [ -x "$(command -v yum)" ];then
        if ! yum list installed "${package}" > /dev/null 2>&1;then
            pkg="${package} ${pkg}"
        fi
    elif [ -x "$(command -v dnf)" ];then
        if ! dnf list installed "${package}" > /dev/null 2>&1;then
            pkg="${package} ${pkg}"
        fi
    fi
done

if [ ! -z "${pkg}" ]; then
    if [ -x "$(command -v pacman)" ];then
        if ! pacman -Qs "${package}" > /dev/null 2>&1;then
            pkg_install
        fi
    elif [ -x "$(command -v apt)" ];then
        if ! dpkg -s "${package}" > /dev/null 2>&1;then
            apt update
            pkg_install
        fi
    elif [ -x "$(command -v yum)" ];then
        if ! yum list installed "${package}" > /dev/null 2>&1;then
            yum update
            pkg_install
        fi
    elif [ -x "$(command -v dnf)" ];then
        if ! dnf list installed "${package}" > /dev/null 2>&1;then
            pkg_install
        fi
    fi
fi

if [ -x "$(command -v whiptail)" ];then
    dialog_whiptail=whiptail
elif [ -x "$(command -v dialog)" ];then
    dialog_whiptail=dialog
else
    package=dialog
    pkg_install dialog
    dialog_whiptail=dialog
fi
}

function pnpm_install(){
if [ ! -x "$(command -v pnpm)" ];then
    echo -e ${cyan}检测到未安装pnpm 开始安装${background}
    if [ ! -x "$(command -v npm)" ];then
        echo -e ${red}未安装npm${background}
        exit
    fi
    npm install -g pnpm --registry=https://registry.npmmirror.com
fi
}

function Linux(){
if [ ! -x "$(command -v curl)" ];then
    echo -e ${cyan}检测到未安装${red}curl${background}
    package_install
fi
if [ ! -x "$(command -v git)" ];then
    echo -e ${cyan}检测到未安装${red}git${background}
    package_install
fi
}-

function unLinux(){
if [ ! -x "$(command -v curl)" ];then
    echo -e ${cyan}检测到未安装${red}curl${background}
    exit
fi
if [ ! -x "$(command -v git)" ];then
    echo -e ${cyan}检测到未安装${red}git${background}
    exit
fi
}

function feedback(){
if [ ! "${feedback}" == "0" ];then
    exit
fi
}

function path(){
if [ -d "./node_modules" ];then
    export Plugin_Path="."
    cd ${Plugin_Path}
elif [ -d "../node_modules" ];then
    export Plugin_Path=".."
    cd ${Plugin_Path}
else
    choose_path
fi
}

function choose_page(){
if [ ${page} = dialog_whiptail_page ];then
    dialog_whiptail_page
elif [ ${page} = echo_page ];then
    echo_page
fi
}

function choose_echo_dialog_whiptail(){
if [ -x "$(command -v whiptail)" ];then
    export dialog_whiptail=whiptail
    export page=dialog_whiptail_page
elif [ -x "$(command -v dialog)" ];then
    export dialog_whiptail=dialog
    export page=dialog_whiptail_page
else 
    export page=echo_page
fi
}

if [ -e "/etc/issue" ];then
    Linux
    choose_echo_dialog_whiptail
    pnpm_install
    path
    main
elif [ -e "/etc/os-release" ];then
    Linux
    choose_echo_dialog_whiptail
    pnpm_install
    path
    main
else
    unLinux
    choose_echo_dialog_whiptail
    pnpm_install
    path
    main
fi
function mainbak()
{
   while true
   do
       main
       mainbak
   done
}
mainbak