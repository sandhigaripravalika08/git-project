pushd %~dp0
set logs=c:\system.sav\logs\CEPS\BTBHost
set WizlogSpec=%logs%\wizinstaller.log
set asgMetroLogSpec=%logs%\asgmetro.log
set asgMetroCustomLogSpec=%logs%\asgmetro-custom.log
set asgMetroSwsetupLogSpec=%logs%\asgmetro-swsetup.log
set asgTaskbarLogSpec=%logs%\asgtaskbar.log
set asgEdgeFavLogSpec=%logs%\asgedgefav.log
set asgAudioBrandSpec=%logs%\audiobrand.log
set logSpec=%logs%\%~nx0.log
set LayoutModificationXML=C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml
set LayoutModificationJSON=C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.json
set TaskbarLayoutModificationXML=C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\TaskbarLayoutModification.xml
@echo %date% %time% BTB Post Install Start Running>> %WizlogSpec%

if exist C:\system.sav\util\SetVariables.cmd (Call c:\system.sav\util\SetVariables.cmd) else (echo [%date% %time%] SetVariables.cmd Not Found>>%logs%\%~nx0.log)
if exist C:\system.sav\util\TDCSetVariables.cmd (Call c:\system.sav\util\TDCSetVariables.cmd) else (echo [%date% %time%] TDCSetVariables.cmd Not Found>>%logs%\%~nx0.log)

md "C:\ProgramData\HP\Images"
if /I "%PCBRAND%" == "Presario" (
	copy "c:\hp\HPQWare\BTBHost\Images\cpq_wc_logo.png" "C:\ProgramData\HP\Images\wc_logo.png" /y
) else (
	copy "c:\hp\HPQWare\BTBHost\Images\hp_wc_logo.png" "C:\ProgramData\HP\Images\wc_logo.png" /y
)

set IsWin11=0
if exist c:\system.sav\flags\WOct21.flg set IsWin11=1
if exist c:\system.sav\flags\W11.flg set IsWin11=1
if "%ATF_OS.Z%" == "1" set IsWin11=1

if "%R_MIC%"=="1" (
	echo >> c:\system.sav\flags\BtBR_MIC.flg
	if exist c:\hp\bin\Rstone.ini (
		if exist c:\system.sav\flags\BtBOSWin10RS.flg (
			echo Copy MFU_cNB.ini for cNB RedStone MSSI >>%asgMetroLogSpec%
			copy /y %~dp0\Signature\RedStone\MFU_cNB.ini %~dp0\MFU.ini >>%asgMetroLogSpec% 2>&1
		) else (
			echo Copy MFU_cNB.ini for cNB MSSI >>%asgMetroLogSpec%
			copy /y %~dp0\Signature\MFU_cNB.ini %~dp0\MFU.ini >>%asgMetroLogSpec% 2>&1
		)
	) else (
		if exist c:\system.sav\flags\BtBOSWin10RS.flg (
			echo Copy MFU.ini for cPC RedStone MSSI >>%asgMetroLogSpec%
			copy /y %~dp0\Signature\RedStone\MFU.ini %~dp0\MFU.ini >>%asgMetroLogSpec% 2>&1
		) else (
			echo Copy MFU.ini for cPC MSSI >>%asgMetroLogSpec%
			copy /y %~dp0\Signature\MFU.ini %~dp0\MFU.ini >>%asgMetroLogSpec% 2>&1
		)
	)
)
FOR /F "tokens=3" %%A IN ('REG QUERY "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v BaseBoardProduct') DO SET SystemBoardProductId=%%A
echo languagecode=%languagecode% >> %asgMetroLogSpec%
echo SystemBoardProductId=%SystemBoardProductId% >> %asgMetroLogSpec%
if "%SCH_EDU%" == "1" if /i not "%languagecode%" == "AB2" if /i not "%languagecode%" == "B1L" (
	echo Apply HP School Pack group name >>%asgMetroLogSpec%
	copy /y %~dp0\Edu\MetroXmlProcessor.ini %~dp0 >>%asgMetroLogSpec% 2>&1
)

