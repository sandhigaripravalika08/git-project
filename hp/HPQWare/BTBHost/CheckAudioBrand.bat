@setlocal enableextensions enabledelayedexpansion
@echo off 
set AudioBrand=None
:CheckWin8
if NOT exist "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Music, Photos and Videos" goto CheckWin10
for /f "tokens=*" %%a in ('dir "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Music, Photos and Videos\*.lnk" /b /s') do (
	set link=%%a
	set strOrig=x!link!
	set strBeats=x!link:Beats=!
	set strHPAudio=x!link:HP Audio.lnk=!
	set strDTS=x!link:DTS Audio=!
	set strBnOPlay=x!link:B^&O Play=!
	set strBnO=x!link:Bang ^& Olufsen=!
	
	if not !strOrig!==!strBeats! set AudioBrand=Beats Audio
	if not !strOrig!==!strHPAudio! set AudioBrand=HP Audio
	if not !strOrig!==!strDTS! set AudioBrand=DTS Audio
	if not !strOrig!==!strBnO! set AudioBrand=Bang ^^^^^^^& Olufsen
	if not !strOrig!==!strBnOPlay! set AudioBrand=B^^^^^^^&O Play
)
:CheckWin10
if NOT exist "%ProgramData%\Microsoft\Windows\Start Menu\Programs" goto AppendToScript
for /f "tokens=*" %%a in ('dir "%ProgramData%\Microsoft\Windows\Start Menu\Programs\*.lnk" /b /s') do (
	set link=%%a
	set strOrig=x!link!
	set strBeats=x!link:Beats=!
	set strHPAudio=x!link:HP Audio.lnk=!
	set strDTS=x!link:DTS Audio=!
	set strBnOPlay=x!link:B^&O Play=!
	set strBnO=x!link:Bang ^& Olufsen=!
	
	if not !strOrig!==!strBeats! set AudioBrand=Beats Audio
	if not !strOrig!==!strHPAudio! set AudioBrand=HP Audio
	if not !strOrig!==!strDTS! set AudioBrand=DTS Audio
	if not !strOrig!==!strBnO! set AudioBrand=Bang ^^^^^^^& Olufsen
	if not !strOrig!==!strBnOPlay! set AudioBrand=B^^^^^^^&O Play
)

:AppendToScript
echo set AudioBrand=!AudioBrand! >> c:\HP\HPQware\BTBHost\SetCustomVars.bat
endlocal