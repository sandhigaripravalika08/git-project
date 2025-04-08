set logs=c:\system.sav\logs\CEPS\BTBHost
set logsCMIT=c:\programdata\hp\logs\BTBHost
set logSpec=%logs%\PostWizInstaller.log
pushd %~dp0 

set cNB=0
if exist c:\hp\bin\Rstone.ini set cNB=1
:: Consumer leverage commercial projects like Hugo still have RStone.ini but it apply commercial PIN process
if /I "%SEG.CON%"=="1" if /I "%SL.BUD%"=="1" if /I "%PCBR.HP%"=="1" set cNB=0
:: Merlin project should apply commercial PIN process for fixing SIO1651958
if /I "%C_MER%"=="1" set cNB=0
if %cNB% == 0 (
	md %logsCMIT%
	set logSpec=%logsCMIT%\PostWizInstaller.log 
)

set IsWin11=0
if exist c:\system.sav\flags\WOct21.flg set IsWin11=1
if exist c:\system.sav\flags\W11.flg set IsWin11=1
if "%ATF_OS.Z%" == "1" set IsWin11=1
echo IsWin11=%IsWin11% >>%logSpec%

echo ==================== %date% %time% PostWizInstaller begin =================>>%logSpec%
Getlocale.exe
call C:\HP\HPQware\setlocale.bat

echo ==================== %date% %time% PostWizInstaller Box =================>>%logSpec%
:: Box would drop desktop icon under c:\hp\hpqware\DTShortcuts\ in postuser.bat
:: So, we need do it here before "PostWizInstaller 03 DT Icon"
if exist "c:\hp\hpqware\ABox\postuser.bat" (
	echo %date%%time% run Box >>%logSpec%	
	call c:\hp\hpqware\ABox\postuser.bat
)

echo ==================== %date% %time%  PostWizInstaller IE Favorite Bar =================>>%logSpec%
if exist c:\system.sav\flags\BtBR_MIC.flg goto NOIEFAV
if exist c:\system.sav\logs\DisableIEFav.flg goto NOIEFAV
If exist c:\system.sav\flags\mssign.flg goto NOIEFAV

reg add "HKCU\SOFTWARE\Microsoft\Internet Explorer\MINIE" /v LinksBandEnabled /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Feeds" /v SyncStatus /t REG_DWORD /d 1 /f
reg load HKLM\DefaultUser c:\users\default\ntuser.dat
reg add "HKLM\DefaultUser\SOFTWARE\Microsoft\Internet Explorer\MINIE" /v LinksBandEnabled /t REG_DWORD /d 1 /f
reg add "HKLM\DefaultUser\SOFTWARE\Microsoft\Feeds" /v SyncStatus /t REG_DWORD /d 1 /f

echo ==================== %date% %time% PostWizInstaller MSSIGN =================>>%logSpec%

:NOIEFAV
if exist c:\system.sav\flags\BtBR_MIC.flg (
	echo "Disable IE Bar" >>%logSpec%
	reg load HKU\DEFAULTTEMP c:\users\default\ntuser.dat
	reg unload HKU\DEFAULTTEMP
)

If exist "c:\system.sav\flags\mssign.flg" (
	echo "Disable IE Bar" >>%logSpec%
	reg load HKU\DEFAULTTEMP c:\users\default\ntuser.dat
	regedit /s "c:\hp\hpqware\btbhost\Signature\IE_Settings.reg"
	reg unload HKU\DEFAULTTEMP
)

echo ==================== %date% %time% PostWizInstaller Workarounds =================>>%logSpec%
if /i "%ISO_UILGCTRY%"=="EN-GB" SET ISO_UILGCTRY=en-US

set iso >>%logSpec% 2>&1

::These path's don't appear to be localized in Win 8.
set Common Desktop=C:\Users\Public\Desktop
set Common Programs=C:\ProgramData\Microsoft\Windows\Start Menu\Programs
set Default Favorites=C:\Users\Default\Favorites

echo ==================== %date% %time% PostWizInstaller 01 IE Favorites Copy =================>>%logSpec%
if "%IsWin11%" == "1" goto SKIP_IEFAV
setlocal enabledelayedexpansion
set FAVORITES=C:\Users\!USERNAME!\Favorites
if exist "c:\hp\hpqware\Favs\All\All" (
   xcopy /e/i/y "c:\hp\hpqware\Favs\All\All" "!Favorites!\" >>%logSpec% 2>&1
   xcopy /e/i/y "c:\hp\hpqware\Favs\All\All" "%Default Favorites%\" >>%logSpec% 2>&1
)

