#!/usr/bin/env bash

#
# Exit Codes
#

EXIT_CODE_VALIDATION_ERROR=1
EXIT_CODE_TRANSFORMATION_ERROR=2

EXIT_CODE_INCOMPATIBLE=1

EXIT_CODE_UNEXPECTED_ERROR=255

#
# Utilities
#

isHex() {
  v="$(printf '%d' "'$c")"

  if [ "$v" -gt 47 ] && [ "$v" -lt 58 ]; then
    return 0
  fi

  if [ "$v" -gt 64 ] && [ "$v" -lt 71 ]; then
    return 0
  fi

  if [ "$v" -gt 96 ] && [ "$v" -lt 103 ]; then
    return 0
  fi

  return 1
}


logMessage() {
  >&2 echo "$1"
}


verifyDir() {
  if [ -z "$1" ]; then
    logMessage "required directory parameter was blank or absent"
    return 1
  fi

  if [ ! -d "$1" ]; then
    logMessage "directory $1 does not exist or is not a directory"
    return 1
  fi

  return 0
}


verifyFile() {
  if [ -z "$1" ]; then
    logMessage "required file parameter was blank or absent"
    return 1
  fi

  if [ ! -f "$1" ]; then
    logMessage "path $1 does not exist or is not a regular file"
    return 1
  fi

  return 0
}


# Verify VDI ID
#
# Ensures that the given VDI ID resembles a valid VDI ID in that it is a 32
# character hex value.
#
# Signature:
#   verifyVDIID <vdi-id>
#
# Parameters:
#   vdi-id  - String value to test.
#
# Return:
#   0 = The given value resembles a valid VDI dataset ID.
#   1 = The given value does not resemble a valid VDI dataset ID.
#
# Example Usage:
#   verifyVDIID $SOME_VALUE || exit $EXIT_CODE_UNEXPECTED_ERROR
verifyVDIID() {
  vdi_id="$1"

  if [ -z "$vdi_id" ]; then
    logMessage "required VDI ID parameter was blank or absent"
    return 1
  fi

  if [ ! 32 -eq "${#vdi_id}" ]; then
    logMessage "invalid VDI ID length"
    return 1
  fi

  for (( i=0; i < 32; i++ )); do
    c="${vdi_id:i:1}"

    if ! isHex c; then
      logMessage "invalid VDI ID"
      return 1
    fi
  done

  return 0
}


verifyEnv() {
  if [ -z "$2" ]; then
    logMessage "required environment variable $1 is blank or unset"
    return 1
  fi
}