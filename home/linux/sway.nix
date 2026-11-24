{
  config,
  lib,
  pkgs,
  ...
}:

let
  keys = import ../window-keys.nix;
  hyper = key: "Mod1+Mod4+Control+${key}";
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
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
          "XF86AudioRaiseVolume" = "exec ${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume" = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioMute" = "exec ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
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
          ${hyper "space"} = "focus mode_toggle";
          ${hyper "Shift+space"} = "floating toggle";
          ${hyper "f"} = "fullscreen toggle";
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
      bars = [ ]; # waybar runs as a systemd user service
    };
  };
}
