@echo off
TITLE "SandboxScript"
REM:: (This finds your Sandbox dir on C:\) 
set "base_image_path=C:\ProgramData\Microsoft\Windows\Containers\BaseImages"
set "startup_path=BaseLayer\Files\Users\WDAGUtilityAccount\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
for /f "delims=" %%a in ('dir /ad /b "%base_image_path%" ^| findstr /r "[0-9a-f]*-[0-9a-f]*-[0-9a-f]*-[0-9a-f]*-[0-9a-f]*"') do set "guid=%%a"
set "target_path=%base_image_path%\%guid%\%startup_path%"
cd %target_path%


REM:: (This changes sandbox to developers mode to beable to run unsigned scripts)
echo reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1" > winget.bat


REM:: (This is what is needed to add Winget to Sandbox)
echo start /wait Powershell.exe Invoke-WebRequest -Uri https://github.com/microsoft/winget-cli/releases/download/v1.3.2691/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -OutFile .\MicrosoftDesktopAppInstaller.msixbundle >> winget.bat
echo start /wait Powershell.exe Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.appx >> winget.bat
echo start /wait Powershell.exe Add-AppxPackage Microsoft.VCLibs.appx >> winget.bat
echo start /wait Powershell.exe Add-AppxPackage MicrosoftDesktopAppInstaller.msixbundle >> winget.bat


REM:: (This Installs chocolatey)
echo start /wait powershell.exe Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) >> winget.bat


echo cd C:\ProgramData\chocolatey >> winget.bat


REM:: (This Installs VScode, Terminal, Chrome, Git, Notepad++, 7zip, Python and Nodejs)
echo start /wait choco.exe install vscode -y --acceptlicense --confirm microsoft-windows-terminal -y --acceptlicense googlechrome -y --acceptlicense --confirm git -y --acceptlicense --confirm notepadplusplus -y --acceptlicense --confirm 7zip -y --acceptlicense --confirm python -y --acceptlicense --confirm nodejs -y --acceptlicense --confirm >> winget.bat


REM:: (This exits the shell in the sandbox)
echo EXIT >> winget.bat


REM:: (This Starts your Sandbox from the host)
cd "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\"
"Windows Sandbox.lnk"