if "%R_ENTRDY%" == "1" (
	echo [%date% %time%] Copy XMLs for MMD/CORP-RDY SKUs >> %logs%\%~nx0.log
	if "%IsWin11%" == "1" (
		echo Win11 >> %logs%\%~nx0.log
		if "%languagecode%" == "ACB" (
			echo xcopy /e/i/y/f "%~dp0MMD_ACB\Win11" "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell for ACB" >> %logs%\%~nx0.log
			xcopy /e/i/y/f "%~dp0MMD_ACB\Win11" "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell" >> %logs%\%~nx0.log 2>&1	
		) else (
			echo xcopy /e/i/y/f "%~dp0MMD\Win11" "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell for WW" >> %logs%\%~nx0.log
			xcopy /e/i/y/f "%~dp0MMD\Win11" "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell" >> %logs%\%~nx0.log 2>&1			
		)
	) else (
		echo Win10 >> %logs%\%~nx0.log
		if "%languagecode%" == "ACB" (
			if "%TCOE%" == "1" (
				echo xcopy /e/i/y/f "%~dp0MMD_ACB\Win10_TCOE" "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell for ACB TCOE" >> %logs%\%~nx0.log
				xcopy /e/i/y/f "%~dp0MMD_ACB\Win10_TCOE" "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell" >> %logs%\%~nx0.log 2>&1
			) else (
				echo xcopy /e/i/y/f "%~dp0MMD_ACB\Win10" "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell for ACB" >> %logs%\%~nx0.log
				xcopy /e/i/y/f "%~dp0MMD_ACB\Win10" "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell" >> %logs%\%~nx0.log 2>&1
			)
		) else (
			if "%TCOE%" == "1" (
				echo xcopy /e/i/y/f "%~dp0MMD\Win10_TCOE" "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell for WW TCOE" >> %logs%\%~nx0.log
				xcopy /e/i/y/f "%~dp0MMD\Win10_TCOE" "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell" >> %logs%\%~nx0.log 2>&1
			) else (
				echo xcopy /e/i/y/f "%~dp0MMD\Win10" "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell for WW" >> %logs%\%~nx0.log
				xcopy /e/i/y/f "%~dp0MMD\Win10" "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell" >> %logs%\%~nx0.log 2>&1
			)
		)
		echo [%date% %time%] Add registry key for taskbar >> %logs%\%~nx0.log
		reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer /v "LayoutXMLPath" /t REG_SZ /d %TaskbarLayoutModificationXML% /f >> %logs%\%~nx0.log 2>&1	
	)
	goto NoFillerPresent
)

if "%VOS.B%" == "1" if "%S_Mode%" == "1" (
	echo [%date% %time%] Copy XMLs for Win11SE >> %logs%\%~nx0.log

	echo xcopy /e/i/y/f "%~dp0Edu\Win11SE" "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell for Win11SE" >> %logs%\%~nx0.log
	xcopy /e/i/y/f "%~dp0Edu\Win11SE" "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell" >> %logs%\%~nx0.log 2>&1
	
	echo [%date% %time%] Add registry key for taskbar >> %logs%\%~nx0.log
	reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer /v "LayoutXMLPath" /t REG_SZ /d %TaskbarLayoutModificationXML% /f >> %logs%\%~nx0.log 2>&1		

	goto NoFillerPresent
)

:: Clear Taskbar.ini if TouchpointCustomizer supported centralized taskbar pining
if exist c:\system.sav\flags\BtBTaskbar.flg (
	echo try to delete c:\hp\hpqware\btbhost\Taskbar.ini >>%asgTaskbarLogSpec%
	if exist c:\hp\hpqware\btbhost\Taskbar.ini del c:\hp\hpqware\btbhost\Taskbar.ini >> %asgTaskbarLogSpec% 2>&1
)

