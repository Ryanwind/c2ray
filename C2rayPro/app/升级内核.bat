@echo off

::��ȡ����ԱȨ��
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

::�����б�������������ɫ
title -- �ں����� --
color 0a



::��������������
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::�汾���Դ
set github-latest=https://api.github.com/repos/v2ray/v2ray-core/releases/latest

::wget·��
set wget-path=%cd%\update-tool

::������·��
set exe-path=%cd%\v2ray-windows-64

::����������
set exe-name=wv2ray.exe

::����/�������ƣ�ע���Сд��
set sc-name=V2Ray

::����������
set pg-name=v2ray-windows-64.zip

::������·��
set pg-path=https://github.com/v2ray/v2ray-core/releases/download

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



::�ر��������еĽ���
sc stop %sc-name% 1>nul 2>nul
taskkill /im %exe-name% /f 1>nul 2>nul

::��Զ�̻�ȡ���µİ汾��
cls
echo.
echo. ��ʾ���������̽����������ĵȴ��������� github �������⣬�����Ҫ10���ӣ�
echo.
echo. ����׼������...
echo.
del /s /Q "%cd%\%pg-name%" 1>nul 2>nul
del /s /Q "%cd%\latest" 1>nul 2>nul
echo. ���ڻ�ȡ���°汾�ţ������ĵȴ����糤ʱ�俨�ڽ������ɳ��Թر���������
echo.
echo. ���Դ��%github-latest%
echo.
%wget-path%\wget.exe --ca-certificate=%wget-path%\ca-bundle.crt -c %github-latest%

::��ȡ�汾��
for /f "delims=: tokens=2" %%i in ('find "tag_name" "%cd%\latest"')do set latestv=%%i
set latestv=%latestv:~2,-2%

::��ȡ�����Ѱ�װ�İ汾��
%exe-path%\%exe-name% -version >%exe-path%\version.txt 2>nul
for /f "delims=" %%r in ('find "%sc-name%" "%exe-path%\version.txt"')do set v2version=%%r
del /s /Q "%cd%\latest" 1>nul 2>nul

::������ʾ
cls
echo.
echo. �����ɡ�
echo.
echo. ���°汾��Ϊ��%sc-name% %latestv%
echo. �Ѱ�װ�汾Ϊ��%v2version%
echo.
echo. ����Դ��%pg-path%
echo.
echo. ���������ʼ����������ȡ����������ֱ�ӹرմ˴��ڡ�
pause 1>nul 2>nul

::��Զ���������µ��ں�
cls
echo.
echo. ��ʼ���� %pg-name% ���� %latestv% �棬�����ĵȴ���
echo.
%wget-path%\wget.exe --ca-certificate=%wget-path%\ca-bundle.crt -c %pg-path%/%latestv%/%pg-name%

::��ѹ�滻
cls
echo.
echo. ��������ɰ�...
echo.
rd /s /Q "%exe-path%" 1>nul 2>nul
echo. ��ʼ������
md "%exe-path%" 1>nul 2>nul
echo.
%wget-path%\7zip.exe x %cd%\%pg-name% -o%exe-path%
del /s /Q "%cd%\%pg-name%" 1>nul 2>nul

::�����������ں˰汾��
cls
echo.
echo. ������ɡ�
%exe-path%\%exe-name% -version >%exe-path%\version.txt 2>nul
for /f "delims=" %%n in ('find "%sc-name%" "%exe-path%\version.txt"')do set nv2version=%%n
echo.
echo. ������Ϊ���°档��ǰ %sc-name% �汾�ţ�%nv2version%
echo.
echo. �����������%sc-name%����������Ѱ�װ����������ֱ�ӹرմ˴���
pause 1>nul 2>nul

::��������
echo.
echo. �������� %sc-name% ����
sc start %sc-name% 1>nul 2>nul
echo.
ping localhost -n 4 1>nul 2>nul
tasklist /fi "imagename eq %exe-name%"
echo.
tasklist /fi "imagename eq %exe-name%" 2>nul | find /i "%exe-name%" 1>nul 2>nul && ( set on2off=%sc-name%������-�������ɹ��� ) || ( set on2off=%sc-name%δ����-������ʧ�ܡ������Ȱ�װ%sc-name%Ϊ�������������� )
echo.
echo. %on2off%��5����Զ��رմ˴���
ping localhost -n 9 1>nul 2>nul
exit