if exist "c:\hp\hpqware\Favs\%ISO_UILGCTRY%\All" (
   xcopy /e/i/y "c:\hp\hpqware\Favs\%ISO_UILGCTRY%\All" "!Favorites!\" >>%logSpec% 2>&1
   xcopy /e/i/y "c:\hp\hpqware\Favs\%ISO_UILGCTRY%\All" "%DEFAULT FAVORITES%\" >>%logSpec% 2>&1
)

if exist "c:\hp\hpqware\Favs\All\%ISO_COUNTRY3%" (
   xcopy /e/i/y "c:\hp\hpqware\Favs\All\%ISO_COUNTRY3%" "!Favorites!\" >>%logSpec% 2>&1
   xcopy /e/i/y "c:\hp\hpqware\Favs\All\%ISO_COUNTRY3%" "%DEFAULT FAVORITES%\" >>%logSpec% 2>&1
)

if exist c:\hp\hpqware\Favs\%ISO_UILGCTRY%\%ISO_COUNTRY3% (
   xcopy /e/i/y c:\hp\hpqware\Favs\%ISO_UILGCTRY%\%ISO_COUNTRY3% "!Favorites!\" >>%logSpec% 2>&1
   xcopy /e/i/y c:\hp\hpqware\Favs\%ISO_UILGCTRY%\%ISO_COUNTRY3% "%DEFAULT FAVORITES%\" >>%logSpec% 2>&1
)

if exist c:\hp\hpqware\Favs\%ISO_UILG% (
   xcopy /e/i/y c:\hp\hpqware\Favs\%ISO_UILG% "!Favorites!\" >>%logSpec% 2>&1
   xcopy /e/i/y c:\hp\hpqware\Favs\%ISO_UILG% "%DEFAULT FAVORITES%\" >>%logSpec% 2>&1
)
endlocal
:SKIP_IEFAV
echo ==================== %date% %time% PostWizInstaller 02 IE Search =================>>%logSpec%
if exist C:\hp\HPQware\browser\All\All\IESearch.reg (
	echo %date% %time% .\browser\All\All\IESearch.reg >>%logSpec%
	regedit -s C:\hp\HPQware\browser\All\All\IESearch.reg >>%logSpec%
	if exist c:\system.sav\flags\BtBOSWin10.flg if NOT exist \system.sav\flags\BtBPinTileByReg.flg (
		if not exist %~dp0\PBR\PostUser md %~dp0\PBR\PostUser
		copy /y C:\hp\HPQware\browser\All\All\IESearch.reg %~dp0\PBR\PostUser\IESearch_All-All.reg >>%logSpec% 2>&1
	)
)
if exist C:\hp\HPQware\browser\%ISO_UILGCTRY%\All\IESearch.reg (
	echo %date% %time% .\browser\%ISO_UILGCTRY%\All\IESearch.reg >>%logSpec%
	regedit -s C:\hp\HPQware\browser\%ISO_UILGCTRY%\All\IESearch.reg >>%logSpec%
	if exist c:\system.sav\flags\BtBOSWin10.flg if NOT exist \system.sav\flags\BtBPinTileByReg.flg (
		if not exist %~dp0\PBR\PostUser md %~dp0\PBR\PostUser
		copy /y C:\hp\HPQware\browser\%ISO_UILGCTRY%\All\IESearch.reg %~dp0\PBR\PostUser\IESearch_%ISO_UILGCTRY%-All.reg >>%logSpec% 2>&1
	)
)
if exist C:\hp\HPQware\browser\%ISO_UILGCTRY%\%ISO_COUNTRY3%\IESearch.reg (
	echo %date% %time% .\browser\%ISO_UILGCTRY%\%ISO_COUNTRY3%\IESearch.reg >>%logSpec%
	regedit -s C:\hp\HPQware\browser\%ISO_UILGCTRY%\%ISO_COUNTRY3%\IESearch.reg >>%logSpec%
	if exist c:\system.sav\flags\BtBOSWin10.flg if NOT exist \system.sav\flags\BtBPinTileByReg.flg (
		if not exist %~dp0\PBR\PostUser md %~dp0\PBR\PostUser
		copy /y C:\hp\HPQware\browser\%ISO_UILGCTRY%\%ISO_COUNTRY3%\IESearch.reg %~dp0\PBR\PostUser\IESearch_%ISO_UILGCTRY%-%ISO_COUNTRY3%.reg >>%logSpec% 2>&1
	)
)
if exist C:\hp\HPQware\browser\All\All\IESearch_Amazon.reg (
	echo %date% %time% .\browser\All\All\IESearch_Amazon.reg >>%logSpec%
	regedit -s C:\hp\HPQware\browser\All\All\IESearch_Amazon.reg >>%logSpec%
	if exist c:\system.sav\flags\BtBOSWin10.flg if NOT exist \system.sav\flags\BtBPinTileByReg.flg (
		if not exist %~dp0\PBR\PostUser md %~dp0\PBR\PostUser
		copy /y C:\hp\HPQware\browser\All\All\IESearch_Amazon.reg %~dp0\PBR\PostUser\IESearch_Amazon.reg >>%logSpec% 2>&1
	)
)

