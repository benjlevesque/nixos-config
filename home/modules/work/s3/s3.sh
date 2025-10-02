#!/usr/bin/env bash

bucket="${1:-}"
verb="${2:-}"
path="${3:-}"
shift 3
otherArgs="$@"

help(){
  echo "USAGE: $0 BUCKET VERB PATH"
  echo "Example: $0 potentiel-production ls \"PPE2 - Sol/...\"" 
}

if [ -z "$bucket" ] || [ -z "$verb" ]; then
  help
  exit 1
fi

cfg_file=~/.s3cmd/$bucket.s3cfg.gpg


if [ ! -f "$cfg_file" ]; then  echo "Error: Configuration file $cfg_file not found"
  exit 1
fi


s3cmd -c <(gpg -d "$cfg_file") "$verb" "s3://$bucket/$path" $otherArgs
