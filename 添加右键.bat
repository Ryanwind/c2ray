@echo off

::��ȡ����ԱȨ��
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

::�����б�������������ɫ
title -- v2ray��������ű� --
MODE con: COLS=53 lines=9
color 0a

::���˵�
:begin
cls
MODE con: COLS=53 lines=9
echo.
echo.          ===== v2ray��������ű� =====
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
echo [-HKEY_CLASSES_ROOT\DesktopBackground\Shell\V2ray] >>dkey.reg
echo [-HKEY_CLASSES_ROOT\DesktopBackground\Shell\V2ray\command] >>dkey.reg

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
set name=�л�v2ray��·

set path1=%cd%
cd ..
set path2=%cd%\�������.bat
set "path2=%path2:\=\\%"
cd %path1%

echo Windows Registry Editor Version 5.00 >>rkey.reg
echo [HKEY_CLASSES_ROOT\DesktopBackground\Shell\V2ray] >>rkey.reg
echo @="%name%" >>rkey.reg
echo [HKEY_CLASSES_ROOT\DesktopBackground\Shell\V2ray\command] >>rkey.reg
echo @="%path2%" >>rkey.reg

ping localhost -n 2 1>nul 2>nul
regedit /s rkey.reg
del /q rkey.reg

echo.
echo.
echo ��װ�ɹ���
ping localhost -n 2 1>nul 2>nul
goto begin
