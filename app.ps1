param([switch]$Shortcut)
$ErrorActionPreference = 'Stop'
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$index = Join-Path $dir 'index.html'
$cands = @(
  "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
  "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
  "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
)
$browser = $cands | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $browser) {
  Write-Host 'Edge or Chrome was not found. Please install Microsoft Edge or Google Chrome.'
  Read-Host 'Press Enter to close'
  exit 1
}
$url = ([Uri]$index).AbsoluteUri
$profileDir = Join-Path $env:LOCALAPPDATA 'DafterQitaaGhiyar'
$argLine = "--app=`"$url`" --user-data-dir=`"$profileDir`" --window-size=1280,800 --disable-features=Translate"
if ($Shortcut) {
  $ws = New-Object -ComObject WScript.Shell
  $desktop = [Environment]::GetFolderPath('Desktop')
  $lnk = $ws.CreateShortcut((Join-Path $desktop 'دفتر قطع الغيار.lnk'))
  $lnk.TargetPath = $browser
  $lnk.Arguments = $argLine
  $lnk.IconLocation = (Join-Path $dir 'shop-icon.ico')
  $lnk.WorkingDirectory = $dir
  $lnk.Save()
  Write-Host 'Done. A shortcut was created on your Desktop.'
  Read-Host 'Press Enter to close'
} else {
  Start-Process -FilePath $browser -ArgumentList $argLine
}
