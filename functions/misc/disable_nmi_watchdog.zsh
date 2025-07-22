# disable NMI Watchdog
disable_nmi_watchdog() {
  sudo sysctl kernel.nmi_watchdog=0
}
