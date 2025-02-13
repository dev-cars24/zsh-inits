# Zsh Configuration Documentation

## Overview
This repository contains modular Zsh configuration files for various functionalities like Git, Kubernetes, Python, and environment settings.

## Files and Their Purpose

### `colors.zsh`
- Defines color variables for use in terminal outputs.

### `env.zsh`
- Sets up environment variables like `PATH` and configurations for tools like `nvm`.

### `git.zsh`
- Contains useful Git aliases and functions:
  - `gbc` - Sorts branches by last commit date.
  - `gs` - Shows `git status`.
  - `ga` - Adds all changes.
  - `chk` - Checkout branch.
  - `mas` - Checkout master and pull latest changes.
  - `jp` - Function to push changes with interactive commit.

### `k8s.zsh`
- Kubernetes-related aliases:
  - `kl` - View pod logs.
  - `kgp` - List all pods.
  - `kd` - Describe pod.

### `openInIntelliJ.zsh`
- Functionality to navigate repositories interactively and open them in IntelliJ IDEA.
- Highlights already opened projects.

### `python.zsh`
- Python-related aliases:
  - `freeze_req` - Freeze installed packages into `requirements.txt`.
  - `req_i` - Install packages from `requirements.txt`.

### `utils.zsh`
- Utility functions for various use cases.

## Usage
1. Clone the repository:
   ```sh
   git clone https://github.com/dev-cars24/zsh-inits.git
   ```
2. Source the required files in `~/.zshrc`:
   ```sh
   for file in ~/.ZSH/*.zsh; do source "$file"; done
   ```

## Contributions
Feel free to contribute by adding more aliases or improving the structure.

## License
This project is open-source and available under the MIT License.
