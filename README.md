# my dotfiles

Welcome to my $HOME. This repository contains my personal configuration files for Linux and macOS, and a crazy powerful simple methodology to manage them, making setup on new machines, and keeping them in sync on existing ones, very easy.

- The only requirement is Git, and if you're here, then that's obviously covered! ;-) 

## What is This?

This repository serves two purposes:

1. **A Methodology**:
    - A bare Git repository approach for managing dotfiles—no symlinks, no extra tooling, just Git. This methodology is universal and works with anyone's configuration files.

3. **My Implementation**:
    - My personal configuration files managed using this methodology (cross-platform bash/zsh, vim, tmux, Starship prompt, XDG compliance, and modern CLI tool integration).

## Documentation

📖 **[METHODOLOGY.md](docs/METHODOLOGY.md)** - Learn the bare repository approach for managing dotfiles
- How the methodology works
- Setting up your own dotfiles from scratch
- Daily usage workflows
- Troubleshooting

🔧 **[IMPLEMENTATION.md](docs/IMPLEMENTATION.md)** - My specific dotfiles configuration
- What's included in my setup
- Installing my dotfiles (as-is or forked)
- Post-installation setup
- Architecture and platform details

## Quick Start

**Want to learn the methodology with your own dotfiles?**
- → Read [METHODOLOGY.md](docs/METHODOLOGY.md)
- Jump to Setup from Scratch
  - *Best for starting from zero with your existing configs*

**Want to use my dotfiles as-is?**
- → Read [IMPLEMENTATION.md](docs/IMPLEMENTATION.md)
- - Jump to Install As-Is
  - *This is where I go anytime I setup a new machine*

**Want to fork and customize my dotfiles?**
- → Read [IMPLEMENTATION.md](docs/IMPLEMENTATION.md)
- - Jump to Fork and Customize
  - *Start with my setup, make it yours*

---

## Security Considerations

**⚠️ Critical:** Always review files before adding them to your dotfiles repository. Never commit:
- Passwords, API keys, tokens
- Private keys (SSH, GPG)
- Personal information (PII)
- Work credentials
- Browser data

**Best Practices:**
1. Always review files before `dotfiles add`
2. Use `~/.gitignore` to block sensitive files (see example in this repo)
3. Use environment variables for secrets, not tracked files
4. Consider using `git-secrets` or pre-commit hooks

**For complete security guidelines, including `.gitignore` setup and removing accidentally committed secrets, see [METHODOLOGY.md - Security Considerations](docs/METHODOLOGY.md#security-considerations)**

---

## References

1. **Original Methodology:** [StreakyCobra on Hacker News](https://news.ycombinator.com/item?id=11070797#11071754) — The elegant bare repository approach that inspired this setup.
> "No extra tooling, no symlinks, files are tracked on a version control system, you can use different branches for different computers, you can replicate your configuration easily on new installation." — [StreakyCobra on HN](https://news.ycombinator.com/item?id=11070797#11071754)


2. **Atlassian Tutorial:** [The best way to store your dotfiles](https://www.atlassian.com/git/tutorials/dotfiles) — Comprehensive guide to this methodology.

---

## Need Help?

If you run into issues not covered in the documentation, feel free to open an issue on GitHub. When reporting problems, please include:
- Your OS and version
- Your shell (bash/zsh) and version
- The specific error message
- What you were trying to do
