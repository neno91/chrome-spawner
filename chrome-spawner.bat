@echo off
setlocal EnableDelayedExpansion

set /p URL=Enter address: 
set /p COUNT=How many browsers to open? 

for /L %%i in (1,1,%COUNT%) do (
    set "PROFILE_DIR=%TEMP%\chrome_profile_%%i_%TIME:~-5,2%%TIME:~-2%!RANDOM!"
    start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" --new-window --user-data-dir="!PROFILE_DIR!" --no-first-run --no-default-browser-check --disable-search-engine-choice-screen "%URL%"
)

echo Waiting for browsers to start...
timeout /t 3 /nobreak >nul

set "PS_SCRIPT=%TEMP%\arrange_%RANDOM%.ps1"
(
echo Add-Type @"
echo using System; using System.Runtime.InteropServices;
echo public class Win32 {
echo     [DllImport("user32.dll"^)] public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int W, int H, bool repaint^);
echo     [DllImport("user32.dll"^)] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow^);
echo }
echo "@
echo Add-Type -AssemblyName System.Windows.Forms
echo $screen = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
echo $n = %COUNT%
echo $cols = [math]::Ceiling([math]::Sqrt($n^)^)
echo $rows = [math]::Ceiling($n / $cols^)
echo $w = [int]($screen.Width / $cols^)
echo $h = [int]($screen.Height / $rows^)
echo $procs = Get-Process chrome -ErrorAction SilentlyContinue ^|
echo     Where-Object { $_.MainWindowHandle -ne 0 } ^|
echo     Select-Object -Last $n
echo $i = 0
echo foreach ($p in $procs^) {
echo     $col = $i %% $cols
echo     $row = [math]::Floor($i / $cols^)
echo     $x = $screen.Left + $col * $w
echo     $y = $screen.Top + $row * $h
echo     [Win32]::ShowWindow($p.MainWindowHandle, 9^) ^| Out-Null
echo     [Win32]::MoveWindow($p.MainWindowHandle, $x, $y, $w, $h, $true^) ^| Out-Null
echo     $i++
echo }
) > "%PS_SCRIPT%"

powershell -ExecutionPolicy Bypass -File "%PS_SCRIPT%"
del "%PS_SCRIPT%"

echo Done! Arranged %COUNT% browsers in a grid.
