#InstallKeybdHook
#Persistent
#SingleInstance force
WinGet, window_, List
X := 0
Y := 0
Width := 0
Height := 0

GetMonitorWorkArea(measurement, monToGet)
{
    SysGet, tmpMon, MonitorWorkArea, %monToGet%
	If (measurement = "width")
	{
		tmpMonWidth  := tmpMonRight - tmpMonLeft
		return tmpMonWidth
	}
	Else If (measurement = "height")
	{
		tmpMonHeight := tmpMonBottom - tmpMonTop
		return tmpMonHeight
	}
}

GetMonitors()
{
	SysGet, MonitorCount, MonitorCount
	return MonitorCount
}

GetMonitorIndexFromWindow(windowHandle)
{
	; Starts with 1.
	monitorIndex := 1

	VarSetCapacity(monitorInfo, 40)
	NumPut(40, monitorInfo)
	
	if (monitorHandle := DllCall("MonitorFromWindow", "uint", windowHandle, "uint", 0x2)) 
		&& DllCall("GetMonitorInfo", "uint", monitorHandle, "uint", &monitorInfo) 
	{
		monitorLeft   := NumGet(monitorInfo,  4, "Int")
		monitorTop    := NumGet(monitorInfo,  8, "Int")
		monitorRight  := NumGet(monitorInfo, 12, "Int")
		monitorBottom := NumGet(monitorInfo, 16, "Int")
		workLeft      := NumGet(monitorInfo, 20, "Int")
		workTop       := NumGet(monitorInfo, 24, "Int")
		workRight     := NumGet(monitorInfo, 28, "Int")
		workBottom    := NumGet(monitorInfo, 32, "Int")
		isPrimary     := NumGet(monitorInfo, 36, "Int") & 1

		SysGet, monitorCount, MonitorCount

		Loop, %monitorCount%
		{
			SysGet, tempMon, Monitor, %A_Index%

			; Compare location to determine the monitor index.
			if ((monitorLeft = tempMonLeft) and (monitorTop = tempMonTop)
				and (monitorRight = tempMonRight) and (monitorBottom = tempMonBottom))
			{
				monitorIndex := A_Index
				break
			}
		}
	}
	
	return monitorIndex
}

nWindow := "Kodi"
if A_args[1]
{
	nWindow := A_args[1]
}
winHandle := WinExist(nWindow)
WinGetPos, X, Y, Width, Height, ahk_id %winHandle%

$^!q::
	SetTitleMatchMode, 2
	WinActivate, ahk_id %winHandle%
	WinGetPos, X, Y, Width, Height, ahk_id %winHandle%
	WinGetTitle, tWindow, ahk_id %winHandle%
	monActive := GetMonitorIndexFromWindow(winHandle)
	IfWinExist %tWindow%
	{
		WinSet, Style, ^0xC00000, ahk_id %winHandle% ; toggle title bar
		Winset, Alwaysontop, On, ahk_id %winHandle%
		if (monActive = 1)
		{
			Width1 := GetMonitorWorkArea("width",1)
			Height1 := GetMonitorWorkArea("height",1)
			WinMove, ahk_id %winHandle%,, -7, 0, Width, Height, ,
		}
		if (monActive = 2)
		{
			Width1 := GetMonitorWorkArea("width",1)
			Height1 := GetMonitorWorkArea("height",1)
			Width2 := GetMonitorWorkArea("width",2)
			Height2 := GetMonitorWorkArea("height",2)
			WinMove, ahk_id %winHandle%,, -7+Width1, 0, Width, Height, ,
		}
	}
	return


