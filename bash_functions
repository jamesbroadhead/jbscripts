#!/usr/bin/env bash

detect_ssh_keys() {
  ssh-agent -l &> /dev/null
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
