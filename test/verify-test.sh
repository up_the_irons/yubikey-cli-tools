#!/bin/sh

cd "`dirname $0`"

missing_arguments_test() {
  ../verify.sh > /dev/null 2>&1
  if [ "$?" -eq 4 ]; then
    echo "missing_arguments_test PASSED"
  else
    echo "missing_arguments_test FAILED"
  fi

}

bad_otp_test() {
  ../verify.sh foo > /dev/null 2>&1
  if [ "$?" -eq 2 ]; then
    echo "bad_otp_test PASSED"
  else
    echo "bad_otp_test FAILED"
  fi
}

replayed_otp_test() {
  echo "Press your YubiKey button or [ENTER] to abort this test"
  read OTP
  if [ ! -z "$OTP" ]; then
    # Verify it once
    ../verify.sh $OTP > /dev/null 2>&1

    # Now let's verify it again, it should come back as replayed
    ../verify.sh $OTP > /dev/null 2>&1

    if [ "$?" -eq 1 ]; then
      echo "replayed_otp_test PASSED"
    else
      echo "replayed_otp_test FAILED"
    fi
  else
    echo "replayed_otp_test SKIPPED"
  fi
}

ok_otp_test() {
  echo "Press your YubiKey button or [ENTER] to abort this test"
  read OTP
  if [ ! -z "$OTP" ]; then
    ../verify.sh $OTP > /dev/null 2>&1
    if [ "$?" -eq 0 ]; then
      echo "ok_otp_test PASSED"
    else
      echo "ok_otp_test FAILED"
    fi
  else
    echo "ok_otp_test SKIPPED"
  fi
}

missing_arguments_test
bad_otp_test
replayed_otp_test
ok_otp_test

exit 0
