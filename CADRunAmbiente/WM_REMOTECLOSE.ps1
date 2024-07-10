#Sample:
#cmd /c powershell.exe -File "Z:\CAD\CADServerV2\WM_REMOTECLOSE.ps1"
#Obrigatorio!                -AppNameNoExt "CADRunAmbiente"
#Opcionla!                   -ReopenPath "Z:\CAD\CADServerV2\Win32\Release\CADRunAmbiente\CADRunAmbiente.exe"
#Opcional!                   -ReopenParams "-ambiente {f11ff428-5ae9-4841-8ced-01e8580c13b3}"

# Get the window class and caption from the command line
[CmdletBinding()]
param (
#    [Parameter(Mandatory=$true)]
#    [string]$windowClass,
    
    [Parameter(Mandatory=$true)]
    [string]$AppNameNoExt,

    [Parameter(Mandatory=$false)]
    [string]$ReopenPath = $null,

    [Parameter(Mandatory=$false)]
    [string]$ReopenParams = $null
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
        [Win32.WindowMessage]::SendMessage($hwnd, 0x0401, 0, 0)
} else {
        Write-Host "Processo não localizado"
}

# Check if the ReopenPath parameter is provided and if so, open the program
if ($ReopenPath -ne "") {
		Write-Host "Reabrindo Processo ..."
        if ($hwnd -ne $null) {
                # Pause the script execution for 5 seconds
                Start-Sleep -Seconds 2
        }
        Start-Process -FilePath $ReopenPath $ReopenParams
        Write-Host "Processo Reaberto!"
}