# Send-Keys.ps1 - Send keys to Godot window
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class KeySim {
    [DllImport("user32.dll")]
    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
    [DllImport("user32.dll")]
    public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
    
    public const byte VK_SPACE = 0x20;
    public const byte VK_LEFT = 0x41;  // A key
    public const byte VK_RIGHT = 0x44;  // D key
    public const uint KEYEVENTF_KEYUP = 0x0002;
}
"@

# Find Godot window with (DEBUG) in title
$hwnd = [KeySim]::FindWindow($null, "PI-PinBall (DEBUG)")
if ($hwnd -eq [IntPtr]::Zero) {
    $hwnd = [KeySim]::FindWindow($null, "Godot Engine")
}

if ($hwnd -eq [IntPtr]::Zero) {
    Write-Host "Window not found"
    exit 1
}

Write-Host "Found window: $hwnd"
[KeySim]::SetForegroundWindow($hwnd)
Start-Sleep -Milliseconds 500

# Send Space key (launch ball)
Write-Host "Sending Space..."
[KeySim]::keybd_event([KeySim]::VK_SPACE, 0, 0, [UIntPtr]::Zero)
Start-Sleep -Milliseconds 100
[KeySim]::keybd_event([KeySim]::VK_SPACE, 0, [KeySim]::KEYEVENTF_KEYUP, [UIntPtr]::Zero)

Start-Sleep -Seconds 3

# Send A key (left flipper)
Write-Host "Sending A..."
[KeySim]::keybd_event([KeySim]::VK_LEFT, 0, 0, [UIntPtr]::Zero)
Start-Sleep -Milliseconds 100
[KeySim]::keybd_event([KeySim]::VK_LEFT, 0, [KeySim]::KEYEVENTF_KEYUP, [UIntPtr]::Zero)

Start-Sleep -Seconds 2

# Send D key (right flipper)
Write-Host "Sending D..."
[KeySim]::keybd_event([KeySim]::VK_RIGHT, 0, 0, [UIntPtr]::Zero)
Start-Sleep -Milliseconds 100
[KeySim]::keybd_event([KeySim]::VK_RIGHT, 0, [KeySim]::KEYEVENTF_KEYUP, [UIntPtr]::Zero)

Write-Host "Keys sent!"
