#compdef s3

_s3() {
  local -a buckets
  local state

  _arguments -C \
    '1:bucket name:->bucket' \
    '2:command:->cmd'

  case $state in
    bucket)
      buckets=(${(f)"$(find ~/.s3cmd -name '*.s3cfg.gpg' 2>/dev/null | sed 's|.*/||; s|\.s3cfg\.gpg$||')"})
      _describe 'bucket' buckets
      ;;
    cmd)
      local -a verbs=('ls:List contents' 'get:Download object' 'info:Get object info' 'setacl:Set access control')
      _describe 'command' verbs
      ;;
  esac
}