echo ==================== %date% %time% PostWizInstaller 03 DT Icon =================>>%logSpec%
if not exist c:\hp\hpqware\DTShortcuts goto :EndCopyDTIcon
if exist c:\hp\hpqware\DTShortcuts\All\All\ xcopy /e/i/y "c:\hp\hpqware\DTShortcuts\All\All" "%COMMON DESKTOP%\" >>%logSpec% 2>&1
if exist c:\hp\hpqware\DTShortcuts\All\%ISO_COUNTRY3% xcopy /e/i/y "c:\hp\hpqware\DTShortcuts\All\%ISO_COUNTRY3%" "%COMMON DESKTOP%\" >>%logSpec% 2>&1
if exist c:\hp\hpqware\DTShortcuts\%ISO_UILGCTRY%\All\ xcopy /e/i/y "c:\hp\hpqware\DTShortcuts\%ISO_UILGCTRY%\All" "%COMMON DESKTOP%\" >>%logSpec% 2>&1
if exist c:\hp\hpqware\DTShortcuts\%ISO_UILGCTRY%\%ISO_COUNTRY3% xcopy /e/i/y c:\hp\hpqware\DTShortcuts\%ISO_UILGCTRY%\%ISO_COUNTRY3% "%COMMON DESKTOP%\" >>%logSpec% 2>&1
:EndCopyDTIcon
echo ==================== %date% %time% PostWizInstaller 04 StartMenu =================>>%logSpec%
if not exist c:\hp\hpqware\startmenulink goto :EndCopyStartMenu
if exist c:\hp\hpqware\startmenulink\All\All xcopy /e/i/y "c:\hp\hpqware\startmenulink\All\All" "%COMMON PROGRAMS%\" >>%logSpec% 2>&1
if exist c:\hp\hpqware\startmenulink\All\%ISO_COUNTRY3% xcopy /e/i/y "c:\hp\hpqware\startmenulink\All\%ISO_COUNTRY3%" "%COMMON PROGRAMS%\" >>%logSpec% 2>&1
if exist c:\hp\hpqware\startmenulink\%ISO_UILGCTRY%\All xcopy /e/i/y "c:\hp\hpqware\startmenulink\%ISO_UILGCTRY%\All" "%COMMON PROGRAMS%\" >>%logSpec% 2>&1
if exist c:\hp\hpqware\startmenulink\%ISO_UILGCTRY%\%ISO_COUNTRY3% xcopy /e/i/y c:\hp\hpqware\startmenulink\%ISO_UILGCTRY%\%ISO_COUNTRY3% "%COMMON PROGRAMS%\" >>%logSpec% 2>&1
:EndCopyStartMenu
echo ==================== %date% %time% PostWizInstaller 05 IE Webslices =================>>%logSpec%
set insFileSpec="c:\program files (x86)\Internet Explorer\signup\install.ins"
if not exist "c:\program files (x86)" set insFileSpec="c:\program files\Internet Explorer\signup\install.ins"
if exist c:\hp\HPQWare\Browser\All\All\IEWebslices.ins (
	echo %date% %time% .\Browser\All\All\IEWebslices.ins >>%logSpec%
	set inFile=c:\hp\HPQWare\Browser\All\All\IEWebslices.ins && call :MergeSlices
)
if exist c:\hp\HPQWare\Browser\%ISO_UILGCTRY%\All\IEWebslices.ins (
	echo %date% %time% .\Browser\%ISO_UILGCTRY%\All\IEWebslices.ins >>%logSpec%
	set inFile=c:\hp\HPQWare\Browser\%ISO_UILGCTRY%\All\IEWebslices.ins && call :MergeSlices
)
if exist c:\hp\HPQWare\Browser\All\%ISO_COUNTRY3%\IEWebslices.ins (
	echo %date% %time% .\Browser\All\%ISO_COUNTRY3%\IEWebslices.ins >>%logSpec%
	set inFile=c:\hp\HPQWare\Browser\All\%ISO_COUNTRY3%\IEWebslices.ins && call :MergeSlices
)
if exist c:\hp\HPQWare\Browser\%ISO_UILGCTRY%\%ISO_COUNTRY3%\IEWebslices.ins (
	echo %date% %time% .\Browser\%ISO_UILGCTRY%\%ISO_COUNTRY3%\IEWebslices.ins >>%logSpec%
	set inFile=c:\hp\HPQWare\Browser\%ISO_UILGCTRY%\%ISO_COUNTRY3%\IEWebslices.ins && call :MergeSlices
)

