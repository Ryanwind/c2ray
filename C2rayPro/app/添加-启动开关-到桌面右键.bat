@echo off

::获取管理员权限
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

::命令行标题栏和文字颜色
title -- 添加-启动开关-到桌面右键 --
MODE con: COLS=53 lines=9
color 0a



::配置桌面右键菜单
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set menu-name=切换v2ray开关

set root-path=%cd%
cd ..

set bat-path=%cd%\启动或关闭[v2ray].bat
set "bat-path=%bat-path:\=\\%"
cd %root-path%

set reg-path=v2ray-menu

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



::主菜单
:begin
cls
MODE con: COLS=53 lines=9
echo.
echo.          ===== 添加-启动开关-到桌面右键 =====
echo.
echo.   --[1]--安装桌面右键快速启动菜单
echo.   --[2]--删除桌面右键快速启动菜单
echo.
choice /c 12 /n /m "请选择【1-2】："

echo %errorlevel%
if %errorlevel% == 1 goto install
if %errorlevel% == 2 goto uninstall

::卸载右键
:uninstall
cls
echo Windows Registry Editor Version 5.00 >>dkey.reg
echo [-HKEY_CLASSES_ROOT\DesktopBackground\Shell\%reg-path%] >>dkey.reg
echo [-HKEY_CLASSES_ROOT\DesktopBackground\Shell\%reg-path%\command] >>dkey.reg

ping localhost -n 2 1>nul 2>nul
regedit /s dkey.reg
del /q dkey.reg

echo.
echo.
echo 卸载成功。
ping localhost -n 2 1>nul 2>nul
goto begin

::安装右键
:install
cls

echo Windows Registry Editor Version 5.00 >>rkey.reg
echo [HKEY_CLASSES_ROOT\DesktopBackground\Shell\%reg-path%] >>rkey.reg
echo @="%menu-name%" >>rkey.reg
echo [HKEY_CLASSES_ROOT\DesktopBackground\Shell\%reg-path%\command] >>rkey.reg
echo @="%bat-path%" >>rkey.reg

ping localhost -n 2 1>nul 2>nul
regedit /s rkey.reg
del /q rkey.reg

echo.
echo.
echo 安装成功。
ping localhost -n 2 1>nul 2>nul
goto begin
