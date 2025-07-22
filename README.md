# My Zsh Configuration

This is my personal Zsh configuration. It's designed to be fast, functional, and beautiful.

## Features

*   **Plugin Management**: Uses [zinit](https://github.com/zdharma-continuum/zinit) to manage plugins.
*   **Theme**: Uses the [Starship](https://starship.rs/) theme for a modern and informative prompt.
*   **Fuzzy Search**: Integrates [fzf](https://github.com/junegunn/fzf) for fuzzy searching through files, directories, and command history.
*   **Scripts**: Includes a collection of useful scripts for various tasks.
*   **Testing**: Uses the [zsh-test-runner](https://github.com/molovo/zsh-test-runner) framework for testing.

## Installation

1.  Clone this repository to `~/.config/zsh`:
    ```bash
    git clone https://github.com/your-username/your-repo.git ~/.config/zsh
    ```
2.  Install the plugins:
    ```bash
    zsh -c "source ~/.config/zsh/rc.d/03-plugins.zsh"
    ```
3.  Restart your shell.

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

## Testing

To run the tests, execute the following command:

```bash
zsh tests/test_example.zsh
```
