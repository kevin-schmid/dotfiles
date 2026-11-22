{ lib, pkgs, ... }:

{
  imports = [
    ./aerospace.nix
    ./karabiner.nix
    ./sketchybar
  ];

  home.packages = with pkgs; [
    podman
    stackit-cli
  ];

  programs.bash.bashrcExtra = lib.mkBefore ''
    eval "$(/opt/homebrew/bin/brew shellenv)"
  '';
}
