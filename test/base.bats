#!/usr/bin/env bats

load test_helper

setup_file() {
  export _HELP_HEADER=
  _HELP_HEADER="\
  __     ___      ___         .
 / _|   /\\  \\   /' _ \`\\     .o8
| |_   /::\\  \\  /\\ \\/\\ \\  .o888oo
|  _| /:/\\:\\__\\ \\ \\_\\ \\_\\   888
|_|   \\:\\/:/  /  \\/_/\\/_/   888
       \\::/  /              888 .
        \\/__/               \"888\""
}

@test "'font' with no arguments exits with status 0." {
  printf "!!!! _FONT: ${_FONT}"

  run "${_FONT}"
  [[ "${status}" -eq 0 ]]
}

# subcommands ################################################### subcommands #

@test "'font subcommands' returns with 0 status." {
  run "${_FONT}" subcommands
  [[ "${status}" -eq 0 ]]
}

@test "'font subcommands' prints list of subcommands with header." {
  run "${_FONT}" subcommands
  _expected="$(
    cat <<HEREDOC
Available subcommands:
  help
  install
  list
  status
  subcommands
  uninstall
  version
HEREDOC
  )"
  _compare "${_expected}" "${output}"
  [[ "${output}" == "${_expected}" ]]
}

@test "'font subcommands --raw' returns with 0 status." {
  run "${_FONT}" subcommands --raw
  [[ "${status}" -eq 0 ]]
}

@test "'font subcommands --raw' prints list of subcommands." {
  run "${_FONT}" subcommands --raw
  _expected="$(
    cat <<HEREDOC
help
install
list
status
subcommands
uninstall
version
HEREDOC
  )"
  _compare "${_expected}" "${output}"
  [[ "${output}" == "${_expected}" ]]
}

# example ########################################################### example #

# @test "'font example' returns with a 0 status." {
#   run "${_FONT}" example
#   [[ "${status}" -eq 0 ]]
# }

# @test "'font example' prints a string." {
#   run "${_FONT}" example
#   printf "'%s'" "${output}"
#   [[ "${output}" == "Hello, World!" ]]
# }

# @test "'font example <name>' returns with a 0 status." {
#   run "${_FONT}" example Name
#   [[ "${status}" -eq 0 ]]
# }

# @test "'font example <name>' prints a string modified by <name>." {
#   run "${_FONT}" example Name
#   printf "'%s'" "${output}"
#   [[ "${output}" == "Hello, Name!" ]]
# }

# @test "'font example --farewell' returns with a 0 status." {
#   run "${_FONT}" example --farewell
#   [[ "${status}" -eq 0 ]]
# }

# @test "'font example --farewell' prints a string modified by --farewell." {
#   run "${_FONT}" example --farewell
#   printf "'%s'" "${output}"
#   [[ "${output}" == "Goodbye, World!" ]]
# }


# @test "'font example <name> --farewell' returns with a 0 status." {
#   run "${_FONT}" example Name --farewell
#   [[ "${status}" -eq 0 ]]
# }

# @test "'font example <name> --farewell' prints a string modified by both arguments." {
#   run "${_FONT}" example Name --farewell
#   printf "'%s'" "${output}"
#   [[ "${output}" == "Goodbye, Name!" ]]
# }

# help ################################################################# help #

@test "'font' with no arguments prints help." {
  run "${_FONT}"
  _compare "${_HELP_HEADER}" "$(IFS=$'\n'; echo "${lines[*]:0:7}")"
  [[ "$(IFS=$'\n'; echo "${lines[*]:0:7}")" == "${_HELP_HEADER}" ]]
}

@test "'font -h' prints help." {
  run "${_FONT}" -h
  _compare "${_HELP_HEADER}" "$(IFS=$'\n'; echo "${lines[*]:0:7}")"
  [[ "$(IFS=$'\n'; echo "${lines[*]:0:7}")" == "${_HELP_HEADER}" ]]
}

@test "'font --help' prints help." {
  run "${_FONT}" --help
  _compare "${_HELP_HEADER}" "$(IFS=$'\n'; echo "${lines[*]:0:7}")"
  [[ "$(IFS=$'\n'; echo "${lines[*]:0:7}")" == "${_HELP_HEADER}" ]]
}

@test "'font help' prints help." {
  run "${_FONT}" help
  _compare "${_HELP_HEADER}" "$(IFS=$'\n'; echo "${lines[*]:0:7}")"
  [[ "$(IFS=$'\n'; echo "${lines[*]:0:7}")" == "${_HELP_HEADER}" ]]
}

@test "'font help help' prints 'help' subcommand usage." {
  run "${_FONT}" help help
  _expected="$(
    cat <<HEREDOC
Usage:
  font help [<subcommand>]

Description:
  Display help information for font or a specified subcommand.
HEREDOC
  )"
  _compare "${_expected}" "${output}"
  [[ "${output}" == "${_expected}" ]]
}

# version ########################################################### version #

@test "'font version' returns with 0 status." {
  run "${_FONT}" version
  [[ "${status}" -eq 0 ]]
}

@test "'font version' prints a version number." {
  run "${_FONT}" version
  printf "'%s'" "${output}"
  echo "${output}" | grep -q '[0-9]\+\.[0-9]\+\.[0-9]\+'
}

@test "'font --version' returns with 0 status." {
  run "${_FONT}" --version
  [[ "${status}" -eq 0 ]]
}

@test "'font --version' prints a version number." {
  run "${_FONT}" --version
  printf "'%s'" "${output}"
  echo "${output}" | grep -q '[0-9]\+\.[0-9]\+\.[0-9]\+'
}
