REM Filename: vlc_send_cmd.bat
REM Copyright (c) 2020 Fernando Manuel Fernandes Rodrigues <fmfrodrigues@gmail.com>
@echo off
Powershell.exe -executionpolicy remotesigned -windowstyle hidden -File vlc_send_cmd.ps1 %1