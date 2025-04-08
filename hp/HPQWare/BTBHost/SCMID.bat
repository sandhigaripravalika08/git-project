pushd %~dp0
set logs=c:\system.sav\logs\CEPS\BTBHost
if not exist %logs% md %logs%
if exist C:\system.sav\util\SetVariables.cmd (Call c:\system.sav\util\SetVariables.cmd) else (echo [%date% %time%] SetVariables.cmd Not Found>>%logs%\%~nx0.log)
if exist C:\system.sav\util\TDCSetVariables.cmd (Call c:\system.sav\util\TDCSetVariables.cmd) else (echo [%date% %time%] TDCSetVariables.cmd Not Found>>%logs%\%~nx0.log)

@echo %date% %time% BTB SCMID Start Running >>%logs%\%~nx0.log

@echo Segment = %Segment% >>%logs%\%~nx0.log
@echo C_MER = %C_MER% >>%logs%\%~nx0.log
@echo OSHAL = %OSHAL% >>%logs%\%~nx0.log
IF exist c:\hp\bin\Rstone.ini echo c:\hp\bin\Rstone.ini found >>%logs%\%~nx0.log

::Default to Volume
Set SCMId=HP2_Volume
for /f "tokens=1,2 delims==" %%a in ( c:\hp\bin\Rstone.ini ) do if /i "%%a"=="BrandName" if /i "%%b"=="Premium" set SCMID=HP3_Premium
IF /I "%Segment%"=="Premium" Set SCMId=HP3_Premium

::For BNB, SCMId should be always HP4_Commercial
IF /I "%Segment%"=="Enterprise" Set SCMId=HP4_Commercial
IF /I "%Segment%"=="Workstation" Set SCMId=HP4_Commercial
IF /I "%Segment%"=="SBSO" IF not exist c:\hp\bin\Rstone.ini Set SCMId=HP4_Commercial

:: Set SCMId as HP9_Immersive for Merlin projects
if "%C_MER%"=="1" set SCMId=HP9_Immersive

Set SetAclExe=SetACL64.exe
IF "%OSHAL%"=="32" Set SetAclExe=SetACL32.exe
if exist c:\system.sav\flags\W10ARM64.FLG Set SetAclExe=SetACL32.exe

%SetAclExe% -on HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Store -ot reg -actn list -lst "f:sddl;w:d,s,o,g" -bckp perm.txt
%SetAclExe% -on HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Store -ot reg -actn setowner -ownr "n:S-1-5-32-544;s:y"
%SetAclExe% -on HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Store -ot reg -actn ace -ace "n:S-1-5-32-544;s:y;p:full;m:set;w:dacl"
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Store /v StoreContentModifier /t REG_SZ /d %SCMId% /f
%SetAclExe% -on HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Store -ot reg -actn restore -bckp perm.txt

del perm.txt
del SetAcl64.exe
del SetAcl32.exe

@echo SCMId = %SCMId% >>%logs%\%~nx0.log
@echo %date% %time% BTB SCMID Finish Running >>%logs%\%~nx0.log

popd
