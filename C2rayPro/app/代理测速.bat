@echo off

::��ȡ����ԱȨ��
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

::�����б�������������ɫ
title -- ������ٽű� --
color 0a



::���ò����ļ�
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set test-file=http://cachefly.cachefly.net/100mb.test
set socks5-port=--socks5 127.0.0.1:1080

set test-web=https://www.google.com

set root-path=%cd%
set curl-path=%cd%\speed-test

set exe-name=wv2ray.exe

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



::�������Ƿ�������
tasklist /fi "imagename eq %exe-name%" 2>nul | find /i "%exe-name%" 1>nul 2>nul && ( goto gotest ) || ( goto goexit )



::��ʼ����
:gotest
cls
echo.
echo. ��⵽ %exe-name% �����У���ʼ���١�
cd %curl-path%
echo.
echo. �����ļ���%test-file%
echo. �ļ���С��100M  ����ʱ�䣺90��
echo.
echo. ���������ʼ���١�����ȡ�����٣���ֱ�ӹرմ˴��ڡ�
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
echo. ��ʼ���� HTTP��ʱ��TCP���֣���HTTPs��ʱ��TCP����+SSL���֣�
echo. ������վ��%test-web% ��ʱ��λ����
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
echo. ��������ɣ���������˳���
pause 1>nul 2>nul
exit



::δ��⵽����
:goexit
cls
echo.
echo. δ��⵽ %exe-name% ���̣��������ò����� %exe-name%��
echo.
echo. ��������ֹ����������˳���
pause 1>nul 2>nul
exit


