#!/bin/bash

#### terraform cli latest version 
# TERRAFORM_VERSION=$(curl -s https://releases.hashicorp.com/terraform/ | grep -oE 'terraform_[0-9a-zA-Z\.\-]+' | head -n 1 | cut -d '_' -f 2)
TERRAFORM_VERSION=1.8.0

echo "${TERRAFORM_VERSION}"
# 다운로드 URL 설정
TERRAFORM_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_darwin_arm64.zip"

if terraform -v > /dev/null 2>&1; then
  echo "===> Terraform is already installed."
else
  echo "===> Installing Terraform..."

# /usr/local/bin 경로가 없으면 생성
  if [ ! -d "/usr/local/bin" ]; then
    sudo mkdir -p /usr/local/bin
  fi

  # 다운로드 및 압축 해제
  curl -o terraform.zip ${TERRAFORM_URL}
  unzip terraform.zip

  # 실행 파일 이동
  sudo mv terraform /usr/local/bin/

  # 압축 파일 삭제
  rm terraform.zip

  # 설치 확인
  terraform -v
fi

if az -v > /dev/null 2>&1; then 
  echo "===> Azure CLI is already installd..."
else
  echo "===> Home brew update... " 
  brew update
  echo "===> Installing Azure CLI..."
  brew install azure-cli 

  az -v 
fi

TESTRC_PATH="$HOME/.zshrc"
BACKUP_DIR="$HOME/zshrc_Backup"

# 백업 폴더 생성
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir "$BACKUP_DIR"
    echo "Created backup directory at $BACKUP_DIR"
fi

# .bashrc 파일 백업
if [ -f "$TESTRC_PATH" ]; then
    TIMESTAMP=$(date +%Y%m%d%H%M%S)
    cp "$TESTRC_PATH" "$BACKUP_DIR/bashrc_$TIMESTAMP"
    echo "Backup of .bashrc created at $BACKUP_DIR/bashrc_$TIMESTAMP"
fi

CONDITIONAL_FUNCTION=$(cat <<'EOF'
find_from_main() {
    local file_to_find=$1
    local current_dir=$(pwd)
    local parent_of_main=""

    # main 디렉토리로 이동
    while [[ "$current_dir" != "/" ]]; do
        if [[ "$(basename "$current_dir")" == "main" ]]; then
            parent_of_main=$(dirname "$current_dir")
            break
        fi
        current_dir=$(dirname "$current_dir")
    done

    # main의 상위 디렉토리에서 파일 찾기 시작
    if [[ -n "$parent_of_main" ]]; then
        local found=$(find "$parent_of_main" -type f -name "$file_to_find" -print -quit)
        if [[ -n "$found" ]]; then
            echo "$found"
            return 0
        fi
    fi
    return 1
}
unalias terraform 2>/dev/null

# Terraform 실행 함수 정의
terraform() {
    # 찾을 파일 이름 설정
    local filename="wrapper.sh"

    # 파일 검색
    WRAPPER_PATH=$(find_from_main "$filename")

    # 파일이 존재하는 경우 실행
    if [[ -f "$WRAPPER_PATH" ]]; then
        echo "find run wrapper.sh"
        "$WRAPPER_PATH" "$@"
    else
        echo "find not wrapper.sh"
        command terraform "$@"
    fi
}
EOF
)

# .bashrc 파일에 조건부 terraform 함수가 있는지 확인하고 없으면 추가
if grep -q 'function terraform()' "$TESTRC_PATH"; then
    echo "Conditional terraform function already exists in $TESTRC_PATH"
else
    echo "$CONDITIONAL_FUNCTION" >> "$TESTRC_PATH"
    echo "Added conditional terraform function to $TESTRC_PATH"
fi

# 변경 사항 적용
echo "Please restart your terminal or run 'source ~/.zshrc' in your shell to apply the changes."


# find_upwards() {
#     local file_to_find=$1
#     local max_levels=$2
#     local current_dir=$(pwd)
#     local level=0

#     while [ $level -lt $max_levels ]; do
#         # 현재 디렉토리와 모든 하위 디렉토리에서 파일 검색
#         local found=$(find "$current_dir" -type f -name "$file_to_find" -print -quit)
#         if [ -n "$found" ]; then
#             echo "$found"
#             return 0
#         fi

#         current_dir=$(dirname "$current_dir")
#         if [ "$current_dir" == "/" ]; then
#             break
#         fi
#         level=$((level + 1))
#     done
#     return 1
# }

# # Terraform 실행 함수 정의
# function terraform() {
#     # 찾을 파일 이름과 최대 검색 레벨 설정
#     local filename="wrapper.sh"
#     local max_levels=5

#     # 파일 검색
#     WRAPPER_PATH=$(find_upwards "$filename" "$max_levels")

#     # 파일이 존재하는 경우 실행
#     if [ -f "$WRAPPER_PATH" ]; then
#         "$WRAPPER_PATH" "$@"
#     else
#         command terraform "$@"
#     fi
# }
