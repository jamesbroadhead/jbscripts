#!/usr/bin/env bash
# shellcheck disable=SC2230


# shellcheck disable=SC2120
activate_virtualenv () {
  if ! [ z"$1" == "z" ] && [ -e "$1"/bin/activate ] ;  then
    DIR="$1"
  elif [ -d "${HOME}/venv/default" ] ; then
    DIR="$HOME/venv/default"
  elif [ -d "${HOME}/virt_env/default" ] ; then
    DIR="$HOME/virt_env/default"
  else
    echo "No venv found :( "
    return 1
  fi
  # shellcheck disable=SC1090
  source "$DIR/bin/activate"
}
export -f activate_virtualenv
alias ave="activate_virtualenv"

cat_which() {
  cat "$(which "$1")"
}
export cat_which
alias cw="cat_which"

cd_directory_of() {
    D="$(dirname "$1")"
    cd "${D}" || return 1
}
export cd_directory_of
alias cdd="cd_directory_of"

cd_directory_of_which() {
    cdd "$(which "$1")"
}
export cd_directory_of_which
alias cddw="cd_directory_of_which"

detect_ssh_keys() {
  ssh-agent -l &> /dev/null

  # shellcheck disable=SC2181
  if [ $? -eq 0 ] ; then
    # we have a key
    return 0
  elif [ $? -eq 1 ] ; then
    # ssh-agent is running, but has no keys
    return 1
  elif [ $? -eq 2 ] ; then
    # ssh-agent is not running, or some other error
    return 1
  fi
  return 1
}
export detect_ssh_keys

vim_which() {
  results=()
  for arg in "$@" ; do
      resolved="$(which "${arg}")" 2> /dev/null

      if [ -f "${resolved}" ] ; then
        results+=("${resolved}")
    fi
  done

  if [ "${#results[@]}" -eq 0 ] ; then # array length
    echo "files not found"
    return 1
  fi

  vi -p "${results[@]}"
}
export vim_which
alias viw="vim_which"
