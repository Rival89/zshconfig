# My Zsh Configuration

This is my personal Zsh configuration. It's designed to be fast, functional, and beautiful.

![Zsh Config Banner](./https://github.com/Rival89/zshconfig/blob/main/ZSH-CONFIGbanner.png)



## Features

*   **Plugin Management**: Uses [zinit](https://github.com/zdharma-continuum/zinit) to manage plugins.
*   **Theme**: Uses the [Starship](https://starship.rs/) theme for a modern and informative prompt.
*   **Fuzzy Search**: Integrates [fzf](https://github.com/junegunn/fzf) for fuzzy searching through files, directories, and command history.
*   **Command Correction**: Leverages [`thefuck`](https://github.com/nvbn/thefuck) when installed via Homebrew or APT.
*   **Scripts**: Includes a collection of useful scripts for various tasks.
*   **Ops Kit**: Provides red team automation helpers loaded via `rc.d/14-ops.zsh`.
*   **Gum Integration**: Interactive menus use [gum](https://github.com/charmbracelet/gum); the launcher will install it if missing.
*   **Cross‑platform Support**: Detects Linux, macOS and WSL and only enables features when the required tools are present.
*   **Testing**: Includes a small shell-based test script.

## Installation

1.  Clone this repository to `~/.config/zsh`:
    ```bash
    git clone https://github.com/zshconfig/zshconfig.git ~/.config/zsh
    ```
2.  Bootstrap dependencies and plugins using Make:
    ```bash
    cd ~/.config/zsh
    make bootstrap
    ```
3.  Restart your shell.

The configuration detects Linux, macOS and WSL automatically. Features that rely on
external tools are only enabled if those tools are available so the shell works
across different environments.

## Usage

*   `Ctrl-R`: Fuzzy search through command history.
*   `Alt-C`: Fuzzy search through directories and `cd` into the selected one.
*   `Ctrl-T`: Fuzzy search through files and paste the selected one into the command line.
*   `lscript`: Launch a script from the `scripts` directory.
*   `sysinfo`: Display system information.
*   `diskspace`: Display disk space usage.
*   `dockerstatus`: Display the status of your docker containers.
*   `fail2banstatus`: Display the status of fail2ban.
*   `transfer`: Transfer files to and from transfer.sh.
*   `cheat`: Access cheatsheets from cheat.sh.
*   `movies`: Get information about movies from the OMDb API.
*   `web_crawler`: Crawl a target web domain to expose hidden files and directories.
*   `op:new`: Create an operation workspace under `~/ops`.
*   `op:tmux`: Spawn a tmux session preconfigured for recon and loot collection.
*   `recon_wrapper.sh`: Interactive helper that chains tools like `nmap`, `whois` and `dnsenum`.
*   `ops_menu.sh`: Launch a gum-based menu for common ops kit actions.

## Testing

To run the tests, execute the following command:

```bash
make test
```

For detailed usage of the red team helpers see the manual page:

```bash
man ops_kit
```

Manual pages for `ops_kit` and `recon_wrapper` are provided in the `man/`
directory and can be viewed with `man -l man/ops_kit.1`.
