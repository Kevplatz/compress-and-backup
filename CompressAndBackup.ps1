function Get-location {
    Add-Type -AssemblyName System.Windows.Forms

    Push-Location
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
        ShowNewFolderButton = $true
        Description = 'Select a folder'
        RootFolder = 'MyComputer'
    }

    if($FolderBrowser.ShowDialog() -ne "ok") {
        exit
    }
    Pop-Location

    $FolderSource = $FolderBrowser.SelectedPath
    $FolderSource
}

function Get-Destination {
    Add-Type -AssemblyName System.Windows.Forms

    Push-Location
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
        ShowNewFolderButton = $True
        Description = 'Select a Destination'
        RootFolder = 'MyComputer'
    }   

    if($FolderBrowser.ShowDialog() -ne "OK") {
        exit
    }
    Pop-Location

    $FolderDestination = $FolderBrowser.SelectedPath
    $FolderDestination
}



function Compress-File {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()] 
        [string]$Path,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$DestinationPath
    )
    if (-not (Test-Path "$($env:ProgramFiles)\7-Zip\7z.exe")){
        Write-error "$($env:ProgramFiles)\7-Zip\7z.exe needed" -ErrorAction Stop
    }

    if(-not ($DestinationPath.EndsWith('.7z'))){
        $DestinationPath = $DestinationPath + '.7z'
    }

    if (-not(Test-path -Path $Path)) {
        Write-Error "Path $Path does not exist!" -ErrorAction Stop
    }
     
    $7ZipPath = "$($env:ProgramFiles)\7-Zip\7z.exe"
    Set-Alias Compress7-Zip $7ZipPath

    Compress7-Zip a -mx=9 $DestinationPath $Path
}

function Get-FileName {
    $Date = (Get-Date).ToString("yyyyMMdd")
    $FileName = "$date.7z"
    $FileName
}

$path = "C:\Temp\Subfolder\Temp.7z"
#$path = "C:\Temp\Subfolder\Temp"


Split-Path -Path $path -Leaf
exit
Test-Path -Path (Split-Path -Path $path -Parent)

exit
$path = Get-location
$DestinationFolderPath = Get-Destination
$FileName = Get-FileName
$DestinationPath = $DestinationFolderPath + '\' + $FileName
Compress-File -Path $path -DestinationPath $DestinationPath #$DestinationPath