REM Chocolatey installation
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None ^
 -ExecutionPolicy Bypass ^
 -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" ^
 && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

REM I hope this happened already:
REM cinst -y git
REM cinst -y unzip part of git

cinst -y wget