:: Clear Edge favorite bar registry keys if TouchpointCustomizer supported centralized pining
if exist c:\system.sav\flags\BtBEdgeFav.flg (
	echo Try to delete c:\hp\hpqware\btbhost\WizEdgeFav.ini >> %asgEdgeFavLogSpec%
	if exist c:\hp\hpqware\btbhost\WizEdgeFav.ini del c:\hp\hpqware\btbhost\WizEdgeFav.ini >> %asgEdgeFavLogSpec% 2>&1
	echo Try to delete registry keys: [HKLM\SOFTWARE\Microsoft\MicrosoftEdge\Main\FavoriteBarItems] >> %asgEdgeFavLogSpec%
	reg delete "HKLM\SOFTWARE\Microsoft\MicrosoftEdge\Main\FavoriteBarItems" /f >> %asgEdgeFavLogSpec% 2>&1
)



echo --- TouchpointCustomizer Parse c:\swsetup --- >>%asgMetroCustomLogSpec%

tree /a /f c:\swsetup > %asgMetroSwsetupLogSpec%

if "%IsWin11%" == "1" (
	c:\hp\hpqware\TouchpointCustomizer\TouchpointCustomizer.exe c:\hp\hpqware\TouchpointCustomizer\TouchpointCustomizer_WOct21.csv "c:\swsetup" OutputJSON >>%asgMetroCustomLogSpec%
) else (
	c:\hp\hpqware\TouchpointCustomizer\TouchpointCustomizer.exe c:\hp\hpqware\TouchpointCustomizer\TouchpointCustomizer.csv "c:\swsetup" >>%asgMetroCustomLogSpec%
)

if "%IsWin11%" == "1" (
	c:\hp\hpqware\btbhost\StartTileProcessor.exe c:\swsetup >> %asgMetroLogSpec%
) else (
	c:\hp\hpqware\btbhost\MetroXmlProcessor.exe c:\swsetup >> %asgMetroLogSpec%
)

echo. >>%asgMetroLogSpec%
if exist c:\system.sav\flags\BtBOSWin10.flg if NOT exist \system.sav\flags\BtBPinTileByReg.flg (
	if exist %LayoutModificationXML% c:\hp\hpqware\btbhost\RemoveXMLNS.vbs %LayoutModificationXML%
	copy /y %LayoutModificationXML% %logs%
)

:: Parse c:\hp\hpqware\btbhost\Taskbar.ini to create TaskbarLayoutModification.xml for RedStone taskbar app pinning
c:\hp\hpqware\btbhost\TaskbarProcessor.exe >> %asgTaskbarLogSpec%
echo. >>%asgTaskbarLogSpec%	
if exist c:\system.sav\flags\BtBOSWin10RS.flg if exist %TaskbarLayoutModificationXML% (
	echo delete c:\HP\HPQWare\BTBHost\PBR\RegSrc\Taskbar.ini >>%asgTaskbarLogSpec%
	del c:\HP\HPQWare\BTBHost\PBR\RegSrc\Taskbar.ini >>%asgTaskbarLogSpec% 2>&1
	reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer /v "LayoutXMLPath" /t REG_SZ /d %TaskbarLayoutModificationXML% /f >>%asgTaskbarLogSpec% 2>&1
	c:\hp\hpqware\btbhost\RemoveXMLNS.vbs %TaskbarLayoutModificationXML%
	copy /y %TaskbarLayoutModificationXML% %logs%
)

if exist %LayoutModificationJSON% copy /y %LayoutModificationJSON% %logs%

:: Pin Edge favorite bar icons based on WizEdgeFav.ini
if exist c:\hp\hpqware\btbhost\WizEdgeFav.ini (
	echo c:\system.sav\util\WizInstaller.exe c:\hp\hpqware\btbhost\WizEdgeFav.ini >> %asgEdgeFavLogSpec%
	c:\system.sav\util\WizInstaller.exe c:\hp\hpqware\btbhost\WizEdgeFav.ini >> %asgEdgeFavLogSpec%
	echo Backup WizEdgeFav.ini to log folder >> %asgEdgeFavLogSpec%
	copy /y c:\hp\hpqware\btbhost\WizEdgeFav.ini %logs% >> %asgEdgeFavLogSpec% 2>&1
)

