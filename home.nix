{ config, pkgs, ... }:

{
  home.username = "kevin.schmid";
  home.homeDirectory = "/Users/kevin.schmid";
  home.stateVersion = "25.05"; # Check home-manager release before changing

  programs.home-manager.enable = true;
  home.shell.enableBashIntegration = true;
  xdg.enable = true;
  home.packages = with pkgs; [
    opentofu
    kubectl
    kubelogin
    kubelogin-oidc
    kubernetes-helm
  ];
  home.shellAliases = {
    
  };

  home.sessionVariables = {
  };

  programs.firefox = {
    enable = true;
  };

  programs.bash = {
    enable = true;
    historyControl = [ "erasedups" "ignoredups" ];
    historySize = 100000;
    historyFileSize = 100000;
    shellOptions = [ "histverify" ];
    bashrcExtra = ''
      _bash_history_sync() {
          builtin history -a # append command right away
          HISTFILESIZE=100000 # triggers resize
      }
      history() {
          _bash_history_sync 
          builtin history "$@"
      }
      PROMPT_COMMAND=_bash_history_sync
      
      tf() { 
          tofu fmt -list=false
          tofu "$@" 
      }
    '';
  };
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
    };
  };
  programs.tmux = {
    enable = true;
    clock24 = true;
    baseIndex = 1;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    shell = "${pkgs.bash}/bin/bash";
    plugins = with pkgs; [
        {
            plugin = tmuxPlugins.rose-pine;
            extraConfig = "set -g @rose_pine_variant 'dawn'";
        }

    ];
  };

  home.file = {
      ".local/bin/" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/modules/scripts";
          recursive = true;
      };
      ".cache/opentofu/.home-manager" = {
          text = "workaround file to create directory";
      };
  };

  programs.git = {
    enable = true;
    userEmail = "schmid.kevin.manuel@gmail.com";
    userName = "Kevin Schmid";
  };

  xdg.configFile."opentofu/tofurc" = {
    enable = true;
    text = ''
    plugin_cache_dir = "$XDG_CACHE_HOME/opentofu"'';
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
