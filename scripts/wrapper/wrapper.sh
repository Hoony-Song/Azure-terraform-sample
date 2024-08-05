#!/bin/bash
terraformExe="/usr/local/bin/terraform"
WORKSPACE=$($terraformExe workspace show)
BACKEND_CONF="backend.conf"
VAR_FILE="${WORKSPACE}.tfvars"

find_parent_of_main() {
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



# Terraform 명령어 래핑 스크립트
case "$1" in
  init)
    # init 명령어에 -backend-config 옵션 추가
    BACKEND_CONFIG_PATH=$(find_parent_of_main "$BACKEND_CONF")
    if [ -n "$BACKEND_CONFIG_PATH" ] && [ -f "$BACKEND_CONFIG_PATH" ]; then
        echo "Backend configuration file found: $BACKEND_CONFIG_PATH"
        command terraform init -backend-config="$BACKEND_CONFIG_PATH" "${@:2}"
    else
        echo "Backend configuration file not found."
        command terraform init "${@:2}"
    fi
    ;;
  plan|apply|destroy|refresh|import)
    # 기타 명령어에 -var-file 옵션 추가
    VAR_FILE_PATH=$(find_parent_of_main "$VAR_FILE")
    if [ -n "$VAR_FILE_PATH" ] && [ -f "$VAR_FILE_PATH" ]; then
        echo "variables file found: $VAR_FILE_PATH"
        command terraform "$1" -var-file="$VAR_FILE_PATH" "${@:2}"
    else
        echo "variables file not found."
        command terraform "$1" "${@:2}"
    fi
    ;;
  *)
    command terraform "$@"
    ;;
esac
echo "wrapper running"

