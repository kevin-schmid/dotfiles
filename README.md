# nix

nix-darwin (work Mac) and NixOS (desktop) from one flake, with a shared Home Manager config.
Clone to `~/.config/nix`.

## Apply

```sh
nix-rebuild                         # after the first switch
nix flake update && nix-rebuild     # update everything
```

First switch: `sudo darwin-rebuild switch --flake ~/.config/nix` or `sudo nixos-rebuild switch --flake ~/.config/nix`.

## Layout

```
hosts/common.nix     system config for both
hosts/work-mac/      nix-darwin
hosts/desktop/       NixOS
home/                Home Manager, shared
home/darwin/         macOS only
home/linux/          Linux only
home/window-keys.nix window manager keys, used by AeroSpace and Sway
```

## Keys

- Caps Lock: tap for Esc, hold for hyper
- Hyper + `hjkl` focus, + Shift move window
- Hyper + `1-5` workspace, + Shift send window there
- Hyper + `-` / `+` resize, `v` toggle split
- Super + Space app launcher
