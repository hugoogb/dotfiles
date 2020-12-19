# WSL: work around https://github.com/mintty/wsltty/issues/197
if [[ -n "$WSL_DISTRO_NAME" ]]; then
  command -v cmd.exe > /dev/null || exit
fi

# Switch to ZSH shell
if test -t 1; then
    exec zsh
fi
