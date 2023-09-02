#!/bin/env bash
if [[ "$1" == log ]];then
    if tmux ls | grep ${Bot_Name}
    then
        tmux attach -t ${Bot_Name}
    else
        if (dialog --yesno "${Bot_Name} [未启动] \n是否立刻启动${Bot_Name}" 8 50);then
            tmux new -s ${Bot_Name} "node app"
        fi
    fi
elif [[ "$1" == start ]];then
    if tmux ls | grep ${Bot_Name}
    then
        if (dialog --yesno "${Bot_Name} [已启动] \n是否打开${Bot_Name}窗口" 8 50);then
            tmux attach -t ${Bot_Name}
        fi
    else
        tmux new -s ${Bot_Name} "node app"
    fi
elif [[ "$1" == stop ]];then
    if tmux ls | grep ${Bot_Name}
    then
        tmux kill-session -t ${Bot_Name}
    else
        dialog --msgbox "${Bot_Name} [未启动]" 8 50
    fi
elif [[ "$1" == restart ]];then
    if tmux ls | grep ${Bot_Name}
    then
        tmux kill-session -t ${Bot_Name}
        tmux new -s ${Bot_Name} "node app"
    else
        dialog --msgbox "${Bot_Name} [未启动]" 8 50
    fi
fi