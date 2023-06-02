#!/usr/bin/env bash

set +e

show_help() {
cat << EOF
Usage: $(basename "$0") <options>

    -h, --help                              Display help
    -t, --type                              Test type
                                              1) set images list
                                              2) get s3 path
    -i, --images                            Docker images
    -il, --images-list                      Docker images list
    -tt, --test-type                        Test type
    -kv, --kubeblocks-version               KB version
EOF
}

eval_cmd() {
    cmd="$1"
    echo "
      \`$cmd\`
    "
    eval "$cmd"
}

set_images_list() {
    rm -f $IMAGES_LIST
    touch $IMAGES_LIST

    for image in `echo "$IMAGES" | sed 's/|/ /g'`; do
       echo "$image" >> $IMAGES_LIST
    done
}

get_s3_path() {
    if [[ $KB_VERSION != "v"* ]]; then
        KB_VERSION="v$KB_VERSION"
    fi
    s3_path="testinfra/kbcli-test/$KB_VERSION"
    case $TEST_TYPE in
        1)
            s3_path="$s3_path/mysql"
        ;;
        2)
            s3_path="$s3_path/postgresql"
        ;;
        5)
            s3_path="$s3_path/redis"
        ;;
        6)
            s3_path="$s3_path/mongodb"
        ;;
        *)
            s3_path="$s3_path/$TEST_TYPE"
        ;;
    esac
    echo "$s3_path"
}

main() {
    local TYPE=""
    local IMAGES=""
    local IMAGES_LIST=""
    local TEST_TYPE=""
    local KB_VERSION=""

    parse_command_line "$@"

    case $TYPE in
        1)
            set_images_list
        ;;
        2)
            get_s3_path
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
            -i|--images)
                IMAGES="$2"
                shift
            ;;
            -il|--images-list)
                IMAGES_LIST="$2"
                shift
            ;;
            -tt|--test-type)
                TEST_TYPE="$2"
                shift
            ;;
            -kv|--kubeblocks-version)
                KB_VERSION="$2"
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
