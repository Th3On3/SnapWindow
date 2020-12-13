/*
 * Filename: SnapWindow.ahk
 *
 * Copyright (c) 2020 Fernando Manuel Fernandes Rodrigues <fmfrodrigues@gmail.com>
 */

#InstallKeybdHook
#Persistent
#SingleInstance force
WinGet, window_, List
X := 0
Y := 0
Width := 0
Height := 0
StartX := 0
StartY := 0
StartWidth := 0
StartHeight := 0
TransparecyLevel := 255
StartAspectRatio := 0
Fullscreen := false
SnapWindowTitle := "SnapWindow - Select window"
SnapWindowTransparecyTitle := "SnapWindow - Change transparecy"
SnapWindowSizeTitle := "SnapWindow - Change size"
SnapWindowAppName := "SnapWindow"

SplashGUI(Pic, X, Y, TimeOn, Alpha = false)
{
	Gui, XPT99:Margin , 0, 0
	Gui, XPT99:Add, Picture,, %Pic%
	Gui, XPT99:Color, ECF9F8
	Gui, XPT99:+LastFound -Caption +AlwaysOnTop +ToolWindow -Border
	If (Alpha)
	{
		WinSet, TransColor, ECE9D8
	}
	Gui, XPT99:Show, x%X% y%Y% NoActivate
	SetTimer, DestroyGUI, -%TimeOn%
	return

	DestroyGUI:
	Gui, XPT99:Destroy
	return
}

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

HelpBox()
{
	Image2 = resources/help.png
	SplashGUI(Image2, "Center", "Center", 3000, true)
	return
}

Intro()
{
	Image = resources/splash.png
	SplashGUI(Image, "Center", "Center", 3000, true)
	SetIconContextMenu()
	return
}

AboutBox()
{
	Image3 = resources/about.png
	SplashGUI(Image3, "Center", "Center", 3000, true)
	return
}

SetIconContextMenu()
{
	Menu, Tray, Nostandard
	Menu, Tray, Icon, resources/SnapWindow.ico
	Menu, Tray, Tip, SnapWindow
	Menu, Tray, Add, Help
	Menu, Tray, Add, About
	Menu, Tray, Add, Exit
	;Menu, Tray, Default, About
	Menu, Tray, Click, 1 ;Remove this line to require double click
	Return
	Help:
		HelpBox()
		return
	About:
		AboutBox()
		return
	Exit:
		winHandle := WinExist(nWindow)
		WinSet, Style, ^0xC00000, ahk_id %winHandle% ; toggle title bar
		WinSet, AlwaysOnTop, Off, ahk_id %winHandle%
		WinSet, Transparent, 255, ahk_id %winHandle% ; transparecy
		ExitApp
}

GetTitlebarStatus()
{
	winHandle := WinExist(nWindow)
	WinGet, statusTB, Style, ahk_id %winHandle%
	if (statusTB & 0xC00000)
		return 0
	Else
		return 1
}

Intro()
nWindow := "Kodi"
if A_args[1]
{
	nWindow := A_args[1]
}
winHandle := WinExist(nWindow)
SetTitleMatchMode, 2
flag := 0
Loop, %window_%
{
	WinGetTitle,title,% "ahk_id" window_%A_Index%
	if (title = nWindow)
	{
		flag := 1
	}
}
if (flag = 0)
{
	Gosub ^+o
}
WinGetPos, X, Y, Width, Height, ahk_id %winHandle%
WinGetPos, StartX, StartY, StartWidth, StartHeight, ahk_id %winHandle%
StartAspectRatio := StartWidth / StartHeight
WinSet, Transparent, 255, ahk_id %winHandle% ; transparecy

