@echo off
setlocal

rem Copyright (c) 1999, 2010 Tanuki Software, Ltd.
rem http://www.tanukisoftware.com
rem All rights reserved.
rem
rem This software is the proprietary information of Tanuki Software.
rem You shall use it only in accordance with the terms of the
rem license agreement you entered into with Tanuki Software.
rem http://wrapper.tanukisoftware.org/doc/english/licenseOverview.html
rem
rem Java Service Wrapper command based script.

rem -----------------------------------------------------------------------------
rem These settings can be modified to fit the needs of your application
rem Optimized for use with version 3.4.1-st of the Wrapper.

rem The base name for the Wrapper binary.
set _WRAPPER_BASE=wrapper

rem The name and location of the Wrapper configuration file.
rem  (Do not remove quotes.)
set _WRAPPER_CONF="../conf/wrapper.conf"

rem Do not modify anything beyond this point
rem -----------------------------------------------------------------------------

if "%OS%"=="Windows_NT" goto nt
echo This script only works with NT-based versions of Windows.
goto :eof

:nt
rem Find the application home.
rem %~dp0 is location of current script under NT
set _REALPATH=%~dp0

rem
rem Decide on the specific Wrapper binary to use (See delta-pack)
rem
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" goto amd64
if "%PROCESSOR_ARCHITECTURE%"=="IA64" goto ia64
set _WRAPPER_L_EXE=%_REALPATH%%_WRAPPER_BASE%-windows-x86-32.exe
goto search
:amd64
set _WRAPPER_L_EXE=%_REALPATH%%_WRAPPER_BASE%-windows-x86-64.exe
goto search
:ia64
set _WRAPPER_L_EXE=%_REALPATH%%_WRAPPER_BASE%-windows-ia-64.exe
goto search
:search
set _WRAPPER_EXE=%_WRAPPER_L_EXE%
if exist "%_WRAPPER_EXE%" goto validate
set _WRAPPER_EXE=%_REALPATH%%_WRAPPER_BASE%.exe
if exist "%_WRAPPER_EXE%" goto validate
echo Unable to locate a Wrapper executable using any of the following names:
echo %_WRAPPER_L_EXE%
echo %_WRAPPER_EXE%
pause
goto :eof

:validate
rem
rem Find the requested command.
rem
for /F %%v in ('echo %1^|findstr "^console$ ^start$ ^pause$ ^resume$ ^stop$ ^restart$ ^install$ ^update$ ^remove$"') do call :exec set COMMAND=%%v

if "%COMMAND%" == "" (
    echo Usage: %0 { console : start : pause : resume : stop : restart : install : update : remove } [command]
    pause
    goto :eof
) else (
    shift
)

rem
rem Run the application.
rem At runtime, the current directory will be that of wrapper.exe
rem
call :%COMMAND%
if errorlevel 1 goto callerror
goto :eof

:callerror
echo An error occurred in the process.
pause
goto :eof

:console
"%_WRAPPER_EXE%" -c %_WRAPPER_CONF% wrapper.app.parameter.1=%2
goto :eof

:start
"%_WRAPPER_EXE%" -t %_WRAPPER_CONF% wrapper.app.parameter.1=%2
goto :eof

:pause
"%_WRAPPER_EXE%" -a %_WRAPPER_CONF% wrapper.app.parameter.1=%2
goto :eof

:resume
"%_WRAPPER_EXE%" -e %_WRAPPER_CONF% wrapper.app.parameter.1=%2
goto :eof

:stop
"%_WRAPPER_EXE%" -p %_WRAPPER_CONF% wrapper.app.parameter.1=%2
goto :eof

:install
"%_WRAPPER_EXE%" -i %_WRAPPER_CONF% wrapper.app.parameter.1=%2
goto :eof

:update
"%_WRAPPER_EXE%" -u %_WRAPPER_CONF% wrapper.app.parameter.1=%2
goto :eof

:remove
"%_WRAPPER_EXE%" -r %_WRAPPER_CONF% wrapper.app.parameter.1=%2
goto :eof

:restart
call :stop
call :start
goto :eof

:exec
%*
goto :eof
