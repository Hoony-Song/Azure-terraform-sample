# terraform 커맨드 입력시 global.tfvars 지정 방법 
```
terraform plan -var-file="../global.tfvars"
terraform apply -var-file="../global.tfvars"
terraform destroy -var-file="../global.tfvars"
```

# terraform init 시  backend.conf 지정 방법 
```
terraform init -backend-config="../backend.conf"
```

# mac_running 스크립트
> MacOS(M1 ~ ) 에서 mac_running.sh 실행 하시면 terraform 및 azure-cli 가 설치 됩니다. 기존의 terraform init -backend-config="../backend.conf" 및 apply destroy 등 다른 명령어에서 -var-file="../global.tfvars" 없이도 실행 가능해집니다.
```
터미널에서 ./mac_running.sh 실행후 
source ~/.zshrc 실행

terraform init
terraform plan
terraform apply
terraform destroy
```

# linux_running 스크립트
> LinuxOS(ubuntu) 에서 linux_running.sh 실행 하시면 terraform 및 azure-cli 가 설치 됩니다 기존의 terraform init -backend-config="../backend.conf" 및 apply destroy 등 다른 명령어에서 -var-file="../global.tfvars" 없이도 실행 가능해집니다.
```
터미널에서 ./linux_running.sh 실행
source ~/.bashrc 실행

terraform plan
terraform apply
terraform destroy
```

# win_running 스크립트
> windowsOS 에서  win_running.bat 실행(관리자 권한) 하시면 terraform 및 azure-cli 가 설치 됩니다 기존의 terraform init -backend-config="../backend.conf" 및 apply destroy 등 다른 명령어에서 -var-file="../global.tfvars" 없이도 실행 가능해집니다.
```
terraform plan
terraform apply
terraform destroy
```

# running 스크립트 주의 사항
## 공통 주의사항 
> 프로젝트 디렉토리의  최상위 폴더이름은 main 이어야 합니다 
```
project
├── main (main 부터 시작)
│   ├──...
│   ...
└── modules
```

## MAC 주의사항 
> Mac_running 스크립트  Homebrew 가 설치 되어 있어야 합니다. 스크립트 실행 후 해당 터미널에서 source ~/.zshrc 를 실행 하여야 적용됩니다

## Linux 주의사항 
> Linux_running 스크립트 실행 후 해당 터미널에서 source ~/.bashrc 를 실행 하여야 적용됩니다  


## windows 주의사항 
> win_running 실행시 관리자권한으로 실행하여야 합니다. powerShell 터미널에서 . $PROFILE 을 실행 하여야 적용 됩니다 win_running.bat 실행시 setup_profile.ps1 파일이 같은 디렉토리에 있어야 합니다 



