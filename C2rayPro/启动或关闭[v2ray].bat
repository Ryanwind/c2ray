@echo Off

::��ȡ����ԱȨ��
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

::�����б�������������ɫ
title -- ������ر�[v2ray] --
MODE con: COLS=38 lines=5
color 0a



:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::��������ʱҪ���ص� �����ļ�·����֧�ֱ����ļ���Զ�����ӣ�
set config-path=-config=%cd%\config.json
::set config-path=-config=https://coding.net/u/Alvin9999/p/pac/git/raw/master/config.json

::�ں�·��������Ķ���
set exe-path=%cd%\app\v2ray-windows-64
::�������ƣ�����Ķ���
set exe-name=wv2ray.exe

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



::�������Ƿ�������
tasklist /fi "imagename eq %exe-name%" 2>nul | find /i "%exe-name%" 1>nul 2>nul && ( goto gooff ) || ( goto gostart )



::��������
:gostart
taskkill /im %exe-name% /f 1>nul 2>nul
del /a /f /s %exe-path%\run.vbs 1>nul 2>nul

echo DIM objShell > %exe-path%\run.vbs
echo set objShell = wscript.createObject("wscript.shell") >> %exe-path%\run.vbs
echo iReturn = objShell.Run("cmd.exe /C %exe-path%\%exe-name% %config-path%", 0, TRUE) >> %exe-path%\run.vbs

cd %exe-path%
start run.vbs

set result-a=�����ɹ�
set result-b=����ʧ��

call :gotest
echo.
echo.
echo. --- %exe-name% %exe-test% ---
echo.
ping localhost -n 3 1>nul 2>nul

del /a /f /s %exe-path%\run.vbs 1>nul 2>nul
exit



::�رս���
:gooff
taskkill /im %exe-name% /f 1>nul 2>nul

set result-a=�ر�ʧ��
set result-b=�رճɹ�

call :gotest
echo.
echo.
echo. --- %exe-name% %exe-test% ---
echo.
ping localhost -n 3 1>nul 2>nul
exit



::���ִ�н��
:gotest
ping localhost -n 2 1>nul 2>nul
tasklist /fi "imagename eq %exe-name%" 2>nul | find /i "%exe-name%" 1>nul 2>nul && ( set exe-test=������ %result-a% ) || ( set exe-test=δ���� %result-b% )
goto :eof


