<# 
Nødvendig før bruk:
7-Zip

Beskrivelse:
Programmet komprimerer alle filene i et selv-valgt lokasjon,  
deretter flyttes den nå komprimerte filen til et annet selv-valgt lokasjon.

Programmet bruker 7-Zip til komprimering av filer.

Programmet kan komprimere alle fil typer.

Fil/Mappe lokasjonene blir valgt med et enkelt GUI.

Bruker manual
1. Kjør program.
2. Velg lokasjonen til filen/filene som skal komprimeres.
3. Velg destinasjonen som den komprimerte filen skal flyttes til.
#>

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

$path = Get-location
$DestinationFolderPath = Get-Destination
$FileName = Get-FileName
$DestinationPath = $DestinationFolderPath + '\' + $FileName
Compress-File -Path $path -DestinationPath $DestinationPath 