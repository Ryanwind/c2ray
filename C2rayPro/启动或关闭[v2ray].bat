@echo Off

::获取管理员权限
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

::命令行标题栏和文字颜色
title -- 启动或关闭[v2ray] --
MODE con: COLS=38 lines=5
color 0a



:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::设置启动时要加载的 配置文件路径（支持本地文件或远程链接）
set config-path=-config=%cd%\config.json
::set config-path=-config=https://coding.net/u/Alvin9999/p/pac/git/raw/master/config.json

::内核路径（请勿改动）
set exe-path=%cd%\app\v2ray-windows-64
::进程名称（请勿改动）
set exe-name=wv2ray.exe

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



::检测进程是否已启动
tasklist /fi "imagename eq %exe-name%" 2>nul | find /i "%exe-name%" 1>nul 2>nul && ( goto gooff ) || ( goto gostart )



::启动进程
:gostart
taskkill /im %exe-name% /f 1>nul 2>nul
del /a /f /s %exe-path%\run.vbs 1>nul 2>nul

echo DIM objShell > %exe-path%\run.vbs
echo set objShell = wscript.createObject("wscript.shell") >> %exe-path%\run.vbs
echo iReturn = objShell.Run("cmd.exe /C %exe-path%\%exe-name% %config-path%", 0, TRUE) >> %exe-path%\run.vbs

cd %exe-path%
start run.vbs

set result-a=启动成功
set result-b=启动失败

call :gotest
echo.
echo.
echo. --- %exe-name% %exe-test% ---
echo.
ping localhost -n 3 1>nul 2>nul

del /a /f /s %exe-path%\run.vbs 1>nul 2>nul
exit



::关闭进程
:gooff
taskkill /im %exe-name% /f 1>nul 2>nul

set result-a=关闭失败
set result-b=关闭成功

call :gotest
echo.
echo.
echo. --- %exe-name% %exe-test% ---
echo.
ping localhost -n 3 1>nul 2>nul
exit



::检测执行结果
:gotest
ping localhost -n 2 1>nul 2>nul
tasklist /fi "imagename eq %exe-name%" 2>nul | find /i "%exe-name%" 1>nul 2>nul && ( set exe-test=已运行 %result-a% ) || ( set exe-test=未运行 %result-b% )
goto :eof


