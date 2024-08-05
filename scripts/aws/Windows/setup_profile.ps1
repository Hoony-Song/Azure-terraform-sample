$content = @"
param (
    [string]$Command,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Args
)

function Find-From-Main {
    param (
        [string]$FileToFind
    )
    $currentDir = [System.IO.DirectoryInfo]::new((Get-Location).Path)
    $parentOfMain = $null

    # Find main directory
    while ($currentDir -ne $null) {
        # Write-Host "Checking Directory: $($currentDir.FullName)"
        if ($currentDir.Name -eq "main") {
            $parentOfMain = $currentDir.Parent
            break
        }
        $currentDir = $currentDir.Parent
    }

    # Search in the parent of main directory
    if ($parentOfMain -ne $null) {
        # Write-Host "Searching in parent of main: $($parentOfMain.FullName)"
        $found = Get-ChildItem -Path $parentOfMain.FullName -File -Filter $FileToFind -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($found) {
            # Write-Host "wrapper running: $($found.FullName)"
            return $found.FullName
        }
    }

    Write-Host "$($FileToFind) File not found"
    return $null
}
function terraform {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Args
    )

    # search file name
    $filename = "win_wrapper.ps1"

    # file search 
    $wrapperPath = Find-From-Main -FileToFind $filename

    # file exists
    if (($wrapperPath -ne $null) -and (Test-Path $wrapperPath)) {
        Write-Host "Found and running win_wrapper.ps1"
        & $wrapperPath @Args
    } else {
        Write-Host "Default terraform CLI is running"
        & "C:\terraform\terraform.exe" @Args
    }
}
"@

$profilePath = $PROFILE
if (!(Get-Content -Path $profilePath | Select-String -Pattern 'function terraform')) {
    Add-Content -Path $profilePath -Value $content
    Write-Host "Content added to profile"
} else {
    Write-Host "Content already exists in profile"
}