:: Create NewAudioLogo registry key based on AudioBrand.ini
if exist c:\hp\hpqware\btbhost\AudioBrand.ini (
	echo Parsing c:\hp\hpqware\btbhost\AudioBrand.ini >> %asgAudioBrandSpec%
	set NewAudioLogo=0
	for /f "tokens=1,2 usebackq delims=^=" %%a in (c:\hp\hpqware\btbhost\AudioBrand.ini) do (
		if "%%a" == "NewAudioLogo" set NewAudioLogo=%%b
	)
	setlocal enableDelayedExpansion
    set "NewAudioLogo=!NewAudioLogo:*:=!"
	echo NewAudioLogo = "!NewAudioLogo!" >> %asgAudioBrandSpec%
	
	if not "!NewAudioLogo!" == "0" ( 
		echo Create registry key NewAudioLogo under [HKLM\Software\HP\CommonInfo] >> %asgAudioBrandSpec%
		reg add HKLM\Software\HP\CommonInfo /v "NewAudioLogo" /t REG_DWORD /d !NewAudioLogo! /f >>%asgAudioBrandSpec% 2>&1
	) else (
		echo Skip registry key NewAudioLogo creation  >> %asgAudioBrandSpec%
	)
	endlocal
	
	echo Backup AudioBrand.ini to log folder >> %asgAudioBrandSpec%
	copy /y c:\hp\hpqware\btbhost\AudioBrand.ini %logs% >> %asgAudioBrandSpec% 2>&1
) else (
	echo No AudioBrand.ini, Skip registry key NewAudioLogo creation >> %asgAudioBrandSpec%
)

set HalfCover=0
For /f "tokens=1,2 usebackq delims='='" %%a in (C:\HP\Bin\RStone.INI) do (
	If "%%a" == "Half-cover" Set HalfCover=%%b	
)

:: Win10 LayoutModification.xml solution doesn't need metro filler
if NOT exist \system.sav\flags\BtBPinTileByReg.flg goto NoFillerPresent
::Add filler tile if one is available and an odd number of tiles are present.
if NOT exist c:\hp\hpqware\metrofiller\metro.xml goto NoFillerPresent

pushd \hp\hpqware\metro\all\all
setlocal enabledelayedexpansion
set count=0

::metro.reg is unicode, metroTmp.reg will be ANSI so for /f will work.
more < metro.reg > metroTmp.reg

for /f %%a in ( metroTmp.reg ) do (
echo %%a | find /i "squaretiles\squaretile" >NUL && set /a count=!count!+1
)

set /a odd=!count!%% 2

if "%odd%"=="1" (
   if not exist c:\swsetup\metrofiller md c:\swsetup\metrofiller
   copy /y c:\hp\hpqware\metrofiller\metro.xml c:\swsetup\metrofiller
   del /f /q metro.reg
   del /f /q metroWinPE.reg
   c:\hp\hpqware\btbhost\metroxmlprocessor.exe c:\swsetup
)
del /f /q metroTmp.reg
rd /s/q c:\swsetup\metrofiller

endlocal
popd

:NoFillerPresent

echo.>>%asgMetroLogSpec%
c:\system.sav\util\WizInstaller.exe c:\hp\hpqware\btbhost\SCMID.ini >> %WizlogSpec%

:: Prep for 2pp setup
set postProcessDest=c:\system.sav\util\2postprocess
if NOT exist %postProcessDest% md %postProcessDest%

:: Set up 2pp so machine unique attributes are included in custom.data
echo==========%date% %time% BTB Post Install Start 2pp setup==========>>%logSpec%
set customDataDest=%postProcessDest%\customdata
if NOT exist %customDataDest% md %customDataDest% >>%logSpec% 2>&1
xcopy /y /f BtBCustomData.cmd %postProcessDest% >>%logSpec% 2>&1
xcopy /y /f customData.cmd %customDataDest% >>%logSpec% 2>&1
xcopy /y /f customData.ini %customDataDest% >>%logSpec% 2>&1
echo==========%date% %time% BTB Post Install End 2pp setup==========>>%logSpec%

