# 테라폼 가이드

## Terraform을 사용하기전 종속성 패키지 자동설치
> scripts -> azure 해당하는 OS의 스크립트 실행  `./*_running.sh`  
파일의 실행 권한이 없다면 `chmod +x *_running.sh` 실행 권한을 주고 실행  
Windows 는 <관리자 권한 실행> 필수 

## Terraform을 사용하기전 종속성 패키지 수동설치
> Azure CLI
<details><summary>windows</summary>

- Windows(64비트)용 AWS CLI MSI 설치 프로그램 다운로드 및 실행
    - https://aka.ms/installazurecliwindowsx64 

</details>
<details><summary>linux-ubuntu</summary>

- ```
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
  ```
</details>

</details>
<details><summary>Mac - brew</summary>

- ```
  brew install azure-cli
  ```
</details>

<br>

> terraaform CLI
<details><summary>windows</summary>

1. download
- 다운로드한 파일의 압축을 풀고 C:\terraform\terraform.exe에 복사합니다.
  - https://releases.hashicorp.com/terraform/1.6.2/terraform_1.6.2_windows_386.zip  

2. 환경변수 등록.
- 관리자 권한으로 Powershell을 실행하여 아래 명령어를 실행.
  - `[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\terraform", "Machine")`

</details>
<details><summary>linux-ubuntu</summary>

- ```
  sudo apt-get install -y wget
  wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt update && sudo apt install terraform
   ```
</details>
<details><summary>Mac - brew</summary>

- ```
  brew install terraform
   ```
</details>

<details><summary>Mac - brew(Silicon)</summary>

- ```
  brew install terraform
  git clone https://github.com/hashicorp/terraform-provider-template

  cd terraform-provider-template

  go build

  mkdir -p  ~/.terraform.d/plugins/registry.terraform.io/hashicorp/template/2.2.0/darwin_arm64

  mv terraform-provider-template ~/.terraform.d/plugins/registry.terraform.io/hashicorp/template/2.2.0/darwin_arm64/terraform-provider-template_v2.2.0_x5
  
  chmod +x ~/.terraform.d/plugins/registry.terraform.io/hashicorp/template/2.2.0/darwin_arm64/terraform-provider-template_v2.2.0_x5
   ```
</details>
<br>
<br>

## Terraform 실행
> ***<p style="color: red;">aks 리소스 생성시 aks_readme.md 가 생성됩니다 리소스 생성시 꼭 aks_readme.md를 확인 하세요</p>***
### 1. Azure 자격 증명 구성
> azure web으로 로그인 하여 자격증명 구성
- ```
  // 터미널에서 아래 명령어 실행 
  az login
  ```  

### 2. Provision 구성
- 터미널에서 `main\provision\RS1` 위치로 이동합니다.
  - `terraform init` Azure provider 구성
    - ```
      terraform\main\provision\RS1> terraform init      
      ...
      
      Terraform has been successfully initialized!
      
      You may now begin working with Terraform. Try running "terraform plan" to see
      any changes that are required for your infrastructure. All Terraform commands
      should now work.
      
      If you ever set or change modules or backend configuration for Terraform,
      rerun this command to reinitialize your working directory. If you forget, other
      commands will detect it and remind you to do so if necessary.
      terraform\main\provision\RS1>
      ```
 - `terraform apply` 로 resource 생성 ( `Enter a value` 에서 yes 입력)
    - ```
      terraform\main\provision\RS1> terraform apply
      Do you want to perform these actions in workspace "test"?
      Terraform will perform the actions described above.
      Only 'yes' will be accepted to approve.
         Enter a value: yes 
      
      ...
      
      Apply complete! 
      terraform\main\provision\RS1>  
      ```
  > terraform\main\provision\RS1\ 경로에\
  aks_readme.md 파일에 aks kube config 설정 커맨드가 있습니다   
  </details>

### 3. provision 구성 삭제 
> 삭제 전 kubernetes의 service 에서 nginx-ingress 의 external IP 가 붙은 service를 제거 후 destroy 해야 합니다  
azure 의 public ip 를 물고 있어서 service를 제거 하지 않으면 리소스가 삭제되지 않습니다 
- `terraform destroy` 로 resource 삭제 
