@echo off

::��ȡ����ԱȨ��
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

::�����б�������������ɫ
title -- ϵͳ���� --
MODE con: COLS=43 lines=11
color 0a



::���˵�
:begin
cls
MODE con: COLS=43 lines=11
echo.
echo.          ===== ϵͳ���� =====
echo.
echo.   ʹ�ô˹���ǰ��������Ķ�ʹ��˵����
echo.
echo.   --[1]--����ϵͳȫ�ִ���IE����
echo.   --[2]--ȡ��ϵͳȫ�ִ���
echo.
choice /c 12 /n /m "��ѡ��1-2����"

echo %errorlevel%
if %errorlevel% == 1 goto install
if %errorlevel% == 2 goto uninstall



::ȡ��ϵͳ����
:uninstall
cls

taskkill /f /im iexplore.exe 1>nul 2>nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f 1>nul 2>nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /d "" /f 1>nul 2>nul

echo.
echo.
echo.
echo.
echo. ȡ���ɹ���
ping localhost -n 2 1>nul 2>nul
goto begin



::����ϵͳ����
:install
cls

taskkill /f /im iexplore.exe 1>nul 2>nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f 1>nul 2>nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /d "127.0.0.1:1087" /f 1>nul 2>nul

echo.
echo.
echo.
echo.
echo. �����ɹ���
ping localhost -n 2 1>nul 2>nul
goto begin


