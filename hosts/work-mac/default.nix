{ pkgs, ... }:

{
  imports = [ ../common.nix ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;

  system.primaryUser = "kevin.schmid";
  users.knownUsers = [ "kevin.schmid" ];
  users.users."kevin.schmid" = {
    uid = 502;
    home = "/Users/kevin.schmid";
    shell = pkgs.bash;
  };

  environment.systemPackages = [ pkgs.lima ];

  homebrew = {
    enable = true;
    global.brewfile = true;
    brews = [
      "dive"
      "opencode"
    ];
    casks = [
      "equinox"
      "dbeaver-community"
      "discord"
      "ghostty"
      "google-chrome"
      "intellij-idea-ce"
      "linearmouse"
      "spotify"
      "windows-app"
    ];
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  programs.ssh.knownHosts."industrial-coreservice-vm.westeurope.cloudapp.azure.com".publicKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHsMUuESYo+tlbzXJa5MtDmNx9k3JMM4yh4e9v94gveI";

  services.karabiner-elements = {
    enable = true;
    package = pkgs.karabiner-elements.overrideAttrs (old: {
      version = "14.13.0";
      src = pkgs.fetchurl {
        inherit (old.src) url;
        hash = "sha256-gmJwoht/Tfm5qMecmq1N6PSAIfWOqsvuHU8VDJY8bLw=";
      };
      dontFixup = true;
    });
  };

  services.jankyborders = {
    enable = true;
    hidpi = true;
    width = 8.0;
    active_color = "0xFFE1786E";
    inactive_color = "0xFF000000";
  };

  system.startup.chime = false;
  system.keyboard.enableKeyMapping = true;
  system.keyboard.swapLeftCommandAndLeftAlt = false;
  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticInlinePredictionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticWindowAnimationsEnabled = false;
      NSDocumentSaveNewDocumentsToCloud = false;
      "com.apple.trackpad.scaling" = 2.0;
    };
    dock = {
      autohide = true;
      autohide-delay = 0.01;
      autohide-time-modifier = 0.1;
      show-recents = false;
      tilesize = 48;
    };
    finder.QuitMenuItem = true;
    screencapture = {
      include-date = true;
      location = "$HOME/Pictures/";
      show-thumbnail = false;
      target = "clipboard";
    };
    universalaccess.reduceTransparency = true;
    ".GlobalPreferences"."com.apple.mouse.scaling" = -1.0;
  };
}
