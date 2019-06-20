@echo off

::获取管理员权限
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

::命令行标题栏和文字颜色
title -- 内核升级 --
color 0a



::升级服务器配置
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::版本检测源
set github-latest=https://api.github.com/repos/v2ray/v2ray-core/releases/latest

::wget路径
set wget-path=%cd%\update-tool

::主程序路径
set exe-path=%cd%\v2ray-windows-64

::主进程名称
set exe-name=wv2ray.exe

::程序/服务名称（注意大小写）
set sc-name=V2Ray

::升级包名称
set pg-name=v2ray-windows-64.zip

::升级包路径
set pg-path=https://github.com/v2ray/v2ray-core/releases/download

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



::关闭正在运行的进程
sc stop %sc-name% 1>nul 2>nul
taskkill /im %exe-name% /f 1>nul 2>nul

::从远程获取最新的版本号
cls
echo.
echo. 提示：升级过程较慢，请耐心等待！（由于 github 网络问题，大概需要10分钟）
echo.
echo. 正在准备升级...
echo.
del /s /Q "%cd%\%pg-name%" 1>nul 2>nul
del /s /Q "%cd%\latest" 1>nul 2>nul
echo. 正在获取最新版本号，请耐心等待！如长时间卡在进度条可尝试关闭重新启动
echo.
echo. 检测源：%github-latest%
echo.
%wget-path%\wget.exe --ca-certificate=%wget-path%\ca-bundle.crt -c %github-latest%

::截取版本号
for /f "delims=: tokens=2" %%i in ('find "tag_name" "%cd%\latest"')do set latestv=%%i
set latestv=%latestv:~2,-2%

::获取本地已安装的版本号
%exe-path%\%exe-name% -version >%exe-path%\version.txt 2>nul
for /f "delims=" %%r in ('find "%sc-name%" "%exe-path%\version.txt"')do set v2version=%%r
del /s /Q "%cd%\latest" 1>nul 2>nul

::升级提示
cls
echo.
echo. 检测完成。
echo.
echo. 最新版本号为：%sc-name% %latestv%
echo. 已安装版本为：%v2version%
echo.
echo. 升级源：%pg-path%
echo.
echo. 按任意键开始升级。如需取消升级，请直接关闭此窗口。
pause 1>nul 2>nul

::从远程下载最新的内核
cls
echo.
echo. 开始下载 %pg-name% 最新 %latestv% 版，请耐心等待！
echo.
%wget-path%\wget.exe --ca-certificate=%wget-path%\ca-bundle.crt -c %pg-path%/%latestv%/%pg-name%

::解压替换
cls
echo.
echo. 正在清理旧版...
echo.
rd /s /Q "%exe-path%" 1>nul 2>nul
echo. 开始升级！
md "%exe-path%" 1>nul 2>nul
echo.
%wget-path%\7zip.exe x %cd%\%pg-name% -o%exe-path%
del /s /Q "%cd%\%pg-name%" 1>nul 2>nul

::检测升级完的内核版本号
cls
echo.
echo. 升级完成。
%exe-path%\%exe-name% -version >%exe-path%\version.txt 2>nul
for /f "delims=" %%n in ('find "%sc-name%" "%exe-path%\version.txt"')do set nv2version=%%n
echo.
echo. 已升级为最新版。当前 %sc-name% 版本号：%nv2version%
echo.
echo. 按任意键启动%sc-name%服务（如果你已安装）。否则请直接关闭此窗口
pause 1>nul 2>nul

::启动服务
echo.
echo. 正在启动 %sc-name% 服务。
sc start %sc-name% 1>nul 2>nul
echo.
ping localhost -n 4 1>nul 2>nul
tasklist /fi "imagename eq %exe-name%"
echo.
tasklist /fi "imagename eq %exe-name%" 2>nul | find /i "%exe-name%" 1>nul 2>nul && ( set on2off=%sc-name%已运行-【启动成功】 ) || ( set on2off=%sc-name%未运行-【启动失败】，请先安装%sc-name%为开机自启动服务 )
echo.
echo. %on2off%。5秒后自动关闭此窗口
ping localhost -n 9 1>nul 2>nul
exit
