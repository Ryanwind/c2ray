@echo off

::��ȡ����ԱȨ��
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

::�����б�������������ɫ
title -- ���-��������-�������Ҽ� --
MODE con: COLS=53 lines=9
color 0a



::���������Ҽ��˵�
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set menu-name=�л�v2ray����

set root-path=%cd%
cd ..

set bat-path=%cd%\������ر�[v2ray].bat
set "bat-path=%bat-path:\=\\%"
cd %root-path%

set reg-path=v2ray-menu

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



::���˵�
:begin
cls
MODE con: COLS=53 lines=9
echo.
echo.          ===== ���-��������-�������Ҽ� =====
echo.
echo.   --[1]--��װ�����Ҽ����������˵�
echo.   --[2]--ɾ�������Ҽ����������˵�
echo.
choice /c 12 /n /m "��ѡ��1-2����"

echo %errorlevel%
if %errorlevel% == 1 goto install
if %errorlevel% == 2 goto uninstall

::ж���Ҽ�
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
echo ж�سɹ���
ping localhost -n 2 1>nul 2>nul
goto begin

::��װ�Ҽ�
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
echo ��װ�ɹ���
ping localhost -n 2 1>nul 2>nul
goto begin
