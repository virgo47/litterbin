REM Chocolatey installation
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None ^
 -ExecutionPolicy Bypass ^
 -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" ^
 && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

REM I hope git is installed already, but we can safely try again.
REM cinst -y unzip (is part of git)

cinst -y git
cinst -y wget
