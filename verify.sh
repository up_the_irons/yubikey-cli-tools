#!/bin/sh
#
# :Author: Garry Dolley
# :Date: 07-13-2011
#
# Verify a YubiKey OTP

usage() {
  echo "Verify a Yubikey OTP"
  echo ""
  echo "Usage:"
  echo ""
  echo "  $0 <yubikey-otp> [verbose]"
  echo ""
  echo "If a non-zero length second argument is supplied, the OTP status is output to STDOUT"
  echo ""
  echo "Exit Status:"
  echo ""
  echo "  0 - OTP OK"
  echo "  1 - OTP REPLAYED"
  echo "  2 - OTP BAD"
  echo "  3 - Unknown Error"
  echo "  4 - Argument Error"
}

OTP=$1
VERBOSE=$2

if [ -z "$OTP" ]; then
  usage
  exit 4
fi

# I got this from https://github.com/titanous/yubikey.git
# How do I get my own?
API_ID=2549

API_URL="https://api.yubico.com/wsapi"
API_CMD="verify"

URL="$API_URL/$API_CMD?id=$API_ID&otp=$OTP"

STATUS=$(curl -s $URL | grep ^status= | sed "s/^status=\(.*\)$/\1/")

if [ -n "$VERBOSE" ]; then
  echo $STATUS
fi

case "$STATUS" in
  OK*)
    exit 0
    ;;
  REPLAYED_OTP*)
    exit 1
    ;;
  BAD_OTP*)
    exit 2
    ;;
  *)
    exit 3
    ;;
esac
