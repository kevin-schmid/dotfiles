{ lib, pkgs, ... }:

let
  keys = import ../window-keys.nix;
  hyper = key: "alt-cmd-ctrl-${key}";

  germanKeys = {
    minus = "mminus";
    plus = "mplus";
  };
  germanKey = key: germanKeys.${key} or key;
in
{
  programs.aerospace = {
    enable = true;
    launchd.enable = true;
    settings = {
      after-startup-command = [ "exec-and-forget ${pkgs.sketchybar}/bin/sketchybar --reload" ];
      exec-on-workspace-change = [
        "/bin/bash"
        "-c"
        "${pkgs.sketchybar}/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
      ];
      workspace-to-monitor-force-assignment = {
        "1" = "secondary";
        "2" = "secondary";
      };
      gaps = {
        outer.top = [
          { monitor.secondary = 48; }
          16
        ];
        outer.left = 16;
        outer.bottom = 16;
        outer.right = 16;
        inner.horizontal = 16;
        inner.vertical = 16;
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
      mode.main.binding =
        lib.concatMapAttrs (key: direction: {
          ${hyper key} = "focus --boundaries-action wrap-around-the-workspace ${direction}";
          ${hyper "shift-${key}"} = "move ${direction}";
        }) keys.directions
        // lib.mergeAttrsList (
          map (workspace: {
            ${hyper workspace} = "workspace ${workspace}";
            ${hyper "shift-${workspace}"} = "move-node-to-workspace ${workspace}";
          }) keys.workspaces
        )
        // {
          ${hyper (germanKey keys.shrink)} = "resize smart -50";
          ${hyper (germanKey keys.grow)} = "resize smart +50";
          ${hyper keys.toggleSplit} = "layout tiles horizontal vertical";
        };
    };
  };
}
