###############################################################################
# test_helper.bash
#
# Test helper for Bats: Bash Automated Testing System.
#
# https://github.com/sstephenson/bats
###############################################################################

# bats_require_minimum_version
#
# https://github.com/bats-core/bats-core/blob/master/docs/source/writing-tests.md
if hash "bats_require_minimum_version" &>/dev/null
then
  bats_require_minimum_version 1.5.0
fi

# _setup()
#
# Usage:
#   _setup [<bats-base-path>]
#
# Description:
#   Set up the test environment.
_setup() {
  IFS=$'\n\t'

  # Allow clobber. More info: https://stackoverflow.com/a/6762399
  set +o noclobber

  # Allow globbing.
  set +o noglob

  #############################################################################

  # $FONT_TEST_BASE_PATH
  #
  # The base directory for the test suite.
  export FONT_TEST_BASE_PATH="${1:-"${BATS_TEST_DIRNAME}"}"
  # $_ME
  #
  # The name of the program.
  export _ME="font"

  # $_FONT
  #
  # The location of the `font` script being tested.
  export _FONT="${FONT_TEST_BASE_PATH}/../font"

  # $_TMP_DIR
  #
  # The temp directory for the test run.
  export _TMP_DIR=
  _TMP_DIR="$(mktemp -d /tmp/font_test.XXXXXX)" || exit 1

  # #############################################################################

  # $FONT_COLOR_PRIMARY
  #
  # Set to a value compatible with CI terminals.
  export FONT_COLOR_PRIMARY=3

  # $FONT_DIR
  #
  # The location of the directory that contains the installed fonts.
  export FONT_DIR="${_TMP_DIR}/fonts"


  # FONT_MANIFEST_DIR
  #
  # The location of the directory that contains the manifest file.
  export FONT_MANIFEST_DIR="${_TMP_DIR}/manifest"

  # $FONT_DOWNLOAD_TOOL
  #
  # Only use curl for downloads.
  export FONT_DOWNLOAD_TOOL="curl"

  # $FONT_TESTING
  #
  # Always set to 1 within tests.
  export FONT_TESTING=1

  # $_ERROR_PREFIX
  #
  # The color string added to error messages by `_exit_1` and `_return_1`.
  export _ERROR_PREFIX=
  _ERROR_PREFIX="$(tput setaf 1)!$(tput sgr0)"

  #############################################################################
  # verify that FONT_DIR and FONT_MANIFEST_DIR are in the temp directory

  if [[ ! "${FONT_DIR}"           =~ ^/tmp/font_test ]] ||
     [[ ! "${FONT_MANIFEST_DIR}"  =~ ^/tmp/font_test ]]
  then
    exit 1
  fi
}

###############################################################################
# setup() and teardown()
#
# https://bats-core.readthedocs.io/en/stable/writing-tests.html
###############################################################################

setup() {
  _setup
  # export _COMMAND="${BATS_TEST_DIRNAME}/../font"

  # Use empty `font` script in environment to avoid depending on `font`
  # being available in `$PATH`.
  export PATH="${FONT_TEST_BASE_PATH}/fixtures/bin:${PATH}"
}

###############################################################################
# Helpers
###############################################################################

# _compare()
#
# Usage:
#   _compare <expected> <actual>
#
# Description:
#   Compare the content of a variable against an expected value. When used
#   within a `@test` block the output is only displayed when the test fails.
_compare() {
  local _expected="${1:-}"
  local _actual="${2:-}"
  printf "expected:\n%s\n" "${_expected}"
  printf "actual:\n%s\n" "${_actual}"
}
