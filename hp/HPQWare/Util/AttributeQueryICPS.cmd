@echo off

set CEPS_IsICPS=CEPS_UtilityFail

if exist "c:\system.sav\util\vars.ini" (
	for /f "tokens=1,2 usebackq delims='='" %%a in (c:\system.sav\util\vars.ini) do (
		If "%%a" == "ICPS" (
        	Set ICPS=%%b
    	)
	)
) else ECHO [%DATE%] [%TIME%] VARS.ini does not exists

IF /I "%ICPS%"=="1" ( Set "CEPS_IsICPS=1" ) else Set "CEPS_IsICPS=0"

ECHO [%DATE%] [%TIME%] Intel Connectivity Performance Suite: "%CEPS_IsICPS%"
