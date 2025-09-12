{ config, pkgs, inputs, ...  }:

{
  imports = [
    ./programs/nvim.nix
  ];
  home.username = "kf";
  home.homeDirectory = "/home/kf";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    stackit-cli
    opentofu
    kubectl
    kubernetes-helm
    nodejs_24
    jdk21_headless
  ];
  home.shellAliases = {
    ls = "ls --color=auto";
    l = "ls -lah";
    v = "nvim";
    g = "git";
    k = "kubectl";
  };
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };
  programs.java = {
    enable = true;
    package = pkgs.jdk21_headless;
  };
  programs.go = {
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
  };
  programs.tmux = {
    enable = true;
    escapeTime = 0;
    baseIndex = 1;
    clock24 = true;
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
    ".cache/opentofu/.home-manager" = {
      text = "workaround file to create directory";
    };
  };

  programs.git = {
    enable = true;
    userName = "Kevin Schmid";
    userEmail = "schmid.kevin.manuel@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.firefox = {
    enable = true;
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

  programs.ghostty = {
    enable = true;
    settings = {
      theme = "rose-pine-dawn";
      font-family = "Cousine Nerd Font";
      font-size = 16;
      adjust-cell-height = "20%";
      window-padding-x = 16;
      window-padding-y = 16;
      clipboard-read = "allow";
      clipboard-write = "allow";
      clipboard-paste-protection = false;
      copy-on-select = "clipboard";
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

  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false; # https://github.com/nix-community/home-manager/issues/5311
    config = {
      terminal = "${pkgs.ghostty}/bin/ghostty";
      defaultWorkspace = "workspace number 1";
      gaps = {
        inner = 20;
	      smartBorders = "on";
	      smartGaps = true;
      };
      window = {
        border = 5;
	      titlebar = false;
      };
      input = {
        "*" = {
          xkb_layout = "de";
        };
      };
      output = {
        "*".bg = "/home/kf/Downloads/wallpaper.jpg center #282142";
      };

      bars = [
        {
          command = "${pkgs.waybar}/bin/waybar";
        }
      ];
    };
  };

  programs.waybar = {
    enable = true;
    settings = {
      main = {
        position = "left";
	      modules-left = [ "sway/workspaces" ];
	      modules-right = [ "clock#m" "clock#d" "clock#H" "clock#M" ];
        "clock#m" = {
          format = "{:%m}";
        };
        "clock#d" = {
          format = "{:%d}";
        };
        "clock#H" = {
          format = "{:%H}";
        };
        "clock#M" = {
          format = "{:%M}";
        };
      };
    };
    style = ''
      * {
        border: 20px;
      }
    '';
  };
}
