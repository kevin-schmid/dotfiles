{
  description = "nix-darwin soon to be including NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      nixpkgs.config.allowUnfree = true;
      environment.systemPackages = with pkgs; [
          gnupg
          nerd-fonts.cousine
          fzf
          neovim
          yq
          ripgrep
          podman
          podman-compose
          devenv
        ];
      fonts.packages = [
          pkgs.nerd-fonts.cousine
      ];
      homebrew = {
        enable = true;
        taps = [];
        brews = [
          "dive"
        ];
        casks = [
          "ghostty" 
          "google-chrome" 
          "nimble-commander" 
          "spotify"
          "linearmouse"
          "intellij-idea-ce"
        ];
        onActivation = { 
            cleanup = "zap";
            autoUpdate = true;
            upgrade = true;
        };
      };

      system.primaryUser = "kevin.schmid";
      users.knownUsers = [ "kevin.schmid" ];
      users.users."kevin.schmid" = {
        uid = 502;
        name = "kevin.schmid";
        home = "/Users/kevin.schmid";
        shell = pkgs.bash;
      };
      environment.shellAliases = {
        nixrebuild = "sudo darwin-rebuild switch --flake ~/.config/nix";
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;
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
          NSDocumentSaveNewDocumentsToCloud = false;
        };
        dock = {
          autohide = true;
          autohide-delay = 0.01;
          autohide-time-modifier = 0.1;
          show-recents = false;
          tilesize = 48;
        };
        ".GlobalPreferences" = {
            "com.apple.mouse.scaling" = -1.0;
        };
      };

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # TouchID for sudo auth
      security.pam.services.sudo_local.touchIdAuth = true;

      programs.ssh.knownHosts = {
        "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };

      services.jankyborders.enable = true;
      services.jankyborders.hidpi = true;
      services.jankyborders.active_color = "gradient(top_left=0xFF6EC3B4,bottom_right=0xFFE1786E)";
      services.jankyborders.inactive_color = "0x006EC3B4";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#MAC-HF3F9FNP25
    darwinConfigurations."MAC-HF3F9FNP25" = nix-darwin.lib.darwinSystem {
      modules = [ configuration
        
      home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users."kevin.schmid" = ./home.nix;
      }
      ];
    };
  };
}
