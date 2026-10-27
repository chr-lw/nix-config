# nix-config

This is my Nix config. It's still in development, and I refactor all the time.

So far, I have four hosts: a ThinkPad and two servers, as well as a workstation/gaming pc running CachyOS with the Nix package manager installed.

## Migrating from configuration.nix to flakes

1. Pull the repo into the `/home/john/projects/nix-config` directory.
2. Backup the old `/etc/nixos`:
```bash
sudo mv /etc/nixos /etc/nixos.bak
```
3. Symlink `/etc/nixos` to the repo directory:
```bash
sudo ln -s /home/john/projects/nix-config /etc/nixos
```
4. Build from this directory. This makes the rebuild commands a bit shorter:

```bash
cd /etc/nixos
sudo nixos-rebuild switch --flake .#thinkpad
```
