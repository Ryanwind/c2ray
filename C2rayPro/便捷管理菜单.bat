@echo off

::��ȡ����ԱȨ��
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

::�����б�������������ɫ
title -- ��ݹ���˵� --
MODE con: COLS=53 lines=21
color 0a



::�ڴ˴����ö���·�����ļ���·��
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::��Ŀ¼Ĭ����·
set config-file=%cd%\config.json

::���ö�����·
set config-root=app\config-files
set config-path=%cd%\%config-root%

set config-file-01=config-01.json
set config-file-02=config-02.json

set config-url-01=config-url-01.txt
set config-url-02=config-url-02.txt

set cmd-name=v2ray.exe
set exe-name=wv2ray.exe
set exe-path=%cd%\app\v2ray-windows-64

::����/�������ƣ�ע���Сд��
set sc-name=V2Ray
set nssm-name=%cd%\app\wv2ray-service.exe

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



::��ȡԶ��url�ڵ������ļ�
for /f "delims=" %%i in ('find "http" "%config-path%\%config-url-01%"')do set config-url-a=%%i
for /f "delims=" %%v in ('find "http" "%config-path%\%config-url-02%"')do set config-url-b=%%v

::����ں��ļ��Ƿ����
if exist "%exe-path%\%exe-name%" ( goto begin ) else ( goto fail )

::���˵�
:begin
tasklist /fi "imagename eq %exe-name%" 2>nul | find /i "%exe-name%" 1>nul 2>nul && ( set on2off=%sc-name%������ ) || ( set on2off=%sc-name%δ���� )
cls
MODE con: COLS=53 lines=21
echo.
%exe-path%\%exe-name% -version >%exe-path%\version.txt 2>nul
for /f "delims=" %%r in ('find "%sc-name%" "%exe-path%\version.txt"')do set v2version=%%r 1>nul 2>nul

echo.            ===== ��ݹ���˵� =====
echo.
echo.              ��ǰ״̬::%on2off%
echo.         ===== socks5 �����˿� 1080 =====
echo.
echo.   --[1]--����/�л�%sc-name%��·�����ش���(%exe-name%)
echo.   --[2]--��ʱ��������ʾ���̴���(%cmd-name%)
echo.
echo.   --[3]--��װ�������������񣨹���ԱȨ�ޣ�
echo.   --[4]--ж�ؿ������������񣨹���ԱȨ�ޣ�
echo.
echo.   --[5]--�ر�%sc-name%��̨����
echo.   --[6]--����%sc-name%�����ں�
echo.
echo.   --ע��--��ʱ�����в����������ٰ�װΪ����������
echo.   --��ǰ�汾��%v2version%
echo.
choice /c 123456 /n /m "��ѡ��1-6����"

echo %errorlevel%
if %errorlevel% == 1 goto set_1
if %errorlevel% == 2 goto set_2
if %errorlevel% == 3 goto set_3
if %errorlevel% == 4 goto set_4
if %errorlevel% == 5 goto set_5
if %errorlevel% == 6 goto set_6

::�������̲���������
:set_1
cls
call :setconfig
MODE con: COLS=80 lines=16
sc stop %sc-name% 1>nul 2>nul
taskkill /im %exe-name% /f 1>nul 2>nul
cls
echo.
echo.
echo ��������������....
echo.
echo --[����������̨����]--
echo.
start "" /d "%exe-path%\" "%exe-name%" -config=%jsonurl%
ping localhost -n 2 1>nul 2>nul
tasklist /fi "imagename eq %exe-name%"
echo.
tasklist /fi "imagename eq %exe-name%" 2>nul | find /i "%exe-name%" 1>nul 2>nul && ( set on2off=%sc-name%������-�������ɹ�������������رմ��� ) || ( set on2off=%sc-name%δ����-������ʧ�ܡ������������ļ��Ƿ���ȷ����������رմ��� )
echo.
echo %on2off%
pause 1>nul 2>nul
exit

::�������̲���������
:set_2
cls
call :setconfig
MODE con: COLS=80 lines=12
sc stop %sc-name% 1>nul 2>nul
taskkill /im %exe-name% /f 1>nul 2>nul
cls
echo.
echo --[��������ǰ̨����]--
echo.
start "" /d "%exe-path%\" "%cmd-name%" -config=%jsonurl%
ping localhost -n 2 1>nul 2>nul
tasklist /fi "imagename eq %cmd-name%"
echo.
tasklist /fi "imagename eq %cmd-name%" 2>nul | find /i "%cmd-name%" 1>nul 2>nul && ( set on2off=%sc-name%������-�������ɹ���������������ؿ�ʼ�˵� ) || ( set on2off=%sc-name%δ����-������ʧ�ܡ������������ļ��Ƿ���ȷ������������ؿ�ʼ�˵� )
echo.
echo %on2off%
pause 1>nul 2>nul
goto begin

