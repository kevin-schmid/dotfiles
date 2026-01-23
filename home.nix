{ config, pkgs, ... }:

{
    home.username = "kevin.schmid";
    home.homeDirectory = "/Users/kevin.schmid";
    home.stateVersion = "25.05"; # Check home-manager release before changing

    programs.home-manager.enable = true;
    home.shell.enableBashIntegration = true;
    xdg.enable = true;
    home.packages = with pkgs; [
        (azure-cli.withExtensions [ azure-cli.extensions.aks-preview azure-cli.extensions.quota ])
        stackit-cli
        opentofu
        podman
        kubectl
        kubelogin-oidc
        kubernetes-helm
        jdk21_headless
        maven
    ];
    home.shellAliases = {
        ls = "ls --color=auto";
        l = "ls -lah";
        v = "nvim";
        g = "git";
        k = "kubectl";
    };

    home.sessionVariables = {
    };

    programs.firefox = {
        enable = true;
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
      }'';
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
    escapeTime = 0;
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
    settings.user = {
        email = "schmid.kevin.manuel@gmail.com";
        name = "Kevin Schmid";
    };
  };
      # Window manager
  programs.aerospace = {
      enable = true;
      launchd.enable = true;
      settings = {
          after-startup-command = ["exec-and-forget ${pkgs.sketchybar}/bin/sketchybar --reload"];
          exec-on-workspace-change = ["/bin/bash" "-c" "${pkgs.sketchybar}/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"];
          gaps = {
              outer.top        = 16;
              outer.left       = 16;
              outer.bottom     = 16;
              outer.right      = 16;
              inner.horizontal = 16;
              inner.vertical   = 16;
          };
          key-mapping.key-notation-to-key-code = {
              mminus = "slash";
              mplus = "rightSquareBracket";
              moe = "semicolon";
              mae = "quote";
              mue = "leftSquareBracket";
              mhash = "backslash";
              msmaller = "backtick";
              mbacktick = "equal";
              msharps = "minus";
              mcircumflex = "sectionSign";
          };
          mode.main.binding = {
              alt-cmd-ctrl-h = "focus --boundaries-action wrap-around-the-workspace left";
              alt-cmd-ctrl-j = "focus --boundaries-action wrap-around-the-workspace down";
              alt-cmd-ctrl-k = "focus --boundaries-action wrap-around-the-workspace up";
              alt-cmd-ctrl-l = "focus --boundaries-action wrap-around-the-workspace right";
              alt-cmd-ctrl-shift-h = "move left";
              alt-cmd-ctrl-shift-j = "move down";
              alt-cmd-ctrl-shift-k = "move up";
              alt-cmd-ctrl-shift-l = "move right";
              alt-cmd-ctrl-1 = "workspace 1";
              alt-cmd-ctrl-2 = "workspace 2";
              alt-cmd-ctrl-3 = "workspace 3";
              alt-cmd-ctrl-4 = "workspace 4";
              alt-cmd-ctrl-5 = "workspace 5";
              alt-cmd-ctrl-shift-1 = "move-node-to-workspace 1";
              alt-cmd-ctrl-shift-2 = "move-node-to-workspace 2";
              alt-cmd-ctrl-shift-3 = "move-node-to-workspace 3";
              alt-cmd-ctrl-shift-4 = "move-node-to-workspace 4";
              alt-cmd-ctrl-shift-5 = "move-node-to-workspace 5";
              alt-cmd-ctrl-mminus = "resize smart -50";
              alt-cmd-ctrl-mplus = "resize smart +50";
              alt-cmd-ctrl-v = "layout tiles horizontal vertical";
          };
      };
  };

  programs.sketchybar = {
    enable = true;
    extraPackages = [
        pkgs.aerospace
    ];
    config = ''
PLUGIN_DIR="/Users/kevin.schmid/.config/sketchybar/plugins"
${pkgs.sketchybar}/bin/sketchybar --bar position=top height=40 blur_radius=30 color=0xFF000000
${pkgs.sketchybar}/bin/sketchybar --default \
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
    ${pkgs.sketchybar}/bin/sketchybar --add item space.$sid left \
        --subscribe space.$sid aerospace_workspace_change \
        --set space.$sid \
        label="$sid" \
        click_script="aerospace workspace $sid" \
        script="$PLUGIN_DIR/aerospace.sh $sid"
done
${pkgs.sketchybar}/bin/sketchybar --add item chevron left \
           --set chevron label.drawing=off \
           --add item front_app left \
           --set front_app icon.drawing=off script="$PLUGIN_DIR/front_app.sh" \
           --subscribe front_app front_app_switched
${pkgs.sketchybar}/bin/sketchybar --add item clock right \
           --set clock update_freq=10 icon=  script="$PLUGIN_DIR/clock.sh" \
           --add item volume right \
           --set volume script="$PLUGIN_DIR/volume.sh" \
           --subscribe volume volume_change \
           --add item battery right \
           --set battery update_freq=120 script="$PLUGIN_DIR/battery.sh" \
           --subscribe battery system_woke power_source_change
${pkgs.sketchybar}/bin/sketchybar --update'';
  };

  xdg.configFile."opentofu/tofurc" = {
    enable = true;
    text = ''
    plugin_cache_dir = "$XDG_CACHE_HOME/opentofu"'';
  };

  xdg.configFile."karabiner/karabiner.json" = {
    enable = true;
    text = ''
    {
      "global": {
        "check_for_updates_on_startup": false,
        "show_in_menu_bar": false,
        "show_profile_name_in_menu_bar": false
      },
      "profiles": [{
        "name": "default",
        "selected": true,
        "complex_modifications": {
          "rules": [
            {
              "description": "Capslock to HYPER",
              "manipulators": [
              {
                  "from": {
                    "key_code": "caps_lock",
                    "modifiers": {
                      "optional": ["any"]
                    }
                  },
                  "to": [
                    {
                      "key_code": "left_command",
                      "modifiers": ["left_control", "left_option"]
                    }
                  ],
                  "to_if_alone": [
                    {
                      "key_code": "escape"
                    }
                  ],
                  "type": "basic"
              }
              ]
            }
          ]
        }
      }]
    }'';
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