$^!a::
	SetTitleMatchMode, 2
	WinActivate, ahk_id %winHandle%
	WinGetPos, X, Y, Width, Height, ahk_id %winHandle%
	WinGetTitle, tWindow, ahk_id %winHandle%
	monActive := GetMonitorIndexFromWindow(winHandle)
	IfWinExist %tWindow%
	{
		WinSet, Style, ^0xC00000 ; toggle title bar
		Winset, Alwaysontop, On, ahk_id %winHandle%
		if (monActive = 1)
		{
			Width1 := GetMonitorWorkArea("widht",1)
			Height1 := GetMonitorWorkArea("height",1)
			WinMove, ahk_id %winHandle%,, -7, Height1-Height+7, Width, Height, ,
		}
		if (monActive = 2)
		{
			Width1 := GetMonitorWorkArea("width",1)
			Height1 := GetMonitorWorkArea("height",1)
			Width2 := GetMonitorWorkArea("width",2)
			Height2 := GetMonitorWorkArea("height",2)
			WinMove, ahk_id %winHandle%,, -7+Width1, Height2-Height+7, Width, Height, ,
		}
	}
	return

$^!w::
	SetTitleMatchMode, 2
	WinActivate, ahk_id %winHandle%
	WinGetPos, X, Y, Width, Height, ahk_id %winHandle%
	WinGetTitle, tWindow, ahk_id %winHandle%
	monActive := GetMonitorIndexFromWindow(winHandle)
	IfWinExist %tWindow%
	{
		WinSet, Style, ^0xC00000 ; toggle title bar
		Winset, Alwaysontop, On, ahk_id %winHandle%
		if (monActive = 1)
		{
			Width1 := GetMonitorWorkArea("width",1)
			Height1 := GetMonitorWorkArea("height",1)
			WinMove, ahk_id %winHandle%,, 7+Width1-Width, 0, Width, Height, ,
		}
		if (monActive = 2)
		{
			Width1 := GetMonitorWorkArea("width",1)
			Height1 := GetMonitorWorkArea("height",1)
			Width2 := GetMonitorWorkArea("width",2)
			Height2 := GetMonitorWorkArea("height",2)
			WinMove, ahk_id %winHandle%,, 7+Width1+Width2-Width, 0, Width, Height, ,
		}
	}
	return

	$^!s::
	SetTitleMatchMode, 2
	WinActivate, ahk_id %winHandle%
	WinGetPos, X, Y, Width, Height, ahk_id %winHandle%
	WinGetTitle, tWindow, ahk_id %winHandle%
	monActive := GetMonitorIndexFromWindow(winHandle)
	IfWinExist %tWindow%
	{
		WinSet, Style, ^0xC00000 ; toggle title bar
		Winset, Alwaysontop, On, ahk_id %winHandle%
		if (monActive = 1)
		{
			Width1 := GetMonitorWorkArea("width",1)
			Height1 := GetMonitorWorkArea("height",1)
			WinMove, ahk_id %winHandle%,, 7+Width1-Width, Height1-Height+7, Width, Height, ,
		}
		if (monActive = 2)
		{
			Width1 := GetMonitorWorkArea("width",1)
			Height1 := GetMonitorWorkArea("height",1)
			Width2 := GetMonitorWorkArea("width",2)
			Height2 := GetMonitorWorkArea("height",2)
			WinMove, ahk_id %winHandle%,, 7+Width1+Width2-Width, Height2-Height+7, Width, Height, ,
		}
	}
	return

$^!x::
	ExitApp

$^!c::
	WinGetTitle, guiWindow, Select window
	IfWinExist %tWindow%
	{
		Gui,Destroy
	}
	Loop, %window_%
	{
		WinGetTitle,title,% "ahk_id" window_%A_Index%
		winlist.=title ? title "|" : ""
	}
	Gui, Add, DropDownList, x0 y0 w500 h20 R5 vtitle gWinTitle,%winlist%
	Gui, Show,h20, Select window
	return

WinTitle:
	Gui,Submit
	nWindow := title
	winHandle := WinExist(nWindow)
	WinGetPos, X, Y, Width, Height, ahk_id %winHandle%
	Gui,Destroy
	return