::��װ������Ϊ����������ϵͳ����
:set_3
cls
call :setconfig
MODE con: COLS=60 lines=18
sc stop %sc-name% 1>nul 2>nul
taskkill /im %exe-name% /f 1>nul 2>nul
cls
echo.
echo.
echo.
echo ���ڻ�ȡ������ԱȨ�ޡ������ڵ����˵��е㡾�ǡ�
echo.
echo.
echo --[���ڰ�װ����]--
echo.
%nssm-name% install %sc-name% "%exe-path%\%exe-name%" 1>nul 2>nul
%nssm-name% set %sc-name% Start SERVICE_AUTO_START
%nssm-name% set %sc-name% DisplayName "%sc-name% Auto Start"
%nssm-name% set %sc-name% Description "%sc-name% ���������������ػ����̣�"
%nssm-name% set %sc-name% AppParameters "-config=%jsonurl%"
echo.
echo.
echo ����װ�ɹ�������������������������ڵ����˵��е㡾�ǡ�
pause>nul
MODE con: COLS=80 lines=16
echo.
echo.
echo %sc-name%��������������....
echo.
echo.
echo --[������������]--
sc start %sc-name% 1>nul 2>nul
echo.
ping localhost -n 2 1>nul 2>nul
tasklist /fi "imagename eq %exe-name%"
echo.
tasklist /fi "imagename eq %exe-name%" 2>nul | find /i "%exe-name%" 1>nul 2>nul && ( set on2off=%sc-name%������-�������ɹ���������������ؿ�ʼ�˵� ) || ( set on2off=%sc-name%δ����-������ʧ�ܡ������������ļ��Ƿ���ȷ������������ؿ�ʼ�˵� )
echo.
echo %on2off%
pause 1>nul 2>nul
goto begin

::ж������������������
:set_4
MODE con: COLS=70 lines=15
sc stop %sc-name% 1>nul 2>nul
taskkill /im %exe-name% /f 1>nul 2>nul
cls
echo.
echo.
echo.
echo ���ڻ�ȡ������ԱȨ�ޡ������ڵ����˵��е㡾�ǡ�
echo.
echo --[����ж������������]--
%nssm-name% remove %sc-name% confirm
echo.
echo ���ֶ�ɾ����װĿ¼��%cd%
echo.
echo ж�ؿ�������������ɹ�����������رմ���
pause 1>nul 2>nul
exit

::�رպ�̨���̺ͷ���
:set_5
MODE con: COLS=60 lines=13
cls
echo.
echo.
echo.
echo �ر�%sc-name%��̨�����񣩽���....
echo.
echo --[���ڹر�%sc-name%����]--
sc stop %sc-name% 1>nul 2>nul
taskkill /im %exe-name% /f 1>nul 2>nul
ping localhost -n 2 1>nul 2>nul
tasklist /fi "imagename eq %exe-name%" 2>nul | find /i "%exe-name%" 1>nul 2>nul && ( set on2off=%sc-name%������-���ر�ʧ�ܡ����볢������ִ�йر����� ) || ( set on2off=%sc-name%δ����-���رճɹ��� )
echo.
echo %on2off%
echo.
echo 5��󷵻ؿ�ʼ�˵�
ping localhost -n 5 1>nul 2>nul
goto begin

::���������ں�
:set_6
%cd%\app\�����ں�.bat
exit

::δ��⵽�ں���ʾ
:fail
cls
MODE con: COLS=53 lines=12
echo.
echo.
echo.         ===============================
echo.
echo.           ����δ��⵽ %sc-name% �ں�
echo.
echo.         ===============================
echo.
echo. ���������ʼ��װ %sc-name% �ںˡ�������ֱ�ӹرմ���
pause 1>nul 2>nul
%cd%\app\�����ں�.bat
exit

::������·ѡ��˵�
:setconfig
cls
MODE con: COLS=53 lines=21
echo.
echo.
echo.             ===== ��ݹ���˵� =====
echo.
echo.         ===== ��ѡ����Ҫʹ�õ���· =====
echo.
echo.   --[1]--Ĭ����·����Ŀ¼�� config.json��
echo.
echo.   --[2]--������·һ��%config-file-01%��
echo.   --[3]--������·����%config-file-02%��
echo.
echo.   --[4]--Զ����·һ��%config-url-01%��
echo.   --[5]--Զ����·����%config-url-02%��
echo.
echo.   --ע��--����Ҫ�������ö�Ӧ��·�ļ�
echo.   --�����ļ�·�� --\%config-root%\
echo.
choice /c 12345 /n /m "��ѡ��1-5����"

echo %errorlevel%

if %errorlevel% == 1 set jsonurl=%config-file%

if %errorlevel% == 2 set jsonurl=%config-path%\%config-file-01%
if %errorlevel% == 3 set jsonurl=%config-path%\%config-file-02%

if %errorlevel% == 4 set jsonurl=%config-url-a%
if %errorlevel% == 5 set jsonurl=%config-url-b%

cls
MODE con: COLS=90 lines=10
echo.
echo.
echo.  ===============================
echo.
echo.  ��ѡ��·Ϊ:%jsonurl%
echo.  ��ȷ���������ļ����ڲ����á�
echo.
echo.  ===============================
echo.
ping localhost -n 5 1>nul 2>nul
goto :eof


