


# Create a custom brew wrapper that automatically adds gnubin paths to a variable that can be sourced
# ls /usr/local/opt/**/gnubin(D)
# https://github.com/Homebrew/brew/issues/3933
#
#
# newbrew() {
#   local dump_commands=('install' 'uninstall') # Include all commands that should do a brew dump
#   local main_command="${1}"

#   brew ${@}

#   for command in "${dump_commands[@]}"; do
#     [[ "${command}" == "${main_command}" ]] && brew bundle dump --file="${HOME}/.Brewfile" --force
#   done
# }
