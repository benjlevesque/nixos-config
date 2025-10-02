
# Shell completion function
_s3_complete() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  case $COMP_CWORD in
    1)
      # Complete bucket names from ~/.s3cmd/*.s3cfg.gpg files
      local buckets=$(find ~/.s3cmd -name "*.s3cfg.gpg" 2>/dev/null | sed 's|.*/||; s|\.s3cfg\.gpg$||')
      COMPREPLY=($(compgen -W "$buckets" -- "$cur"))
      ;;
    2)
      # Complete verb options
      COMPREPLY=($(compgen -W "ls get info setacl" -- "$cur"))
      ;;
  esac
}

# Register completion function
complete -F _s3_complete s3