^+u:: ;Topleft
	SetTitleMatchMode, 2
	winHandle2 := WinExist(SnapWindowTitle)
	WinGetTitle, tWindow2, ahk_id %winHandle2%
	IfWinExist %tWindow2%
	{
		Gui,Destroy
	}
	SetTitleMatchMode, 2
	winHandle3 := WinExist(SnapWindowTransparecyTitle)
	WinGetTitle, tWindow3, ahk_id %winHandle3%
	IfWinExist %tWindow3%
	{
		Gui,Destroy
	}
	SetTitleMatchMode, 2
	winHandle4 := WinExist(SnapWindowSizeTitle)
	WinGetTitle, tWindow4, ahk_id %winHandle4%
	IfWinExist %tWindow4%
	{
		Gui,Destroy
	}
	SetTitleMatchMode, 2
	WinActivate, ahk_id %winHandle%
	WinGetPos, X, Y, Width, Height, ahk_id %winHandle%
	WinGetTitle, tWindow, ahk_id %winHandle%
	monActive := GetMonitorIndexFromWindow(winHandle)
	IfWinExist %tWindow%
	{
		if (GetTitlebarStatus()=0)
		{
			WinSet, Style, ^0xC00000, ahk_id %winHandle% ; toggle title bar
		}
		WinSet, AlwaysOnTop, On, ahk_id %winHandle%
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
		if (monActive = 3)
		{
			Width1 := GetMonitorWorkArea("width",1)
			Height1 := GetMonitorWorkArea("height",1)
			Width2 := GetMonitorWorkArea("width",2)
			Height2 := GetMonitorWorkArea("height",2)
			Width3 := GetMonitorWorkArea("width",3)
			Height3 := GetMonitorWorkArea("height",3)
			WinMove, ahk_id %winHandle%,, -7+Width1+Width2, 0, Width, Height, ,
		}
	}
	return


^+j:: ;Bottomleft
	SetTitleMatchMode, 2
	winHandle2 := WinExist(SnapWindowTitle)
	WinGetTitle, tWindow2, ahk_id %winHandle2%
	IfWinExist %tWindow2%
	{
		Gui,Destroy
	}
	SetTitleMatchMode, 2
	winHandle3 := WinExist(SnapWindowTransparecyTitle)
	WinGetTitle, tWindow3, ahk_id %winHandle3%
	IfWinExist %tWindow3%
	{
		Gui,Destroy
	}
	SetTitleMatchMode, 2
	winHandle4 := WinExist(SnapWindowSizeTitle)
	WinGetTitle, tWindow4, ahk_id %winHandle4%
	IfWinExist %tWindow4%
	{
		Gui,Destroy
	}
	SetTitleMatchMode, 2
	WinActivate, ahk_id %winHandle%
	WinGetPos, X, Y, Width, Height, ahk_id %winHandle%
	WinGetTitle, tWindow, ahk_id %winHandle%
	monActive := GetMonitorIndexFromWindow(winHandle)
	IfWinExist %tWindow%
	{
		if (GetTitlebarStatus()=0)
		{
			WinSet, Style, ^0xC00000, ahk_id %winHandle% ; toggle title bar
		}
		WinSet, AlwaysOnTop, On, ahk_id %winHandle%
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
		if (monActive = 3)
		{
			Width1 := GetMonitorWorkArea("width",1)
			Height1 := GetMonitorWorkArea("height",1)
			Width2 := GetMonitorWorkArea("width",2)
			Height2 := GetMonitorWorkArea("height",2)
			Width3 := GetMonitorWorkArea("width",3)
			Height3 := GetMonitorWorkArea("height",3)
			WinMove, ahk_id %winHandle%,, -7+Width1+Width2, Height3-Height+7, Width, Height, ,
		}
	}
	return

^+i:: ;Topright
	SetTitleMatchMode, 2
	winHandle2 := WinExist(SnapWindowTitle)
	WinGetTitle, tWindow2, ahk_id %winHandle2%
	IfWinExist %tWindow2%
	{
		Gui,Destroy
	}
	SetTitleMatchMode, 2
	winHandle3 := WinExist(SnapWindowTransparecyTitle)
	WinGetTitle, tWindow3, ahk_id %winHandle3%
	IfWinExist %tWindow3%
	{
		Gui,Destroy
	}
	SetTitleMatchMode, 2
	winHandle4 := WinExist(SnapWindowSizeTitle)
	WinGetTitle, tWindow4, ahk_id %winHandle4%
	IfWinExist %tWindow4%
	{
		Gui,Destroy
	}
	SetTitleMatchMode, 2
	WinActivate, ahk_id %winHandle%
	WinGetPos, X, Y, Width, Height, ahk_id %winHandle%
	WinGetTitle, tWindow, ahk_id %winHandle%
	monActive := GetMonitorIndexFromWindow(winHandle)
	IfWinExist %tWindow%
	{
		if (GetTitlebarStatus()=0)
		{
			WinSet, Style, ^0xC00000, ahk_id %winHandle% ; toggle title bar
		}
		WinSet, AlwaysOnTop, On, ahk_id %winHandle%
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
		if (monActive = 3)
		{
			Width1 := GetMonitorWorkArea("width",1)
			Height1 := GetMonitorWorkArea("height",1)
			Width2 := GetMonitorWorkArea("width",2)
			Height2 := GetMonitorWorkArea("height",2)
			Width3 := GetMonitorWorkArea("width",3)
			Height3 := GetMonitorWorkArea("height",3)
			WinMove, ahk_id %winHandle%,, 7+Width1+Width2+Width3-Width, 0, Width, Height, ,
		}
	}
	return