goto Accelerators

:MergeSlices
for /f "skip=1 tokens=1,* delims==" %%a in ( %inFile% ) do (
   %hpuini% "insFileSpec"  "FavoritesBar" "%%a" "%%b"
)
goto :EOF

echo ==================== %date% %time% PostWizInstaller 06 IE Accelerators =================>>%logSpec%
:Accelerators
if exist c:\hp\HPQWare\Browser\All\All\IEAccelerators.ins (
	echo %date% %time% .\Browser\All\All\IEAccelerators.ins >>%logSpec%
	set inFile=c:\hp\HPQWare\Browser\All\All\IEAccelerators.ins && call :MergeAccelerators
)
if exist c:\hp\HPQWare\Browser\%ISO_UILGCTRY%\All\IEAccelerators.ins (
	echo %date% %time% .\Browser\%ISO_UILGCTRY%\All\IEAccelerators.ins >>%logSpec%
	set inFile=c:\hp\HPQWare\Browser\%ISO_UILGCTRY%\All\IEAccelerators.ins && call :MergeAccelerators
)
if exist c:\hp\HPQWare\Browser\%ISO_UILGCTRY%\%ISO_COUNTRY3%\IEAccelerators.ins (
	echo %date% %time% .\Browser\%ISO_UILGCTRY%\%ISO_COUNTRY3%\IEAccelerators.ins >>%logSpec%
	set inFile=c:\hp\HPQWare\Browser\%ISO_UILGCTRY%\%ISO_COUNTRY3%\IEAccelerators.ins && call :MergeAccelerators
)
xcopy  /e/i/y %insFileSpec% %logs% >>%logSpec%

goto DoneMerging

:MergeAccelerators
for /f "skip=1 tokens=1,* delims==" %%a in ( %inFile% ) do (
   %hpuini% "insFileSpec"  "Accelerators" "%%a" "%%b"
)
goto :EOF

:DoneMerging

echo ==================== %date% %time% PostWizInstaller 07 IE Home =================>>%logSpec%
if exist C:\hp\HPQware\browser\%ISO_UILG%\IE.reg (
	echo %date%%time% %ISO_UILG%\IE.reg >>%logSpec%
	regedit -s C:\hp\HPQware\browser\%ISO_UILG%\IE.reg >>%logSpec%
	if exist c:\system.sav\flags\BtBOSWin10.flg if NOT exist \system.sav\flags\BtBPinTileByReg.flg (
		copy /y C:\hp\HPQware\browser\%ISO_UILG%\IE.reg %~dp0\PBR\PostUser\IEHome_%ISO_UILG%.reg >>%logSpec% 2>&1
	)
) else (
	echo C:\hp\HPQware\browser\%ISO_UILG%\IE.reg not exist >>%logSpec%
	if exist C:\hp\HPQware\browser\Default\IE.reg regedit -s C:\hp\HPQware\browser\Default\IE.reg >>%logSpec%
	if exist C:\hp\HPQware\browser\Default\IE.reg if exist c:\system.sav\flags\BtBOSWin10.flg if NOT exist \system.sav\flags\BtBPinTileByReg.flg (
		copy /y C:\hp\HPQware\browser\Default\IE.reg %~dp0\PBR\PostUser\IEHome_Default.reg >>%logSpec% 2>&1
	)
)
if exist C:\hp\HPQware\browser\%ISO_UILG%\IE.bat (
	echo %date%%time% %ISO_UILG%\IE.bat >>%logSpec%
	call C:\hp\HPQware\browser\%ISO_UILG%\IE.bat
) else (
	echo C:\hp\HPQware\browser\%ISO_UILG%\IE.bat not exist >>%logSpec%
	if exist C:\hp\HPQware\browser\Default\IE.bat call C:\hp\HPQware\browser\Default\IE.bat
)

