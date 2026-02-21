# PI-PinBall 自动测试脚本
# 使用方法: 运行此脚本启动游戏并进行自动化测试

param(
    [string]$GodotPath = "D:\game_development\godot\Godot_v4.5.1-stable_win64.exe",
    [string]$ProjectPath = "C:\Users\panju\.openclaw\workspace\pi-pin-ball"
)

# 启动游戏
Write-Host "启动游戏..."
$godotProcess = Start-Process -FilePath $GodotPath -ArgumentList "--path", $ProjectPath -PassThru

# 等待游戏启动
Start-Sleep -Seconds 5

# 获取游戏窗口句柄
$godotWindow = $godotProcess.MainWindowHandle

if ($godotWindow -eq [IntPtr]::Zero) {
    Write-Host "无法获取游戏窗口"
    exit 1
}

Write-Host "游戏窗口已找到: $godotWindow"

# 激活窗口
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
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

# 激活窗口
[Win32]::SetForegroundWindow($godotWindow)
Start-Sleep -Milliseconds 500

# 测试1: 按空格开始游戏并发射球
Write-Host "测试1: 发射球 (按空格)..."
[Win32]::keybd_event([Win32]::VK_SPACE, 0, 0, [UIntPtr]::Zero)
Start-Sleep -Milliseconds 100
[Win32]::keybd_event([Win32]::VK_SPACE, 0, [Win32]::KEYEVENTF_KEYUP, [UIntPtr]::Zero)

# 等待球发射
Start-Sleep -Seconds 2

# 截取发射后的屏幕
Write-Host "截图: 发射测试"
# 使用剪贴板截图 (需要手动)
# 这里只是演示思路

# 测试2: 按A键控制左挡板
Write-Host "测试2: 左挡板 (按A)..."
[Win32]::keybd_event([Win32]::VK_LEFT, 0, 0, [UIntPtr]::Zero)
Start-Sleep -Milliseconds 100
[Win32]::keybd_event([Win32]::VK_LEFT, 0, [Win32]::KEYEVENTF_KEYUP, [UIntPtr]::Zero)

Start-Sleep -Seconds 2

# 测试3: 按D键控制右挡板
Write-Host "测试3: 右挡板 (按D)..."
[Win32]::keybd_event([Win32]::VK_RIGHT, 0, 0, [UIntPtr]::Zero)
Start-Sleep -Milliseconds 100
[Win32]::keybd_event([Win32]::VK_RIGHT, 0, [Win32]::KEYEVENTF_KEYUP, [UIntPtr]::Zero)

Start-Sleep -Seconds 3

# 关闭游戏
Write-Host "关闭游戏..."
Stop-Process -Id $godotProcess.Id -Force

Write-Host "测试完成!"
