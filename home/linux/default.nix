{ pkgs, ... }:

{
  imports = [
    ./sway.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    ghostty
    gcc # nvim-treesitter compiles its parsers
  ];
  home.sessionVariables.MOZ_ENABLE_WAYLAND = "1";

  programs.fuzzel = {
    enable = true;
    settings.main.font = "Cousine Nerd Font:size=14";
  };

  programs.firefox = {
    configPath = ".mozilla/firefox";
    languagePacks = [ "en-US" ];
    policies = {
      AppAutoUpdate = false;
      BackgroundAppUpdate = false;
      DisableFirefoxStudies = true;
      DisableFirefoxScreenshots = true;
      DisableMasterPasswordCreation = true;
      DisableSetDesktopBackground = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFormHistory = true;
      DisablePasswordReveal = true;
      DontCheckDefaultBrowser = true;
      OfferToSaveLogins = false;
    };
    profiles.default.search = {
      force = true;
      default = "ecosia";
      privateDefault = "ecosia";
    };
  };

  home.pointerCursor = {
    enable = true;
    package = pkgs.phinger-cursors;
    name = "phinger-cursors-light";
    size = 24;
    dotIcons.enable = true;
    gtk.enable = true;
    sway.enable = true;
    x11.enable = true;
  };
}
