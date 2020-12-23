@echo off
if exist bin/AutoHotKey.exe (
    start bin/AutoHotKey.exe SnapWindow.ahk > nul 2> nul
) else (
    for %%X in (AutoHotKey.exe) do (set FOUND=%%~$PATH:X)
    if defined FOUND (
        start AutoHotKey.exe SnapWindow.ahk > nul 2> nul
    )
    if not defined FOUND (
        echo Please put AutoHotKey.exe on bin/ directory or install AutoHotKey
        pause 
    )
) 
