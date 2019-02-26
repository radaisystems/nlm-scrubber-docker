#!/usr/bin/env bash

function error() {
  >&2 echo $1
  >&2 echo "usage: $0 INPUT_DIRECTORY OUTPUT_DIRECTORY [FILE_REGEX]"
  exit 1
}

if [ -z "$1" ]; then
  error "INPUT_DIRECTORY Required"
fi
input_path=$(python -c 'import os,sys;print(os.path.realpath(sys.argv[1]))' $1)

if [ -z "$2" ]; then
  error "OUTPUT_DIRECTORY Required"
fi
output_path=$(python -c 'import os,sys;print(os.path.realpath(sys.argv[1]))' $2)

if [ -z "$3" ]; then
  export SCRUBBER_REGEX='.\*\\.txt'
else
  export SCRUBBER_REGEX=$3
fi

if echo "$SCRUBBER_REGEX" | grep -q '\*.*\*' ; then
  error "NLM Scrubber does not support multiple wildcards in regex."
fi

docker run -it -rm -v $input_path:/tmp/once_off/input -v $output_path:/tmp/once_off/output --env SCRUBBER_REGEX radaisystems/nlm-scrubber