^+k:: ;Bottomright
	SetTitleMatchMode, 2
	winHandle2 := WinExist(SnapWindowTitle)
	WinGetTitle, tWindow2, ahk_id %winHandle2%
	IfWinExist %tWindow2%
	{
		Gui,Destroy
	}
	SetTitleMatchMode, 2
	winHandle3 := WinExist(SnapWindowTransparecyTitle)
	WinGetTitle, tWindow3, ahk_id %winHandle3%
	IfWinExist %tWindow3%
	{
		Gui,Destroy
	}
	SetTitleMatchMode, 2
	winHandle4 := WinExist(SnapWindowSizeTitle)
	WinGetTitle, tWindow4, ahk_id %winHandle4%
	IfWinExist %tWindow4%
	{
		Gui,Destroy
	}
	SetTitleMatchMode, 2
	WinActivate, ahk_id %winHandle%
	WinGetPos, X, Y, Width, Height, ahk_id %winHandle%
	WinGetTitle, tWindow, ahk_id %winHandle%
	monActive := GetMonitorIndexFromWindow(winHandle)
	IfWinExist %tWindow%
	{
		if (GetTitlebarStatus()=0)
		{
			WinSet, Style, ^0xC00000, ahk_id %winHandle% ; toggle title bar
		}
		WinSet, AlwaysOnTop, On, ahk_id %winHandle%
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
		if (monActive = 3)
		{
			Width1 := GetMonitorWorkArea("width",1)
			Height1 := GetMonitorWorkArea("height",1)
			Width2 := GetMonitorWorkArea("width",2)
			Height2 := GetMonitorWorkArea("height",2)
			Width3 := GetMonitorWorkArea("width",3)
			Height3 := GetMonitorWorkArea("height",3)
			WinMove, ahk_id %winHandle%,, 7+Width1+Width2+Width3-Width, Height3-Height+7, Width, Height, ,
		}
	}
	return

^+t:: ;Transparecy
	SetTitleMatchMode, 2
	winHandle2 := WinExist(SnapWindowTitle)
	WinGetTitle, tWindow2, ahk_id %winHandle2%
	IfWinExist %tWindow2%
	{
		Gui,Destroy
	}
	SetTitleMatchMode, 2
	winHandle3 := WinExist(SnapWindowTransparecyTitle)
	WinGetTitle, tWindow3, ahk_id %winHandle3%
	IfWinExist %tWindow3%
	{
		Gui,Destroy
	}
	SetTitleMatchMode, 2
	winHandle4 := WinExist(SnapWindowSizeTitle)
	WinGetTitle, tWindow4, ahk_id %winHandle4%
	IfWinExist %tWindow4%
	{
		Gui,Destroy
	}
	transparecy := (TransparecyLevel/255)*100
	Gui, Add, Slider, w500 vSlider gMySlider2 ToolTip, %transparecy%
	Gui, Add, Button, Default w50 gMySlider1, OK
	Gui, Show,, %SnapWindowTransparecyTitle%
	return

	MySlider1:
		Gui,Submit
		transparecy := (Slider)*255/100
		WinSet, Transparent, %transparecy%, ahk_id %winHandle% ; transparecy
		TransparecyLevel := transparecy
		Gui,Destroy
		return
	MySlider2:
		transparecy := (Slider)*255/100
		WinSet, Transparent, %transparecy%, ahk_id %winHandle% ; transparecy
		TransparecyLevel := transparecy
		return
	2GuiClose:
		Gui,Destroy
		return
	return
