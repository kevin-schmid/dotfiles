{ config, lib, ... }:

let
  keys = import ../window-keys.nix;
  hyper = key: "Mod1+Mod4+Control+${key}";
in
{
  wayland.windowManager.sway = {
    enable = true;
    package = null; # installed by programs.sway in hosts/desktop
    config = {
      modifier = "Mod4";
      terminal = "ghostty";
      menu = "fuzzel";
      defaultWorkspace = "workspace number 1";

      keybindings =
        {
          "Mod4+space" = "exec fuzzel";
          "Mod4+Return" = "exec ghostty";
          "Mod4+q" = "kill";
          "Mod4+Shift+c" = "reload";
          "Mod4+Shift+e" = "exec swaynag -t warning -m 'Exit sway?' -B 'Exit' 'swaymsg exit'";
        }
        // lib.concatMapAttrs (key: direction: {
          ${hyper key} = "focus ${direction}";
          ${hyper "Shift+${key}"} = "move ${direction}";
        }) keys.directions
        // lib.mergeAttrsList (
          map (workspace: {
            ${hyper workspace} = "workspace number ${workspace}";
            ${hyper "Shift+${workspace}"} = "move container to workspace number ${workspace}";
          }) keys.workspaces
        )
        // {
          ${hyper keys.shrink} = "resize shrink width 50px";
          ${hyper keys.grow} = "resize grow width 50px";
          ${hyper keys.toggleSplit} = "layout toggle split";
        };

      gaps = {
        inner = 20;
        smartBorders = "on";
        smartGaps = true;
      };
      window = {
        border = 5;
        titlebar = false;
      };
      input."*".xkb_layout = "de";
      output."*".bg = "${config.home.homeDirectory}/Downloads/wallpaper.jpg center #282142";
      bars = [ { command = "waybar"; } ];
    };
  };
}
