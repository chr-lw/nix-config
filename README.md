# nix-config

This is my Nix config. It's still in development. I am in the middle of migrating my laptop from the standard configuration.nix setup to flakes and home-manager while upgrading from 25.11 to 26.05.

So far, I have four hosts: a ThinkPad and two servers, as well as a workstation/gaming pc running CachyOS with the Nix package manager installed.

The small bit of documentation on this page is purely for my own benefit. You are free to clone or fork the repo or just copy/paste any code you find useful.

## Migrating from configuration.nix to flakes

1. Pull the repo into the `/home/john/projects/nix-config` directory.
2. Backup the old `/etc/nixos`:
```sudo mv /etc/nixos /etc/nixos.bak```
3. Symlink to the repo directory:
```sudo ln -s /home/john/projects/nix-config /etc/nixos```
4. Build from this directory. This makes the rebuild commands a bit shorter:

```cd /etc/nixos
sudo nixos-rebuild switch --flake .#thinkpad```
