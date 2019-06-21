@echo off

::获取管理员权限
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

::命令行标题栏和文字颜色
title -- 系统代理 --
MODE con: COLS=43 lines=11
color 0a



::主菜单
:begin
cls
MODE con: COLS=43 lines=11
echo.
echo.          ===== 系统代理 =====
echo.
echo.   使用此功能前，务必先阅读使用说明！
echo.
echo.   --[1]--开启系统全局代理（IE代理）
echo.   --[2]--取消系统全局代理
echo.
choice /c 12 /n /m "请选择【1-2】："

echo %errorlevel%
if %errorlevel% == 1 goto install
if %errorlevel% == 2 goto uninstall



::取消系统代理
:uninstall
cls

taskkill /f /im iexplore.exe 1>nul 2>nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f 1>nul 2>nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /d "" /f 1>nul 2>nul

echo.
echo.
echo.
echo.
echo. 取消成功。
ping localhost -n 2 1>nul 2>nul
goto begin



::配置系统代理
:install
cls

taskkill /f /im iexplore.exe 1>nul 2>nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f 1>nul 2>nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /d "127.0.0.1:1087" /f 1>nul 2>nul

echo.
echo.
echo.
echo.
echo. 开启成功。
ping localhost -n 2 1>nul 2>nul
goto begin


