{ config, pkgs, ... }:

{
  home.username = "kevin.schmid";
  home.homeDirectory = "/Users/kevin.schmid";
  home.stateVersion = "25.05"; # Check home-manager release before changing

  programs.home-manager.enable = true;

  programs.firefox = {
    enable = true;
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
PS1="> "
    '';
  };

  programs.git = {
    enable = true;
    userEmail = "schmid.kevin.manuel@gmail.com";
    userName = "Kevin Schmid";
  };
  
  xdg.configFile.sketchybar = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/modules/sketchybar/config";
    recursive = true;
    force = true;
  };

  xdg.configFile.ghostty = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/modules/ghostty/config";
    recursive = true;
    force = true;
  };

  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/modules/nvim/config";
    recursive = true;
    force = true;
  };
}
