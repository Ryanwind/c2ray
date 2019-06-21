@echo off

::获取管理员权限
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

::命令行标题栏和文字颜色
title -- 便捷管理菜单 --
MODE con: COLS=53 lines=21
color 0a



::在此处设置多线路配置文件的路径
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::根目录默认线路
set config-file=%cd%\config.json

::配置多条线路
set config-root=app\config-files
set config-path=%cd%\%config-root%

set config-file-01=config-01.json
set config-file-02=config-02.json

set config-url-01=config-url-01.txt
set config-url-02=config-url-02.txt

set cmd-name=v2ray.exe
set exe-name=wv2ray.exe
set exe-path=%cd%\app\v2ray-windows-64

::程序/服务名称（注意大小写）
set sc-name=V2Ray
set nssm-name=%cd%\app\wv2ray-service.exe

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



::获取远程url内的配置文件
for /f "delims=" %%i in ('find "http" "%config-path%\%config-url-01%"')do set config-url-a=%%i
for /f "delims=" %%v in ('find "http" "%config-path%\%config-url-02%"')do set config-url-b=%%v

::检测内核文件是否存在
if exist "%exe-path%\%exe-name%" ( goto begin ) else ( goto fail )

::主菜单
:begin
tasklist /fi "imagename eq %exe-name%" 2>nul | find /i "%exe-name%" 1>nul 2>nul && ( set on2off=%sc-name%已运行 ) || ( set on2off=%sc-name%未运行 )
cls
MODE con: COLS=53 lines=21
echo.
%exe-path%\%exe-name% -version >%exe-path%\version.txt 2>nul
for /f "delims=" %%r in ('find "%sc-name%" "%exe-path%\version.txt"')do set v2version=%%r 1>nul 2>nul

echo.            ===== 便捷管理菜单 =====
echo.
echo.              当前状态::%on2off%
echo.         ===== socks5 监听端口 1080 =====
echo.
echo.   --[1]--启动/切换%sc-name%线路并隐藏窗口(%exe-name%)
echo.   --[2]--临时启动并显示进程窗口(%cmd-name%)
echo.
echo.   --[3]--安装开机自启动服务（管理员权限）
echo.   --[4]--卸载开机自启动服务（管理员权限）
echo.
echo.   --[5]--关闭%sc-name%后台进程
echo.   --[6]--升级%sc-name%程序内核
echo.
echo.   --注意--临时启动中测试正常后再安装为自启动服务
echo.   --当前版本：%v2version%
echo.
choice /c 123456 /n /m "请选择【1-6】："

echo %errorlevel%
if %errorlevel% == 1 goto set_1
if %errorlevel% == 2 goto set_2
if %errorlevel% == 3 goto set_3
if %errorlevel% == 4 goto set_4
if %errorlevel% == 5 goto set_5
if %errorlevel% == 6 goto set_6

::启动进程并加载配置
:set_1
cls
call :setconfig
MODE con: COLS=80 lines=16
sc stop %sc-name% 1>nul 2>nul
taskkill /im %exe-name% /f 1>nul 2>nul
cls
echo.
echo.
echo 程序正在启动中....
echo.
echo --[正在启动后台进程]--
echo.
start "" /d "%exe-path%\" "%exe-name%" -config=%jsonurl%
ping localhost -n 2 1>nul 2>nul
tasklist /fi "imagename eq %exe-name%"
echo.
tasklist /fi "imagename eq %exe-name%" 2>nul | find /i "%exe-name%" 1>nul 2>nul && ( set on2off=%sc-name%已运行-【启动成功】。按任意键关闭窗口 ) || ( set on2off=%sc-name%未运行-【启动失败】，请检查配置文件是否正确。按任意键关闭窗口 )
echo.
echo %on2off%
pause 1>nul 2>nul
exit

::启动进程并加载配置
:set_2
cls
call :setconfig
MODE con: COLS=80 lines=12
sc stop %sc-name% 1>nul 2>nul
taskkill /im %exe-name% /f 1>nul 2>nul
cls
echo.
echo --[正在启动前台进程]--
echo.
start "" /d "%exe-path%\" "%cmd-name%" -config=%jsonurl%
ping localhost -n 2 1>nul 2>nul
tasklist /fi "imagename eq %cmd-name%"
echo.
tasklist /fi "imagename eq %cmd-name%" 2>nul | find /i "%cmd-name%" 1>nul 2>nul && ( set on2off=%sc-name%已运行-【启动成功】。按任意键返回开始菜单 ) || ( set on2off=%sc-name%未运行-【启动失败】，请检查配置文件是否正确。按任意键返回开始菜单 )
echo.
echo %on2off%
pause 1>nul 2>nul
goto begin

