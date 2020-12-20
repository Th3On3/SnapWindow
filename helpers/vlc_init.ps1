<#
* Filename: vlc_init.ps1
*
* Copyright (c) 2020 Fernando Manuel Fernandes Rodrigues <fmfrodrigues@gmail.com>
#>
$found = 0
try {
    Get-process VLC -ErrorAction Stop
    Stop-Process -Name VLC
    Wait-Process -Name VLC
    $found = 1
}
catch [System.Management.Automation.ActionPreferenceStopException] {
    try {
        Get-process VLC.universal -ErrorAction Stop
        Stop-Process -Name VLC.universal
        Wait-Process -Name VLC.universal
        $found = 1
    }
    catch [System.Management.Automation.ActionPreferenceStopException] {
        $found = 0
    }
}


$path = $null
$path = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, InstallLocation | Where-Object DisplayName -Like '*VLC*').InstallLocation

if ($path -eq $null) {
    $path = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, InstallLocation | Where-Object DisplayName -Like '*VLC.Universal*').InstallLocation
}

if ($path -eq $null) {
    $path = (Get-CimInstance -ClassName Win32_Product | Where-Object Name -Like "*vlc*").InstallLocation
}

if ($path -eq $null) {
    $path = (Get-CimInstance -ClassName Win32_Product | Where-Object Name -Like "*VLC.Universal*").InstallLocation
}

$VLCAPP = Get-AppxPackage -Name "VideoLAN.VLC" | Select-Object -ExpandProperty PackageFamilyName -First 1

try {
    Start-Process -FilePath $path\vlc.exe -ArgumentList '--extraintf rc', '--rc-host localhost:8889', '--rc-quiet', '--qt-minimal-view', '--no-qt-video-autoresize'
}
catch {
    try {
        Start-Process -FilePath $path\VideoLAN\VLC\vlc.exe -ArgumentList '--extraintf rc', '--rc-host localhost:8889', '--rc-quiet', '--qt-minimal-view', '--no-qt-video-autoresize'
    }
    catch {
        Start-Process -FilePath shell:appsFolder\$VLCAPP!App -ArgumentList '--extraintf rc', '--rc-host localhost:8889', '--rc-quiet', '--qt-minimal-view', '--no-qt-video-autoresize'
    }
}