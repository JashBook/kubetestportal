#!/usr/bin/env bash

set +e

REGISTRY_DEFAULT=docker.io

show_help() {
cat << EOF
Usage: $(basename "$0") <options>

    -h, --help                              Display help
    -t, --type                              Test type
                                              1) generate image yaml
    -i, --image                             Docker image name
    -r, --registry                          Docker image registry (default: $REGISTRY_DEFAULT)
EOF
}

generate_image_yaml() {
    if [[ -z "$IMAGE" ]]; then
        echo "image name is empty"
        return
    fi
    image_sync_yaml="./image_sync_yaml.yml"
    rm -f $image_sync_yaml
    touch $image_sync_yaml
    image_name=${IMAGE##*/}
tee $image_sync_yaml << EOF
${REGISTRY}/${IMAGE}:
  - "infracreate-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud/${image_name}"
  - "registry.cn-hangzhou.aliyuncs.com/apecloud/${image_name}"
EOF
}


main() {
    local TYPE=""
    local IMAGE=""
    local REGISTRY=$REGISTRY_DEFAULT

    parse_command_line "$@"

    case $TYPE in
        1)
            generate_image_yaml
        ;;
    esac
}

parse_command_line() {
    while :; do
        case "${1:-}" in
            -h|--help)
                show_help
                exit
            ;;
            -t|--type)
                TYPE="$2"
                shift
            ;;
            -i|--image)
                IMAGE="$2"
                shift
            ;;
            -r|--registry)
                REGISTRY="$2"
                shift
            ;;
            *)
                break
            ;;
        esac
        shift
    done
}

main "$@"
