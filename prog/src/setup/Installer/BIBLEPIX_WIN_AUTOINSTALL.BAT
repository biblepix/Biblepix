::BiblePix Windows installation
::Updated 20jul21 pv
@ECHO OFF
TITLE BibelPix Windows Installation
PUSHD "%USERPROFILE%\Downloads"
SET magicsplat_url=https://vollmar.ch/biblepix/win/
SET biblepix_url=https://vollmar.ch/biblepix/release/BiblePix-Installer.tcl
SET BIBLEPIX_INSTALLER="BiblePix-Installer.tcl"
SET MAGICSPLAT_WISHPATH="%LOCALAPPDATA%\Apps\Tcl86\bin\wish.exe"
SET INSTALLER_VERSION=tcl-8.6.11-installer-1.11.2

::set Tcl installer to 64 or 32 bits
SET os_bitness=x64
IF %PROCESSOR_ARCHITECTURE%==x86 (
  IF NOT DEFINED PROCESSOR_ARCHITEW6432 SET os_bitness=x32
)
SET TCL_INSTALLER="%INSTALLER_VERSION%-%os_bitness%.msi"

:::check lang in Registry: if de_.. 
SET SEARCHSTRING=REG QUERY "hkcu\Control Panel\International" /v LocaleName
FOR /F "tokens=3 skip=2" %%i IN ('%SEARCHSTRING%') DO SET output=%%i
::choose only first 2 letters
SET TIL=%output:~0,2%

::FOR /F "tokens=*" %%a in ('REG QUERY hklm\system\currentcontrolset\control\nls\language /v InstallLanguage') do SET output=%%a 

::%$SET% SYSLANG=REG QUERY hklm\system\currentcontrolset\control\nls\language /v InstallLanguage
::FOR /F %%i in ('REG QUERY hklm\system\currentcontrolset\control\nls\language /v InstallLanguage') do SET output=%%i
::SET LANG=%output:~-5%
::IF %LANG%==0407 SET TIL=de

::ALL TEXTS AS LANG RELATED VARS
IF %TIL%==de (
  SET NOCURLFOUND=Wir haben das Download-Programm CURL nicht gefunden. Installieren Sie es ODER befolgen Sie die 2-Schritte-Alternative auf biblepix.vollmar.ch 
  SET TEXT1=Lade %BIBLEPIX_INSTALLER% herunter
  SET TEXT2=Tcl/Tk schon installiert!
  SET TEXT3=Installiere %TCL_INSTALLER% - Bitte beantworten Sie alle Fragen mit JA!
  SET TEXT4=Running BiblePix Setup - Please download desired Bible texts, make your choices and push the 'Save' button to complete installation
  SET TEXT5=Installation failed! Please follow steps on biblepix.vollmar.ch
  SET TEXT6=Gratulation and God's blessing! Installation successful!
) ELSE (
  SET NOCURLFOUND=We haven't found the CURL download programm. Install it OR follow the 2 step alternative on biblepix.vollmar.ch 
  SET TEXT1=Downloading %BIBLEPIX_INSTALLER%
  SET TEXT2=Tcl/Tk already installed!
  SET TEXT3=Installing %TCL_INSTALLER% - Please answer all questions with YES!
  SET TEXT4=Starte BibelPix-Einrichtungsprogramm - bitte gewünschte Bibeltexte herunterladen, Einstellungen anpassen und speichern
  SET TEXT5=Installation fehlgeschlagen! Bitte befolgen Sie die Anweisungen auf biblepix.vollmar.ch 
  SET TEXT6=Glückwunsch und Gottes Segen! Installation erfolgreich! 
)

:: 1. DOWNLOAD BIBLEPIX INSTALLER anyway
:STAGE1
  ECHO %TEXT1%
  PAUSE
  WHERE curl.EXE
  IF %ERRORLEVEL% NEQ 0 (
    ECHO %NOCURLFOUND%
    EXIT
  )  
  START curl.exe --output %BIBLEPIX_INSTALLER% --url %biblepix_url%

:: 2. DOWNLOAD TCL_INSTALLER if exec or file not found
:STAGE2
WHERE wish.EXE
IF %ERRORLEVEL% EQU 0 (
  SET WISHFOUND=1
  ECHO %TEXT2%
  PAUSE
  GOTO :STAGE4
) ELSE (
  IF NOT EXIST %TCL_INSTALLER% (
    ECHO Downloading %TCL_INSTALLER%
    PAUSE
    START curl.exe --output %TCL_INSTALLER% --url %magicsplat_url%/%TCL_INSTALLER%
  )
)

:: 3. INSTALL Magicsplat if no tcl executable found
:STAGE3
IF %WISHFOUND%==1 (
  ECHO %TEXT2%
  PAUSE
) ELSE (
  IF EXIST %TCL_INSTALLER% (
    ECHO %TEXT3%
    PAUSE
    START MSIEXEC /i %TCL_INSTALLER%
  )
)

:: 4. RUN BIBLEPIX SETUP 
:STAGE4
ECHO %TEXT4%
PAUSE
IF %WISHFOUND%==1 (
  START wish.exe %BIBLEPIX_INSTALLER%
  IF %ERRORLEVEL% NEQ 0 (
    ECHO %TEXT5%
    PAUSE
  )
  EXIT
) ELSE (
  START %MAGICSPLAT_WISHPATH% %BIBLEPIX_INSTALLER%
  IF %ERRORLEVEL% NEQ 0 (
    ECHO %TEXT5%
    PAUSE
  )
  EXIT
) 

::TODO is this ever shown?
ECHO %TEXT6%
PAUSE
EXIT
