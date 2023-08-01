[[ -s $HOME/Git/stderred/build/libstderred.so ]] && export LD_PRELOAD=$HOME/Git/stderred/build/libstderred.so

ld-debug() {
  LD_DEBUG=all "$@" 2>&1 | less
}