echo ==================== %date% %time% PostWizInstaller 08 HPCD Task Bar =================>>%logSpec%
if exist C:\hp\HPQware\TaskBar\%ISO_UILGCTRY%\%ISO_COUNTRY3%\HPCD.reg (
	echo %date%%time% TaskBar\%ISO_UILGCTRY%\%ISO_COUNTRY3%\HPCD.reg >>%logSpec%
	regedit -s C:\hp\HPQware\TaskBar\%ISO_UILGCTRY%\%ISO_COUNTRY3%\HPCD.reg >>%logSpec%
)

echo ==================== %date% %time% PostWizInstaller 09 HPCD PostUser =================>>%logSpec%
if exist "c:\hp\hpqware\HPCDPostUser\postuser.bat" (
	echo %date%%time% run HPCD Postuser >>%logSpec%
	call c:\hp\hpqware\HPCDPostUser\postuser.bat
)

set cNB=0
if exist c:\hp\bin\Rstone.ini set cNB=1
if %cNB% == 0 goto HPUC_SKIPPED
echo ==================== %date% %time% PostWizInstaller 10 HPUC [CNB Only] =================>>%logSpec%
if exist "C:\HP\HPQware\HPUC\%ISO_UILGCTRY%\%ISO_COUNTRY3%\" (
	echo %date%%time% found C:\HP\HPQware\HPUC\%ISO_UILGCTRY%\%ISO_COUNTRY3%\ >>%logSpec%
	If NOT "%programfiles(x86)%" =="" (
		echo %date%%time% copy file to 64 bits OS folder >>%logSpec%		
		xcopy /e/i/y "C:\HP\HPQware\HPUC\%ISO_UILGCTRY%\%ISO_COUNTRY3%" "%ProgramFiles(x86)%\%OnlineServices%\HPSmartFriendIcon\" >>%logSpec% 2>&1
	) else (	
		echo %date%%time% copy file to 32 bits OS folder >>%logSpec%
		xcopy /e/i/y "C:\HP\HPQware\HPUC\%ISO_UILGCTRY%\%ISO_COUNTRY3%" "%ProgramFiles%\%OnlineServices%\HPSmartFriendIcon\" >>%logSpec% 2>&1
	)
)
:HPUC_SKIPPED

echo ====================%date% %time% PostWizInstaller 11 DropBox =================>>%logSpec%
if exist "c:\hp\hpqware\DropBox\postuser.bat" (
	echo %date%%time% run DropBox >>%logSpec%	
	call c:\hp\hpqware\DropBox\postuser.bat
)

echo ====================%date% %time% PostWizInstaller 12 EasySetup =================>>%logSpec%
if exist "c:\hp\hpqware\EasySetup\postuser.bat" (
	echo %date%%time% run EasySetup >>%logSpec%	
	call c:\hp\hpqware\EasySetup\postuser.bat
)

echo ====================%date% %time% PostWizInstaller 13 WelcomeApp =================>>%logSpec%
if exist "C:\HP\HPQWare\WelcomeAppPostUser\WelcomeAppPostUser.bat" (
	echo %date%%time% run WelcomeApp >>%logSpec%	
	call C:\HP\HPQWare\WelcomeAppPostUser\WelcomeAppPostUser.bat
)

echo ====================%date% %time% PostWizInstaller 14 LinioPostUser =================>>%logSpec%
if exist "C:\hp\hpqware\LinioPostUser\LinioPostUser.bat" (
	echo %date%%time% run LinioPostUser >>%logSpec%	
	call C:\hp\hpqware\LinioPostUser\LinioPostUser.bat
)

echo ====================%date% %time% PostWizInstaller 15 McAfeePostUser =================>>%logSpec%
if exist "C:\HP\HPQware\McAfeePostUser\RemoveMcAfeeReg.cmd" (
	echo %date%%time% run McAfeePostUser >>%logSpec%	
	call C:\HP\HPQware\McAfeePostUser\RemoveMcAfeeReg.cmd
)

