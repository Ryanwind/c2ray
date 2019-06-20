@echo off

::获取管理员权限
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

::命令行标题栏和字体颜色
title -- 代理测速脚本 --
color 0a



::设置测速文件
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set test-file=http://cachefly.cachefly.net/100mb.test
set socks5-port=--socks5 127.0.0.1:1080

set test-web=https://www.google.com

set root-path=%cd%
set curl-path=%cd%\speed-test

set exe-name=wv2ray.exe

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



::检测进程是否已启动
tasklist /fi "imagename eq %exe-name%" 2>nul | find /i "%exe-name%" 1>nul 2>nul && ( goto gotest ) || ( goto goexit )



::开始测速
:gotest
cls
echo.
echo. 检测到 %exe-name% 已运行，开始测速。
cd %curl-path%
echo.
echo. 测速文件：%test-file%
echo. 文件大小：100M  测速时间：90秒
echo.
echo. 按任意键开始测速。如需取消测速，请直接关闭此窗口。
pause 1>nul 2>nul
echo.
echo. ===========================
echo.
del /a /f /s test.file 1>nul 2>nul

curl.exe %test-file% -m 90 -o test.file %socks5-port%

del /a /f /s test.file 1>nul 2>nul
echo.
echo. ===========================
echo.
echo. 开始测试 HTTP延时（TCP握手）、HTTPs延时（TCP握手+SSL握手）
echo. 测试网站：%test-web% 延时单位：秒
echo.
echo. ===========================
echo.

curl.exe -w "[test01] TCP handshake: %%{time_connect}, SSL handshake: %%{time_appconnect}\n" -so /dev/null %test-web% %socks5-port%

curl.exe -w "[test02] TCP handshake: %%{time_connect}, SSL handshake: %%{time_appconnect}\n" -so /dev/null %test-web% %socks5-port%

curl.exe -w "[test03] TCP handshake: %%{time_connect}, SSL handshake: %%{time_appconnect}\n" -so /dev/null %test-web% %socks5-port%

curl.exe -w "[test04] TCP handshake: %%{time_connect}, SSL handshake: %%{time_appconnect}\n" -so /dev/null %test-web% %socks5-port%

curl.exe -w "[test05] TCP handshake: %%{time_connect}, SSL handshake: %%{time_appconnect}\n" -so /dev/null %test-web% %socks5-port%

echo.
echo. ===========================
cd %root-path%
echo.
echo. 操作已完成，按任意键退出。
pause 1>nul 2>nul
exit



::未检测到进程
:goexit
cls
echo.
echo. 未检测到 %exe-name% 进程，请先配置并启动 %exe-name%。
echo.
echo. 操作已中止，按任意键退出。
pause 1>nul 2>nul
exit


