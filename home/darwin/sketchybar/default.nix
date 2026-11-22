{ config, pkgs, ... }:

{
  programs.sketchybar = {
    enable = true;
    extraPackages = with pkgs; [
      aerospace
      jq
    ];
    config = ''
      PLUGIN_DIR="${./plugins}"

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
        --subscribe front_app front_app_switched aerospace_workspace_change

      separator() {
        sketchybar --add item "separator.$1" right \
          --set "separator.$1" icon.drawing=off label="•" label.color=0x66ffffff
      }

      sketchybar --add item clock right \
        --set clock update_freq=1 icon= icon.font="Cousine Nerd Font:Bold:14.0" \
          script="$PLUGIN_DIR/clock.sh" click_script="$PLUGIN_DIR/calendar.sh" \
          popup.align=right popup.background.color=0xF0000000 popup.background.corner_radius=10 \
          popup.background.border_width=1 popup.background.border_color=0xFFE1786E \
        --subscribe clock mouse.exited.global front_app_switched
      separator 1
      sketchybar --add item volume right \
        --set volume label.width=36 label.align=right icon.width=22 icon.align=left script="$PLUGIN_DIR/volume.sh" \
        --subscribe volume volume_change
      separator 2
      sketchybar --add item battery right \
        --set battery label.width=36 label.align=right icon.width=27 icon.align=left update_freq=120 script="$PLUGIN_DIR/battery.sh" \
        --subscribe battery system_woke power_source_change
      separator 3
      sketchybar --add item ram right \
        --set ram label.width=36 label.align=right update_freq=5 icon=󰍛 script="$PLUGIN_DIR/ram.sh"
      separator 4
      sketchybar --add item cpu right \
        --set cpu label.width=36 label.align=right update_freq=2 icon= script="$PLUGIN_DIR/cpu.sh"
      separator 5
      sketchybar --add item flake_age right \
        --set flake_age label.width=36 label.align=right update_freq=3600 icon= script="$PLUGIN_DIR/flake_age.sh"

      sketchybar --update
    '';
  };

  launchd.agents.sketchybar.config.EnvironmentVariables = {
    XDG_CONFIG_HOME = config.xdg.configHome;
    XDG_CACHE_HOME = config.xdg.cacheHome;
    XDG_DATA_HOME = config.xdg.dataHome;
    XDG_STATE_HOME = config.xdg.stateHome;
  };

  xdg.configFile."sketchybar/sketchybarrc".onChange = ''
    /bin/launchctl kickstart -k "gui/$(id -u)/org.nix-community.home.sketchybar" || true
  '';
}