:: check platform code
set cNB=0
echo [%date% %time%] PlatformCode=%PlatformCode%>>%logs%\%~nx0.log
if exist c:\hp\bin\Rstone.ini set cNB=1
:: Consumer leverage commercial projects like Hugo still have RStone.ini but it apply commercial PIN process
if exist c:\system.sav\flags\proteus.flg set cNB=0
if %cNB% == 1 (goto CNB) else (goto DEFAULT)

:CNB
::Import the tile registry
if exist \system.sav\flags\BtBPinTileByReg.flg (
   echo reg import C:\hp\HPQware\Metro\All\All\Metro.reg >>%asgMetroLogSpec%
   reg import C:\hp\HPQware\Metro\All\All\Metro.reg >>%asgMetroLogSpec% 2>&1
)
echo ====================%date% %time%  Setup PromoteOEMTiles Setting=================>>%logSpec%
set MSSIG=1
if exist c:\system.sav\flags\mssign.flg set MSSIG=0
if "%R_MIC%"=="1" set MSSIG=0

If "%MSSIG%"=="1" (
	echo adding OEM tile promotion to registry >>%asgMetroLogSpec%
	reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\SVDEn /v "PromoteOEMTiles" /t REG_DWORD /d 1 /f >>%asgMetroLogSpec% 2>&1
)

echo ====================%date% %time%  Finish Setup PromoteOEMTiles setting:%MSSIG%=================>>%logSpec%
goto :END


:DEFAULT

if NOT exist \system.sav\flags\BtBPinTileByReg.flg goto :END

:: Copy MetroWinPE.Reg for Win PE Import
set recImageLocation1=C:\system.sav\tweaks\Recovery\RecoveryImage\Point_D
set recImageLocation2=C:\system.sav\tweaks\Recovery\RecoveryImage\Point_B

if NOT exist %recImageLocation1% md %recImageLocation1%
if NOT exist %recImageLocation2% md %recImageLocation2%

copy /y C:\hp\hpqware\Metro\All\All\MetroWinPE.Reg %recImageLocation1%>> %asgMetroLogSpec% 2>&1
copy /y C:\hp\hpqware\Metro\All\All\MetroWinPE.Reg %recImageLocation2%>> %asgMetroLogSpec% 2>&1

:: Copy the import .cmd for Win PE import
copy /y PinTilesWPE.cmd %recImageLocation1%>> %asgMetroLogSpec% 2>&1
copy /y PinTilesWPE.cmd %recImageLocation2%>> %asgMetroLogSpec% 2>&1

::Set up tile 2pp, do not run now even if not GMPP
::copy /y PinTiles.cmd %postProcessDest% >> %asgMetroLogSpec% 2>&1
echo call PinTiles.cmd directly>>%logSpec%
call PinTiles.cmd
:END

echo==========%date% %time% Call BtBCustomData==========>>%logSpec%

:: If this is not GMPP build flow the unique attributes are available now
if NOT exist \system.sav\flags\GM2PP.FLG (
   echo GM2PP.FLG not presen, Call BtBCustomDatat>>%logSpec%
   pushd %postProcessDest%
   call BtBCustomData.cmd
   popd
)

:: Copy custom.data for HP Welcome that requested by Tracy 
echo==========%date% %time% Copy custom.data for HP Welcome==========>>%logSpec%
set customDataHPWelcome=C:\Program Files\HP\HP Welcome
if exist %customDataHPWelcome% (
   copy /y c:\Users\Default\Documents\hp.system.package.metadata\custom.hpdata "%customDataHPWelcome%\custom.data" >>%logSpec% 2>&1
)

