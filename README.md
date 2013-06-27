daemon
======

这是一个shell脚本写的守护程序，负责启动、守护、管理“指定的命令“

#下载和安装
将daemon.sh下载到程序目录并给其授以运行权限```chmod +x daemon.sh```


#用法

进入程序目录

启动服务

    ./daemon.sh start "command" interval

关闭服务

    ./daemon.sh stop
>注意： 所有操作必须要在程序所在目录完成


#日志
daemon会在程序目录产生4个文件

daemon.log        —— 主程序日志

daemon.master.log —— 守护程序日志

daemon.pid —— 主程序PID文件

daemon.master.pid —— 守护程序PID文件

#gitignore
如果程序所在目录位于git仓库中，请在.gitignore文件中增加

    *.pid
    *.log


#为什么要做这个东西
- 生产环境需要

- forever、supervisor等太占内存 

- 我闲的蛋疼