^+o:: ;ChangeTargetWindow
	SetTitleMatchMode, 2
	winHandle2 := WinExist(SnapWindowTitle)
	WinGetTitle, tWindow2, ahk_id %winHandle2%
	IfWinExist %tWindow2%
	{
		Gui,Destroy
	}
	SetTitleMatchMode, 2
	winHandle3 := WinExist(SnapWindowTransparecyTitle)
	WinGetTitle, tWindow3, ahk_id %winHandle3%
	IfWinExist %tWindow3%
	{
		Gui,Destroy
	}
	SetTitleMatchMode, 2
	winHandle4 := WinExist(SnapWindowSizeTitle)
	WinGetTitle, tWindow4, ahk_id %winHandle4%
	IfWinExist %tWindow4%
	{
		Gui,Destroy
	}
	winlist:=[]
	WinGet, Win, List
	Loop, %window_%
	{
		ID := Win%A_Index%
 		WinGetTitle, Title, % "ahk_id " ID
 		IfEqual, Title,, Continue
		if (Title != "")
		{
			winlist.=title ? title "|" : ""
		}
	}
	Gui, Add, ListBox, x0 y0 w500 h200 vtitle gWinTitle,%winlist%
	Gui, Show,, %SnapWindowTitle%
	return

	WinTitle:
		Gui,Submit
		if (title != nWindow)
		{
			TransparecyLevel := 255
			WinSet, Transparent, 255, ahk_id %winHandle% ; transparecy
			WinGetPos, X, Y, Width, Height, ahk_id %winHandle%
		}
		nWindow := title
		winHandle := WinExist(nWindow)
		WinGetPos, X, Y, Width, Height, ahk_id %winHandle%
		Gui,Destroy
		return
	GuiClose:
		Gui,Destroy
		return
