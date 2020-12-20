REM Filename: vlc.bat
REM Copyright (c) 2020 Fernando Manuel Fernandes Rodrigues <fmfrodrigues@gmail.com>
@echo off
REM Because of escapating (=) equal sign
set URL=%1
set URL2=%2
Powershell.exe -windowstyle hidden -executionpolicy remotesigned -File vlc.ps1 %1^=%2