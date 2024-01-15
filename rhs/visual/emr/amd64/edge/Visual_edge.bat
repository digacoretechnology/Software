@echo off
cls
echo starting Visual...
@echo off

setlocal ENABLEEXTENSIONS
set KEY_NAME="HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2"
set VALUE_NAME=1201

FOR /F "usebackq skip=2 tokens=1-3" %%A IN (`REG QUERY %KEY_NAME% /v %VALUE_NAME% 2^>nul`) DO (
    set ValueName=%%A
    set ValueType=%%B
    set ValueValue=%%C
)
FOR /F "usebackq skip=4 tokens=1-3" %%A IN (`REG QUERY %KEY_NAME% /v %VALUE_NAME% 2^>nul`) DO (
    set ValueName=%%A
    set ValueType=%%B
    set ValueValue=%%C
)

if "%ValueValue%" == "0x0" goto startvisual
regedit /s C:\rhs\visual\emr\edgesecurity.reg




rem :checkietoedge

rem REG QUERY "HKCU\Software\Microsoft\Edge\IEToEdge" /v "RedirectionMode" | Find "0x0"
rem IF %ERRORLEVEL% == 0 goto startvisual


rem regedit /s C:\rhs\visual\emr\iesecurity.reg


:startvisual
"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" --new-window https://visualemr.rhsvisual2.com/rhsweb/login.asp?ws=%computername% 

