# My Zsh Configuration

This is my personal Zsh configuration. It's designed to be fast, functional, and beautiful.

## Features

*   **Fast and Modular**: The configuration is split into logical files and loads lazily for a fast startup time.
*   **Powerful Prompt**: Uses a custom [Starship](https://starship.rs/) theme that is both beautiful and informative. **Note:** Requires a [Nerd Font](https://www.nerdfonts.com/) to be installed and enabled in your terminal.
*   **Plugin Management**: Uses the fast and efficient [zinit](https://github.com/zdharma-continuum/zinit) to manage plugins.
*   **Fuzzy Everything**: Integrates [fzf](https://github.com/junegunn/fzf) for fuzzy searching through files, directories, and command history.
*   **Syntax Highlighting and Autosuggestions**: Leverages `zsh-syntax-highlighting` and `zsh-autosuggestions` for a better command-line experience.
*   **Seamless Dependency Management**: A bootstrap script installs all necessary dependencies, including:
    - `fzf`, `starship`, `thefuck`, `exa`, `bat`, `lsd`, `ripgrep`, `fd`, `gum`
*   **Interactive Menus**: Uses [gum](https://github.com/charmbracelet/gum) to create beautiful and interactive menus for scripts.
*   **Ops Kit**: Provides red team automation helpers loaded via `rc.d/14-ops.zsh`.
*   **Cross‑platform Support**: Detects Linux, macOS and WSL and only enables features when the required tools are present.
*   **Tested**: Includes a shell-based test suite to ensure reliability.

## Installation

1.  Clone this repository to `~/.config/zsh`:
    ```bash
    git clone https://github.com/zshconfig/zshconfig.git ~/.config/zsh
    ```
2.  Install the configuration:
    ```bash
    cd ~/.config/zsh
    make install
    ```
    This will run the bootstrap script to install all dependencies, and then install the scripts and man pages to `/usr/local`.
3.  **Set up a Nerd Font.** For the prompt to display correctly, you need to install a [Nerd Font](https://www.nerdfonts.com/font-downloads) and configure your terminal emulator to use it.
4.  Restart your shell.

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

For detailed usage of the red team helpers see the manual pages:

```bash
man ops_kit
man recon_wrapper
```
