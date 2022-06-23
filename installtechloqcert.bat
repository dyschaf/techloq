@echo off
:: ### START UAC SCRIPT ###

if "%2"=="firstrun" exit
cmd /c "%0" null firstrun

if "%1"=="skipuac" goto skipuacstart

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (shift & goto gotPrivileges)

setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
ECHO UAC.ShellExecute "!batchPath!", "ELEV", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%temp%\OEgetPrivileges.vbs"
exit /B

:gotPrivileges

setlocal & pushd .

cd /d %~dp0
cmd /c "%0" skipuac firstrun
cd /d %~dp0

:skipuacstart

if "%2"=="firstrun" exit

powershell -c "Invoke-WebRequest -Uri 'https://cert.techloq.com/techloq-ca.cer' -OutFile '%USERPROFILE%\Downloads\techloq-ca.crt'
:restart
cls
echo Welcome to the Techloq Certificate Installer
echo Please type a number and press Enter
echo 1 - install Techloq certificate to pip or pypi
echo 2 - install Techloq certificate to npm
echo 3 - install Techloq certificate to git
echo 4 - install Techloq certificate to JavaScript
echo 5 - install Techloq certificate to PIO or python
echo 6 - install Techloq certificate to Android Studio
echo 7 - install Techloq certificate to Java
set /p cert=
if %cert% == 1 goto pip
if %cert% == 2 goto npm 
if %cert% == 3 goto git
if %cert% == 4 goto javascript​
if %cert% == 5 goto pio
if %cert% == 6 goto android
if %cert% == 7 goto java
if %cert% == 0 goto restart else %cert%
goto restart
:pip 
pip config set global.cert "%USERPROFILE%\Downloads\techloq-ca.crt"
pause
exit
:npm
npm config -g set cafile "%USERPROFILE%\Downloads\techloq-ca.crt"
pause
exit
:git
git config --global http.sslCAInfo "%USERPROFILE%\Downloads\techloq-ca.crt"
pause
exit
:javascript​
SetX NODE_EXTRA_CA_CERTS "%USERPROFILE%\Downloads\techloq-ca.crt" /m​
pause
exit
:pio
setx REQUESTS_CA_BUNDLE %USERPROFILE%\Downloads\techloq-ca.crt -m​
pause
exit
:android
"C:\Program Files\Android\Android Studio\jre\bin\keytool" -noprompt -trustcacerts -keystore "C:\Program Files\Android\Android Studio\jre\lib\security\cacerts" -importcert -alias nf -file "%USERPROFILE%\Downloads\techloq-ca.crt" -storepass changeit
pause
exit
:java
cd %JAVA_HOME%\bin
keytool -importcert -trustcacerts -alias netfree-ca -file "%USERPROFILE%\Downloads\techloq-ca.crt" -keystore "%JAVA_HOME%/jre/lib/security/cacerts" -storepass changeit -noprompt
pause
exit