echo ====================%date% %time% PostWizInstaller 16 HPSmartFriend =================>>%logSpec%
if exist "C:\HP\HPQWare\HPSmartFriend_URL\SFPostUser.bat" (
	echo %date%%time% run SFPostUser >>%logSpec%	
	call C:\HP\HPQWare\HPSmartFriend_URL\SFPostUser.bat
)

echo ====================%date% %time% PostWizInstaller 17 HPAudioSwitch =================>>%logSpec%
if exist "C:\HP\HPQWare\HPAudioSwitch\PostUser.bat" (
	echo %date%%time% run HPAudioSwitch >>%logSpec%	
	call C:\HP\HPQWare\HPAudioSwitch\PostUser.bat
)

echo ====================%date% %time% PostWizInstaller 18 AmazonAssistant =================>>%logSpec%
if exist "C:\HP\HPQWare\AmazonAssistant\PostUser.bat" (
	echo %date%%time% run AmazonAssistant >>%logSpec%	
	call C:\HP\HPQWare\AmazonAssistant\PostUser.bat
)

echo ====================%date% %time% TypedURL begin =================>>%logSpec%

set TypedURL_Path=c:\hp\hpqware\TypedURL\Merged
if not exist %TypedURL_Path% md %TypedURL_Path%

echo %date% %time% Copy c:\hp\hpqware\TypedURL\%ISO_UILGCTRY%\%ISO_COUNTRY3% to %TypedURL_Path% >>%logSpec%
if exist "c:\hp\hpqware\TypedURL\%ISO_UILGCTRY%\%ISO_COUNTRY3%" xcopy /e/i/y/f "c:\hp\hpqware\TypedURL\%ISO_UILGCTRY%\%ISO_COUNTRY3%" "%TypedURL_Path%" >>%logSpec% 2>&1
echo %date% %time% Copy c:\hp\hpqware\TypedURL\All\%ISO_COUNTRY3% to %TypedURL_Path% >>%logSpec%
if exist "c:\hp\hpqware\TypedURL\All\%ISO_COUNTRY3%" xcopy /e/i/y/f "c:\hp\hpqware\TypedURL\All\%ISO_COUNTRY3%" "%TypedURL_Path%" >>%logSpec% 2>&1
echo %date% %time% Copy c:\hp\hpqware\TypedURL\All\All to %TypedURL_Path% >>%logSpec%
if exist "c:\hp\hpqware\TypedURL\All\All" xcopy /e/i/y/f "c:\hp\hpqware\TypedURL\All\All" "%TypedURL_Path%" >>%logSpec% 2>&1

if exist "%TypedURL_Path%" (
	setlocal enabledelayedexpansion
	set count=0
	for /r %TypedURL_Path% %%u in (*.url) do (
		echo %%u >>%logSpec%
		for /f "tokens=1,* delims==" %%a in (%%u) do (
			if %%a==URL (
				set /a count=!count!+1
				echo url!count!=%%b >>%logSpec%
				reg add "HKCU\SOFTWARE\Microsoft\Internet Explorer\TypedURLs" /v url!count! /t REG_SZ /d %%b /f
			)
		)
	)
	endlocal
)

echo ==================== %date% %time% amazon taskbar =================>>%logSpec%
if exist "C:\HP\HPQware\TaskbarFolder\%ISO_UILGCTRY%\%ISO_COUNTRY3%\" (
	echo %date% %time% found C:\HP\HPQware\TaskbarFolder\%ISO_UILGCTRY%\%ISO_COUNTRY3%\ >>%logSpec%
	xcopy /e/i/y "C:\HP\HPQware\TaskbarFolder\%ISO_UILGCTRY%\%ISO_COUNTRY3%" "C:\HP\HPQware\Taskbar" >>%logSpec% 2>&1
)

echo ==================== %date% %time% reg unload HKLM\DefaultUser =================>>%logSpec%
reg unload HKLM\DefaultUser
popd

if exist "c:\hp\hpqware\DTShortcuts\%ISO_UILGCTRY%\%ISO_COUNTRY3%\*.lnk" copy /y "c:\hp\hpqware\DTShortcuts\%ISO_UILGCTRY%\%ISO_COUNTRY3%\*.lnk" "%COMMON DESKTOP%" >>%logSpec% 2>&1

echo ==================== %date% %time% PostWizInstaller finish =================>>%logSpec%