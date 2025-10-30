# pd.sh – Change Project Directories in Two (Or More) Terminals

A simple shell script to synchronize directory changes between frontend and backend terminals during development.

1.  In one terminal, run `pd <directory>` to change to a project's frontend or backend directory (or subdirectories).
2.  In another terminal, run `pd` (no arguments) to change to the project's corresponding backend or frontend directory (or subdirectories).

If subdirectories don't match exactly then the script walks up the directory tree to find the deepest existing common path.

## Features

- 🔄 Automatically sync between `frontend` and `backend` directories
- 📁 Intelligent subdirectory matching – finds the deepest existing path
- 🛡️ Error checking and validation
- 🚀 Works with bash, zsh, and other POSIX-compatible shells
- 💾 Persistent state across terminal sessions

## Installation

This script must be installed manually because of the wide variety of shells.  Don't worry – it isn't tedious!

1.  **Download [`pd.sh`](https://raw.githubusercontent.com/kwoodman1970/pd_ProjectDirectory/refs/heads/main/pd.sh) to `~/bin` (ensure that this directory is in your shell's path).**

    You could also use a command like one of these:

    ```bash
    curl -o ~/pd.sh https://raw.githubusercontent.com/kwoodman1970/pd_ProjectDirectory/refs/heads/main/pd.sh
    ```

    ```bash
    wget -O ~/pd.sh https://raw.githubusercontent.com/kwoodman1970/pd_ProjectDirectory/refs/heads/main/pd.sh
    ```

2.  **Make `pd.sh` exceutable.**

    Enter the following commmand:

    ```bash
    chmod +x ~/bin/pd.sh
    ```

3.  **Add the following to your shell's resource file:**

    ```bash
    # Project Directory Sync
    pd() {
        source ~/bin/pd.sh "$@"
    }
    ```

    The location of this resource file depends on which shell you're using.  Some common ones are:

    - bash: `~/.bashrc` or `~/.bashrc_profile`
    - Git-bash: `/etc/bash.bashrc`
    - zsh (including Oh My Zsh): `~/.zshrc`

4.  <a id="installation_step4"></a>**Reload your shell's configuration by using `source`:**

    **For example,** use one of the following commands (depending, again, on the location of your shell's resource file):

    ```bash
    source ~/.bashrc
    source /etc/bash.bashrc
    source ~/.zshrc
    ```

## How to Use

### Basic Workflow

**Terminal 1 (Frontend):**
```bash
pd ~/projects/myapp/frontend
# Output: Saved and changed to: /home/user/projects/myapp/frontend
```

**Terminal 2 (Backend):**
```bash
pd
# Output: Changed to: /home/user/projects/myapp/backend
```

### With Subdirectories

**Terminal 1:**
```bash
pd ~/projects/myapp/frontend/src/components
```

**Terminal 2:**
```bash
pd
# Goes to: ~/projects/myapp/backend/src/components (if it exists)
# Or walks up to: ~/projects/myapp/backend/src (if components doesn't exist)
# Or walks up to: ~/projects/myapp/backend (if src doesn't exist)
```

## Examples

```bash
# Example 1: Basic sync
$ pd ~/work/ecommerce/frontend
Saved and changed to: /home/user/work/ecommerce/frontend

$ pd  # In another terminal
Changed to: /home/user/work/ecommerce/backend
```

```bash
# Example 2: Deep directory with intelligent matching
$ pd ~/work/ecommerce/frontend/src/pages/checkout/payment
Saved and changed to: /home/user/work/ecommerce/frontend/src/pages/checkout/payment

$ pd  # Backend doesn't have 'payment' folder
Changed to: /home/user/work/ecommerce/backend/src/pages/checkout
# Automatically found the deepest matching directory!
```

```bash
# Example 3: Working with relative paths
$ cd ~/work/ecommerce
$ pd frontend/src
Saved and changed to: /home/user/work/ecommerce/frontend/src

$ pd
Changed to: /home/user/work/ecommerce/backend/src
```

## Command Reference

```bash
pd <directory>  # Change to <directory> and remember it
pd              # cd to corresponding frontend/backend directory
```

## Customization

After editing `pd.sh`, reload your shell configuration (see [Installation Step 4](#installation_step4) above).

### Different Directory Names

If your projects use different naming conventions (e.g., `client`/`server` instead of `frontend`/`backend`), simply edit the variables at the top of `pd.sh` – for example:

```bash
# Configuration - customize these directory names for your project structure
DIR_FRONTEND="client"
DIR_BACKEND="server"
```

Or for other common patterns:

```bash
# For web/api structure
DIR_FRONTEND="web"
DIR_BACKEND="api"

# For ui/services structure
DIR_FRONTEND="ui"
DIR_BACKEND="services"

# For app/backend structure
DIR_FRONTEND="app"
DIR_BACKEND="backend"
```

### Different Data Storage Location

By default, the script stores state in `~/.pd`. To change this, modify the `PD_DATA_FILE` variable at the top of the script:

```bash
PD_DATA_FILE="$HOME/.config/pd_data"  # Example alternative location
```

## Requirements

- A POSIX-compatible shell (bash, zsh, dash, ksh, etc.)
- Write access to `~/.pd` (used for storing the current directory)

## Compatibility

✅ **Tested and working:**
- Bash 3.2+
- Zsh 5.0+
- Oh My Zsh
- iTerm2 (with bash or zsh)
- macOS Terminal
- Linux terminals (GNOME Terminal, Konsole, etc.)

✅ **Should work with:**
- dash
- ksh
- Any POSIX-compatible shell

## Troubleshooting

### "Command not found: pd"

Make sure you've added the `pd()` function to your shell's RC file and reloaded it:
```bash
source ~/.bashrc  # or ~/.zshrc, or whatever your shell's resource file is called
```

### "No saved directory found"

You need to run `pd <directory>` first in one terminal before using `pd` without arguments in another terminal.

### Script doesn't change directory

The script must be **sourced** (not executed directly). This is why it's wrapped in a function. Running `pd.sh` directly won't work – you *must* use the `pd` function in the shell's resource file.

### Permission issues with ~/.pd

The script creates a hidden file (`~/.pd` by default) to store the current directory. Ensure that this file is in a directory that's writable:

```bash
ls -la ~/.pd
```

## License

The contents of this repository are released into the public domain under the conditions of [The Unlicense](https://unlicense.org).
