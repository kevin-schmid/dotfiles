{ pkgs, self, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 30d";
  nix.optimise.automatic = true;

  environment.systemPackages = with pkgs; [
    git
    gnupg
    fzf
    ripgrep
    yq
    tree
    parallel
    neovim
    tree-sitter
  ];

  fonts.packages = [ pkgs.nerd-fonts.cousine ];

  programs.ssh.knownHosts."github.com".publicKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";

  system.configurationRevision = self.rev or self.dirtyRev or null;
}