:: Export registry for recovery
if exist c:\system.sav\flags\BtBOSWin10.flg if NOT exist \system.sav\flags\BtBPinTileByReg.flg (
	if exist c:\system.sav\flags\Disney.flg (
		echo do not restore taskbar in Crunch 1.1 SE >>%logSpec%
		del /f /q %~dp0\PBR\RegSrc\Taskbar.ini >> %logSpec% 2>&1
	)
	echo call %~dp0\PBR\ExportRegXML.cmd >>%logSpec%
	call %~dp0\PBR\ExportRegXML.cmd >>%logSpec%
	if exist C:\Recovery\OEM\Point_B\ (
		echo copy PBR command to C:\Recovery\OEM\Point_B\ >>%logSpec%
		copy /y %~dp0\PBR\BTBHostB_PBR.cmd C:\Recovery\OEM\Point_B\ >> %logSpec% 2>&1
		if exist %~dp0\PBR\BTBHost\ xcopy /e/i/y/f %~dp0\PBR\BTBHost\*.* C:\Recovery\OEM\Point_B\BTBHost\*.* >> %logSpec% 2>&1
	)
	if exist C:\Recovery\OEM\Point_D\ (
		echo copy PBR command to C:\Recovery\OEM\Point_D\ >>%logSpec%
		copy /y %~dp0\PBR\BTBHostD_PBR.cmd C:\Recovery\OEM\Point_D\ >> %logSpec% 2>&1
		if exist %~dp0\PBR\BTBHost\ xcopy /e/i/y/f %~dp0\PBR\BTBHost\*.* C:\Recovery\OEM\Point_D\BTBHost\*.* >> %logSpec% 2>&1
	)
)

echo ====================%date% %time%  HPMUIDIR begin =================>>%logSpec%

pushd C:\Windows\System32
.\HPMUIDir.exe
popd
echo ====================%date% %time%  HPMUIDIR finish =================>>%logSpec%

echo ====================%date% %time%  Copy IE Fav for CloudOS begin =================>>%logSpec%
C:\HP\HPQWare\BTBHost\Getlocale.exe
call C:\HP\HPQware\setlocale.bat
type C:\HP\HPQware\setlocale.bat >>%logSpec%
if exist "c:\hp\hpqware\Favs\All\%ISO_COUNTRY3%" (
	echo Copy IE Favorite for Windows CloudOS >>%logSpec%
	xcopy /e/i/y/f "c:\hp\hpqware\Favs\All\%ISO_COUNTRY3%" "C:\Users\Default\Favorites" >>%logSpec% 2>&1
) else (
	echo No default country IE favorite for copying >>%logSpec%
)
echo ====================%date% %time%  Copy IE Fav for CloudOS end =================>>%logSpec%

echo ====================%date% %time% Remove AdobeReedem utility begin =================>>%logSpec%
if exist c:\HP\HPQWare\BTBHost\AdobeReedem rd /s/q c:\HP\HPQWare\BTBHost\AdobeReedem >> %logs%\%~nx0.log 2>&1
echo ====================%date% %time%  Remove AdobeReedem utility end =================>>%logSpec%

:: Export registry files for debugging.
if not exist %logs% md %logs%
reg export "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SVDEn" %logs%\Reg.asgmetro.log /y >>%logSpec% 2>&1
reg export "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Store" %logs%\Reg.SCMID.log /y >>%logSpec% 2>&1
reg export "HKLM\SOFTWARE\HP\System Properties" %logs%\Reg.SysProp.log /y >>%logSpec% 2>&1
reg export "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" %logs%\Reg.EnvVar.log /y  >>%logSpec% 2>&1
reg export "HKLM\SOFTWARE\Microsoft\MicrosoftEdge\Main\FavoriteBarItems" %logs%\Reg.FavoriteBarItems.log /y >>%logSpec% 2>&1

reg export "HKLM\SOFTWARE\McAfee\MSC\AppInfo\Substitute" %logs%\Reg.McAfee.affid.log /y >>%logSpec% 2>&1
reg export "HKLM\SOFTWARE\McAfee\OemInfo\substitute" %logs%\Reg.McAfee.terms.log /y >>%logSpec% 2>&1

:: Backup RStone and vars.ini
if exist c:\hp\bin\RStone.ini copy /y c:\hp\bin\RStone.ini %logs% 2>&1
if exist c:\system.sav\util\vars.ini copy /y c:\system.sav\util\vars.ini %logs% 2>&1

if exist c:\HP\HPQWare\BTBHost\TouchpointStatus.ini copy /y c:\HP\HPQWare\BTBHost\TouchpointStatus.ini %logs% 2>&1

@echo %date% %time% BTB Post Install Finish Running>>%logs%\wizinstaller.log

popd