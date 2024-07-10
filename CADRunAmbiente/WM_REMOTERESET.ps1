#Sample:
#cmd /c powershell.exe -File "Z:\CAD\CADServerV2\WM_REMOTECLOSE.ps1"
#Obrigatorio                 -AppNameNoExt "CADRunAmbiente"

# Get the window class and caption from the command line
[CmdletBinding()]
param (
#    [Parameter(Mandatory=$true)]
#    [string]$windowClass,

    [Parameter(Mandatory=$true)]
    [string]$AppNameNoExt
)

Write-Host "Aguarde ..."
# Import the user32.dll library
Add-Type -Name WindowMessage -Namespace Win32 -MemberDefinition @"
[DllImport("user32.dll", CharSet = CharSet.Auto)]
public static extern IntPtr SendMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);
"@

Write-Host "Localizando Processo ..."
# Get the handle to the window
$hwnd = (Get-Process | Where-Object {$_.ProcessName -match $AppNameNoExt}).MainWindowHandle

# Send the message to the window
if ($hwnd -ne $null) {
        Write-Host "Processo Localizado! Enviando Mensagem ..."
        [Win32.WindowMessage]::SendMessage($hwnd, 0x0402, 0, 0)
} else {
        Write-Host "Processo não localizado"
}
