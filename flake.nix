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
          vim
          home-manager
          neovim
          nerd-fonts.cousine
          fzf
          yq
          ripgrep
          azure-cli
          podman
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
        ls = "ls --color=auto";
        l = "ls -lah";
        v = "nvim";
        g = "git";
        k = "kubectl";
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

      # top bar
      services.sketchybar.enable = true;
      services.sketchybar.config = ''
PLUGIN_DIR="/Users/kevin.schmid/.config/sketchybar/plugins"
sketchybar --bar position=top height=40 blur_radius=30 color=0xFF000000
sketchybar --default \
  padding_left=5 \
  padding_right=5 \
  icon.font="Cousine Nerd Font:Bold:17.0" \
  label.font="Cousine Nerd Font:Bold:14.0" \
  icon.color=0xffffffff \
  label.color=0xffffffff \
  icon.padding_left=4 \
  icon.padding_right=4 \
  label.padding_left=4 \
  label.padding_right=4
sketchybar --add event aerospace_workspace_change
for sid in $(aerospace list-workspaces --all); do
    sketchybar --add item space.$sid left \
        --subscribe space.$sid aerospace_workspace_change \
        --set space.$sid \
        label="$sid" \
        click_script="aerospace workspace $sid" \
        script="$PLUGIN_DIR/aerospace.sh $sid"
done
sketchybar --add item chevron left \
           --set chevron label.drawing=off \
           --add item front_app left \
           --set front_app icon.drawing=off script="$PLUGIN_DIR/front_app.sh" \
           --subscribe front_app front_app_switched
sketchybar --add item clock right \
           --set clock update_freq=10 icon=  script="$PLUGIN_DIR/clock.sh" \
           --add item volume right \
           --set volume script="$PLUGIN_DIR/volume.sh" \
           --subscribe volume volume_change \
           --add item battery right \
           --set battery update_freq=120 script="$PLUGIN_DIR/battery.sh" \
           --subscribe battery system_woke power_source_change
sketchybar --update
      '';
      services.jankyborders.enable = true;
      services.jankyborders.hidpi = true;
      services.jankyborders.active_color = "gradient(top_left=0xFF6EC3B4,bottom_right=0xFFE1786E)";
      services.jankyborders.inactive_color = "0x006EC3B4";
      # Window manager
      services.aerospace = {
        enable = true;
        settings = {
            exec-on-workspace-change = [
                "/bin/bash"
                "-c"
                "sketchybar --trigger aerospace_workspace_changed FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
            ];
            gaps = {
                outer.top        = 16;
                outer.left       = 16;
                outer.bottom     = 16;
                outer.right      = 16;
                inner.horizontal = 16;
                inner.vertical   = 16;
            };
            on-window-detected = [
                {
                    check-further-callbacks = true;
                    "if".window-title-regex-substring = "Launch";
                    run = [ "layout floating" ];
                }
            ];
            mode.main.binding = {
                alt-h = "focus --boundaries-action wrap-around-the-workspace left";
                alt-j = "focus --boundaries-action wrap-around-the-workspace down";
                alt-k = "focus --boundaries-action wrap-around-the-workspace up";
                alt-l = "focus --boundaries-action wrap-around-the-workspace right";
                alt-shift-h = "move left";
                alt-shift-j = "move down";
                alt-shift-k = "move up";
                alt-shift-l = "move right";
                alt-ctrl-h = "join-with left";
                alt-ctrl-j = "join-with down";
                alt-ctrl-k = "join-with up";
                alt-ctrl-l = "join-with right";
                alt-a = "workspace 1";
                alt-s = "workspace 2";
                alt-d = "workspace 3";
                alt-f = "workspace 4";
                alt-g = "workspace 5";
                alt-shift-a = "move-node-to-workspace 1";
                alt-shift-s = "move-node-to-workspace 2";
                alt-shift-d = "move-node-to-workspace 3";
                alt-shift-f = "move-node-to-workspace 4";
                alt-shift-g = "move-node-to-workspace 5";
            };
        };
      };
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
