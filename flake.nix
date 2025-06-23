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
          tmux
          nerd-fonts.cousine
          fzf
          yq
          ripgrep
          spotify
          azure-cli
          kubectl
          opentofu
        ];
      fonts.packages = [
          pkgs.nerd-fonts.cousine
      ];
      homebrew = {
        enable = true;
        taps = [];
        brews = [ "kubelogin" ];
        casks = [ "ghostty" "google-chrome" "nimble-commander" ];
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
      system.keyboard.swapLeftCommandAndLeftAlt = true;
      system.defaults = {
        NSGlobalDomain = {
          AppleShowAllExtensions = true;
          NSAutomaticPeriodSubstitutionEnabled = false;
        };
        dock = {
          autohide = true;
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
            mode.main.binding = {
                cmd-h = "focus --boundaries-action wrap-around-the-workspace left";
                cmd-j = "focus --boundaries-action wrap-around-the-workspace down";
                cmd-k = "focus --boundaries-action wrap-around-the-workspace up";
                cmd-l = "focus --boundaries-action wrap-around-the-workspace right";
                cmd-shift-h = "move left";
                cmd-shift-j = "move down";
                cmd-shift-k = "move up";
                cmd-shift-l = "move right";
                cmd-ctrl-h = "join-with left";
                cmd-ctrl-j = "join-with down";
                cmd-ctrl-k = "join-with up";
                cmd-ctrl-l = "join-with right";
                cmd-1 = "workspace 1";
                cmd-2 = "workspace 2";
                cmd-3 = "workspace 3";
                cmd-4 = "workspace 4";
                cmd-5 = "workspace 5";
                cmd-6 = "workspace 6";
                cmd-7 = "workspace 7";
                cmd-8 = "workspace 8";
                cmd-9 = "workspace 9";
                cmd-shift-1 = "move-node-to-workspace 1";
                cmd-shift-2 = "move-node-to-workspace 2";
                cmd-shift-3 = "move-node-to-workspace 3";
                cmd-shift-4 = "move-node-to-workspace 4";
                cmd-shift-5 = "move-node-to-workspace 5";
                cmd-shift-6 = "move-node-to-workspace 6";
                cmd-shift-7 = "move-node-to-workspace 7";
                cmd-shift-8 = "move-node-to-workspace 8";
                cmd-shift-9 = "move-node-to-workspace 9";
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
