@echo off

REM 

set g_Terraform_version=1.8.0
REM set g_Azure_version=2.51.0 


setlocal

echo.
echo ===============================
echo  t  e  r  r  a  f  o  r  m
echo ===============================
echo terraform installation...
REM 다운로드 URL 설정
set DOWNLOAD_URL=https://releases.hashicorp.com/terraform/%g_Terraform_version%/terraform_%g_Terraform_version%_windows_386.zip
set DOWNLOAD_FILE=%TEMP%\terraform_%g_Terraform_version%_windows_386.zip

REM 타겟 디렉토리 및 파일 설정
set TARGET_DIR=C:\terraform
set TARGET_FILE=%TARGET_DIR%\terraform.exe

REM 타겟 디렉토리가 없으면 생성
if not exist "%TARGET_DIR%" (
    echo Creating target directory...
    mkdir %TARGET_DIR%
)

REM 타겟 파일이 이미 존재하는지 확인
if exist %TARGET_FILE% (
    echo already installed
    powershell -Command "terraform -v"
    goto terraform_install_end
) else (
    echo Downloading file from %DOWNLOAD_URL%...
    powershell -Command "Invoke-WebRequest -Uri %DOWNLOAD_URL% -OutFile %DOWNLOAD_FILE%"
    
    echo unzip file...
    powershell -Command "Expand-Archive -Path %DOWNLOAD_FILE% -DestinationPath %TARGET_DIR%"
    
    echo Move to target directory...
    REM move %TARGET_DIR%\extracted_folder_name\terraform.exe %TARGET_DIR%

    echo Environment variables Setting...
    powershell -Command " $targetDir = '%TARGET_DIR%'; $currentPath = [System.Environment]::GetEnvironmentVariable('Path', 'Machine'); if ($currentPath -notlike '*'+$targetDir+'*') { [Environment]::SetEnvironmentVariable('Path', $currentPath + ';' + $targetDir, 'Machine'); Write-Output 'Path updated successfully.'; } else { Write-Output 'Path already contains the target directory.'; } "

    del %DOWNLOAD_FILE%
    
)
:terraform_install_end
endlocal


setlocal
echo.
echo ==========================
echo A  Z  U  R  E  -  C  L  I  
echo ==========================
echo Azure installation...
REM 설치할 프로그램 이름 설정
REM set DOWNLOAD_URL=https://azcliprod.blob.core.windows.net/msi/azure-cli-%g_Azure_version%-x64.msi
set DOWNLOAD_URL=https://aka.ms/installazurecliwindowsx64
set DOWNLOAD_FILE=%TEMP%\azure-cli.msi

set PROGRAM_NAME="Microsoft AzureCLI (64-bit)"
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Azure CLI" >NUL 2>&1
if %ERRORLEVEL% equ 0 (
    echo %PROGRAM_NAME% is already installed. Exiting...    
    powershell -Command "az -v"
    goto Azur_install_end
)

REM MSI 파일 다운로드
echo Downloading %DOWNLOAD_URL%...
powershell -Command "Invoke-WebRequest -Uri %DOWNLOAD_URL% -OutFile %DOWNLOAD_FILE%"
if %ERRORLEVEL% neq 0 (
    echo Error downloading the MSI file. Exiting...
    goto Azur_install_end
)

REM MSI 파일 설치
echo Installing %DOWNLOAD_FILE%...
msiexec /i "%DOWNLOAD_FILE%" /qn /norestart /passive
if %ERRORLEVEL% neq 0 (
    echo Error: Installation failed with exit code %ERRORLEVEL%.
    goto Azur_install_end
)

REM MSI 파일 삭제
echo Deleting the MSI file...
del %DOWNLOAD_FILE%
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to delete the MSI file.
    goto Azur_install_end
)

echo Installation completed successfully.

:Azur_install_end

endlocal

setlocal

REM PowerShell 프로필 파일 경로 확인
for /f "tokens=*" %%i in ('powershell -command "echo $PROFILE"') do set PROFILE_PATH=%%i

REM PowerShell 프로필 파일 경로 출력
echo PowerShell profile path: %PROFILE_PATH%

REM PowerShell 프로필 파일이 없으면 생성
powershell -command "if (!(Test-Path -Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE -Force }"

REM powerShell ExecutionPolicy 변경
powershell.exe -Command "Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force"

REM PowerShell 스크립트의 전체 경로 계산
set SCRIPT_PATH=%~dp0setup_profile.ps1

REM PowerShell 스크립트를 실행하여 프로필 파일 수정
powershell -File "%SCRIPT_PATH%"

endlocal
pause