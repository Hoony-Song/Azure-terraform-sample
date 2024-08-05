param (
    [string]$Command,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Args
)
function Find-From {
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
            Write-Host "found dir $($FileToFind): $($found.FullName)"
            return $found.FullName
        }
    }

    Write-Host "File not found"
    return $null
}
$terraformExe = "C:\terraform\terraform.exe"
$workspace = & $terraformExe workspace show
$BACKEND_CONF = "backend.conf"
$VAR_FILE = "${workspace}.tfvars"
$terraformPath = "terraform.exe"
$backendConfigPath = Find-From -FileToFind $BACKEND_CONF
$varFilePath = Find-From -FileToFind $VAR_FILE
switch ($Command) {
    "init" {
        # init 명령어에 -backend-config 옵션 추가
        if ($backendConfigPath -and (Test-Path $backendConfigPath)) {
            Write-Host "Executing: $terraformPath init -backend-config=$backendConfigPath $Args"
            & $terraformPath init -backend-config="$backendConfigPath" @Args
        } else {
            Write-Host "Executing: $terraformPath init $Args"
            & $terraformPath init @Args
        }
    }
    "plan" {
        # plan 명령어에 -var-file 옵션 추가
        if ($varFilePath -and (Test-Path $varFilePath)) {
            Write-Host "Executing: $terraformPath plan -var-file=$varFilePath $Args"
            & $terraformPath plan -var-file="$varFilePath" @Args
        } else {
            Write-Host "Executing: $terraformPath plan $Args"
            & $terraformPath plan @Args
        }
    }
    "apply" {
        # apply 명령어에 -var-file 옵션 추가
        if ($varFilePath -and (Test-Path $varFilePath)) {
            Write-Host "Executing: $terraformPath apply -var-file=$varFilePath $Args"
            & $terraformPath apply -var-file="$varFilePath" @Args
        } else {
            Write-Host "Executing: $terraformPath apply $Args"
            & $terraformPath apply @Args
        }
    }
    "destroy" {
        # destroy 명령어에 -var-file 옵션 추가
        if ($varFilePath -and (Test-Path $varFilePath)) {
            Write-Host "Executing: $terraformPath destroy -var-file=$varFilePath $Args"
            & $terraformPath destroy -var-file="$varFilePath" @Args
        } else {
            Write-Host "Executing: $terraformPath destroy $Args"
            & $terraformPath destroy @Args
        }
    }
    "refresh" {
        # refresh 명령어에 -var-file 옵션 추가
        if ($varFilePath -and (Test-Path $varFilePath)) {
            Write-Host "Executing: $terraformPath refresh -var-file=$varFilePath $Args"
            & $terraformPath refresh -var-file="$varFilePath" @Args
        } else {
            Write-Host "Executing: $terraformPath refresh $Args"
            & $terraformPath refresh @Args
        }
    }
    "import" {
        # import 명령어에 -var-file 옵션 추가
        if ($varFilePath -and (Test-Path $varFilePath)) {
            Write-Host "Executing: $terraformPath import -var-file=$varFilePath $Args"
            & $terraformPath import -var-file="$varFilePath" @Args
        } else {
            Write-Host "Executing: $terraformPath import $Args"
            & $terraformPath import @Args
        }
    }
    default {
        # 기타 명령어
        Write-Host "Executing: $terraformPath $Command $Args"
        & $terraformPath $Command @Args
    }
}