^+s:: ;ChangeSize
	SetTitleMatchMode, 2
	winHandle2 := WinExist(SnapWindowTitle)
	WinGetTitle, tWindow2, ahk_id %winHandle2%
	IfWinExist %tWindow2%
	{
		Gui,Destroy
	}
	SetTitleMatchMode, 2
	winHandle3 := WinExist(SnapWindowTransparecyTitle)
	WinGetTitle, tWindow3, ahk_id %winHandle3%
	IfWinExist %tWindow3%
	{
		Gui,Destroy
	}
	SetTitleMatchMode, 2
	winHandle4 := WinExist(SnapWindowSizeTitle)
	WinGetTitle, tWindow4, ahk_id %winHandle4%
	IfWinExist %tWindow4%
	{
		Gui,Destroy
	}
	SetTitleMatchMode, 2
	WinActivate, ahk_id %winHandle%
	WinGetPos, X, Y, Width, Height, ahk_id %winHandle%
	WinGetTitle, tWindow, ahk_id %winHandle%
	monActive := GetMonitorIndexFromWindow(winHandle)
	IfWinExist %tWindow%
	{
		if (monActive = 1)
		{
			Width1 := GetMonitorWorkArea("width",1)
			Height1 := GetMonitorWorkArea("height",1)
			size := Width / Width1 * 100
		}
		if (monActive = 2)
		{
			Width1 := GetMonitorWorkArea("width",1)
			Height1 := GetMonitorWorkArea("height",1)
			Width2 := GetMonitorWorkArea("width",2)
			Height2 := GetMonitorWorkArea("height",2)
			size := Width / Width2 * 100
		}
		if (monActive = 3)
		{
			Width1 := GetMonitorWorkArea("width",1)
			Height1 := GetMonitorWorkArea("height",1)
			Width2 := GetMonitorWorkArea("width",2)
			Height2 := GetMonitorWorkArea("height",2)
			Width3 := GetMonitorWorkArea("width",3)
			Height3 := GetMonitorWorkArea("height",3)
			size := Width / Width3 * 100
		}
	}
	Gui, Add, Slider, w500 vSlider gMySlider4 ToolTip, %size%
	Gui, Add, Button, w50 gMySlider5, Reset
	Gui, Add, Button, Default w50 gMySlider3, Ok
	Gui, Show,, %SnapWindowSizeTitle%
	return
	MySlider3:
		Gui,Submit
		if (monActive = 1)
		{
			sizeH := ( Slider * Width1 / 100 / StartAspectRatio )
		}
		if (monActive = 2)
		{
			sizeH := ( Slider * Width2 / 100 / StartAspectRatio )
		}
		if (monActive = 3)
		{
			sizeH := ( Slider * Width3 / 100 / StartAspectRatio )
		}
		sizeW := ( sizeH * StartAspectRatio )
		if (monActive = 1)
		{
			Width1 := GetMonitorWorkArea("width",1)
			Height1 := GetMonitorWorkArea("height",1)
			WinMove, ahk_id %winHandle%,, -7, 0, sizeW, sizeH, ,
		}
		if (monActive = 2)
		{
			Width1 := GetMonitorWorkArea("width",1)
			Height1 := GetMonitorWorkArea("height",1)
			Width2 := GetMonitorWorkArea("width",2)
			Height2 := GetMonitorWorkArea("height",2)
			WinMove, ahk_id %winHandle%,, -7+Width1, 0, sizeW, sizeH, ,
		}
		if (monActive = 3)
		{
			Width1 := GetMonitorWorkArea("width",1)
			Height1 := GetMonitorWorkArea("height",1)
			Width2 := GetMonitorWorkArea("width",2)
			Height2 := GetMonitorWorkArea("height",2)
			Width3 := GetMonitorWorkArea("width",3)
			Height3 := GetMonitorWorkArea("height",3)
			WinMove, ahk_id %winHandle%,, -7+Width1+Width2, 0, sizeW, sizeH, ,
		}
		WinGetPos, X, Y, Width, Height, ahk_id %winHandle%
		Gui,Destroy
		return
	MySlider4:
		if (monActive = 1)
		{
			sizeH := ( Slider * Width1 / 100 / StartAspectRatio )
		}
		if (monActive = 2)
		{
			sizeH := ( Slider * Width2 / 100 / StartAspectRatio )
		}
		if (monActive = 3)
		{
			sizeH := ( Slider * Width3 / 100 / StartAspectRatio )
		}
		sizeW := ( sizeH * StartAspectRatio )
		if (monActive = 1)
		{
			Width1 := GetMonitorWorkArea("width",1)
			Height1 := GetMonitorWorkArea("height",1)
			WinMove, ahk_id %winHandle%,, -7, 0, sizeW, sizeH, ,
		}
		if (monActive = 2)
		{
			Width1 := GetMonitorWorkArea("width",1)
			Height1 := GetMonitorWorkArea("height",1)
			Width2 := GetMonitorWorkArea("width",2)
			Height2 := GetMonitorWorkArea("height",2)
			WinMove, ahk_id %winHandle%,, -7+Width1, 0, sizeW, sizeH, ,
		}
		if (monActive = 3)
		{
			Width1 := GetMonitorWorkArea("width",1)
			Height1 := GetMonitorWorkArea("height",1)
			Width2 := GetMonitorWorkArea("width",2)
			Height2 := GetMonitorWorkArea("height",2)
			Width3 := GetMonitorWorkArea("width",3)
			Height3 := GetMonitorWorkArea("height",3)
			WinMove, ahk_id %winHandle%,, -7+Width1+Width2, 0, sizeW, sizeH, ,
		}
		return
	MySlider5:
		Gui,Submit
		WinMove, ahk_id %winHandle%,, X, Y, Width, Height, ,
		GuiControl, ,Slider, %size%
		Gui,Destroy
		return
	3GuiClose:
		Gui,Destroy
		return
^+f:: ;ToggleFullscreen
	if (Fullscreen = false)
	{
		SetTitleMatchMode, 2
		WinActivate, ahk_id %winHandle%
		WinGetPos, X, Y, Width, Height, ahk_id %winHandle%
		WinGetTitle, tWindow, ahk_id %winHandle%
		WinMaximize, ahk_id %winHandle%
		Fullscreen := true
	}
	Else
	{
		winHandle := WinExist(nWindow)
		WinRestore, ahk_id %winHandle%
		Fullscreen := false
	}
	return
^+h:: ;Help
	HelpBox()
	return

^+x:: ;Exit
	winHandle := WinExist(nWindow)
	WinSet, Style, ^0xC00000, ahk_id %winHandle% ; toggle title bar
	WinSet, AlwaysOnTop, Off, ahk_id %winHandle%
	WinSet, Transparent, 255, ahk_id %winHandle% ; transparecy
	ExitApp