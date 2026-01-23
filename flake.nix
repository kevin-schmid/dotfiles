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
                git
                gnupg
                nerd-fonts.cousine
                fzf
                neovim
                yq
                ripgrep
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
                    "equinox"
                    "ghostty" 
                    "google-chrome"
                    "intellij-idea-ce"
                    "linearmouse"
                    "nimble-commander" 
                    "spotify"
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

            nix.settings.experimental-features = "nix-command flakes";
            nix.gc.automatic = true;
            nix.gc.options = "--delete-older-than 30d";
            nix.optimise.automatic = true;

# Set Git commit hash for darwin-version.
            system.configurationRevision = self.rev or self.dirtyRev or null;

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
                    NSAutomaticWindowAnimationsEnabled = false;
                    NSDocumentSaveNewDocumentsToCloud = false;
                    "com.apple.trackpad.scaling" = 3.0;
                };
                dock = {
                    autohide = true;
                    autohide-delay = 0.01;
                    autohide-time-modifier = 0.1;
                    show-recents = false;
                    tilesize = 48;
                };
                screencapture = {
                    include-date = true;
                    location = "$HOME/Pictures/";
                    show-thumbnail = false;
                    target = "clipboard";
                };
                universalaccess = {
                    reduceTransparency = true;
                };
                ".GlobalPreferences" = {
                    "com.apple.mouse.scaling" = -1.0;
                };
            };

            nixpkgs.hostPlatform = "aarch64-darwin";

            security.pam.services.sudo_local.touchIdAuth = true;

            programs.ssh.knownHosts = {
                "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
                "industrial-coreservice-vm.westeurope.cloudapp.azure.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHsMUuESYo+tlbzXJa5MtDmNx9k3JMM4yh4e9v94gveI";
            };
            services.karabiner-elements = {
                enable = true;
# https://github.com/nix-darwin/nix-darwin/issues/1041
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
        };
    in
    {
# $ darwin-rebuild build --flake .#MAC-HF3F9FNP25
        darwinConfigurations."MAC-HF3F9FNP25" = nix-darwin.lib.darwinSystem {
            modules = [ 
                configuration
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