::安装主程序为开机自启动系统服务
:set_3
cls
call :setconfig
MODE con: COLS=60 lines=18
sc stop %sc-name% 1>nul 2>nul
taskkill /im %exe-name% /f 1>nul 2>nul
cls
echo.
echo.
echo.
echo 正在获取【管理员权限】，请在弹出菜单中点【是】
echo.
echo.
echo --[正在安装服务]--
echo.
%nssm-name% install %sc-name% "%exe-path%\%exe-name%" 1>nul 2>nul
%nssm-name% set %sc-name% Start SERVICE_AUTO_START
%nssm-name% set %sc-name% DisplayName "%sc-name% Auto Start"
%nssm-name% set %sc-name% Description "%sc-name% 开机自启动服务（守护进程）"
%nssm-name% set %sc-name% AppParameters "-config=%jsonurl%"
echo.
echo.
echo 服务安装成功。按【任意键】启动服务，请在弹出菜单中点【是】
pause>nul
MODE con: COLS=80 lines=16
echo.
echo.
echo %sc-name%服务正在启动中....
echo.
echo.
echo --[正在启动服务]--
sc start %sc-name% 1>nul 2>nul
echo.
ping localhost -n 2 1>nul 2>nul
tasklist /fi "imagename eq %exe-name%"
echo.
tasklist /fi "imagename eq %exe-name%" 2>nul | find /i "%exe-name%" 1>nul 2>nul && ( set on2off=%sc-name%已运行-【启动成功】。按任意键返回开始菜单 ) || ( set on2off=%sc-name%未运行-【启动失败】，请检查配置文件是否正确。按任意键返回开始菜单 )
echo.
echo %on2off%
pause 1>nul 2>nul
goto begin

::卸载主程序自启动服务
:set_4
MODE con: COLS=70 lines=15
sc stop %sc-name% 1>nul 2>nul
taskkill /im %exe-name% /f 1>nul 2>nul
cls
echo.
echo.
echo.
echo 正在获取【管理员权限】，请在弹出菜单中点【是】
echo.
echo --[正在卸载自启动服务]--
%nssm-name% remove %sc-name% confirm
echo.
echo 请手动删除安装目录：%cd%
echo.
echo 卸载开机自启动服务成功。按任意键关闭窗口
pause 1>nul 2>nul
exit

::关闭后台进程和服务
:set_5
MODE con: COLS=60 lines=13
cls
echo.
echo.
echo.
echo 关闭%sc-name%后台（服务）进程....
echo.
echo --[正在关闭%sc-name%进程]--
sc stop %sc-name% 1>nul 2>nul
taskkill /im %exe-name% /f 1>nul 2>nul
ping localhost -n 2 1>nul 2>nul
tasklist /fi "imagename eq %exe-name%" 2>nul | find /i "%exe-name%" 1>nul 2>nul && ( set on2off=%sc-name%仍运行-【关闭失败】。请尝试重新执行关闭命令 ) || ( set on2off=%sc-name%未运行-【关闭成功】 )
echo.
echo %on2off%
echo.
echo 5秒后返回开始菜单
ping localhost -n 5 1>nul 2>nul
goto begin

::升级程序内核
:set_6
%cd%\app\升级内核.bat
exit

::未检测到内核提示
:fail
cls
MODE con: COLS=53 lines=12
echo.
echo.
echo.         ===============================
echo.
echo.           错误！未检测到 %sc-name% 内核
echo.
echo.         ===============================
echo.
echo. 按任意键开始安装 %sc-name% 内核。否则请直接关闭窗口
pause 1>nul 2>nul
%cd%\app\升级内核.bat
exit

::加载线路选择菜单
:setconfig
cls
MODE con: COLS=53 lines=21
echo.
echo.
echo.             ===== 便捷管理菜单 =====
echo.
echo.         ===== 请选择你要使用的线路 =====
echo.
echo.   --[1]--默认线路（根目录下 config.json）
echo.
echo.   --[2]--本地线路一（%config-file-01%）
echo.   --[3]--本地线路二（%config-file-02%）
echo.
echo.   --[4]--远程线路一（%config-url-01%）
echo.   --[5]--远程线路二（%config-url-02%）
echo.
echo.   --注意--你需要先行配置对应线路文件
echo.   --配置文件路径 --\%config-root%\
echo.
choice /c 12345 /n /m "请选择【1-5】："

echo %errorlevel%

if %errorlevel% == 1 set jsonurl=%config-file%

if %errorlevel% == 2 set jsonurl=%config-path%\%config-file-01%
if %errorlevel% == 3 set jsonurl=%config-path%\%config-file-02%

if %errorlevel% == 4 set jsonurl=%config-url-a%
if %errorlevel% == 5 set jsonurl=%config-url-b%

cls
MODE con: COLS=90 lines=10
echo.
echo.
echo.  ===============================
echo.
echo.  已选线路为:%jsonurl%
echo.  请确保该配置文件存在并可用。
echo.
echo.  ===============================
echo.
ping localhost -n 5 1>nul 2>nul
goto :eof


