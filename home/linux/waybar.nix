{ config, pkgs, ... }:

let
  flakeAge = pkgs.writeShellScript "waybar-flake-age" ''
    updated=$(${pkgs.jq}/bin/jq -r '.nodes.nixpkgs.locked.lastModified' "${config.home.homeDirectory}/.config/nix/flake.lock")
    days=$(( ($(date +%s) - updated) / 86400 ))
    class=""
    [ "$days" -gt 30 ] && class="stale"
    printf '{"text":"%sd","class":"%s"}\n' "$days" "$class"
  '';

  separator = n: {
    "custom/sep#${toString n}" = {
      format = "•";
      tooltip = false;
    };
  };
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.main = {
      position = "left";
      width = 50;
      modules-left = [ "sway/workspaces" ];
      modules-right = [
        "custom/flake-age"
        "custom/sep#1"
        "cpu"
        "custom/sep#2"
        "memory"
        "custom/sep#3"
        "pulseaudio"
        "custom/sep#4"
        "clock"
      ];

      "sway/workspaces" = {
        format = "{name}";
        disable-scroll = true;
        persistent-workspaces = {
          "1" = [ ];
          "2" = [ ];
          "3" = [ ];
          "4" = [ ];
          "5" = [ ];
        };
      };
      "custom/flake-age" = {
        exec = "${flakeAge}";
        return-type = "json";
        interval = 3600;
        format = "\n{}";
        tooltip = false;
      };
      cpu = {
        interval = 2;
        format = "\n{usage}%";
      };
      memory = {
        interval = 5;
        format = "󰍛\n{percentage}%";
      };
      pulseaudio = {
        format = "{icon}\n{volume}%";
        format-muted = "󰖁\nmute";
        format-icons.default = [
          "󰕿"
          "󰖀"
          "󰕾"
        ];
        on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
      };
      clock = {
        format = "{:%d\n%m\n\n%H\n%M}";
        tooltip-format = "<tt>{calendar}</tt>";
      };
    }
    // separator 1
    // separator 2
    // separator 3
    // separator 4;

    style = ''
      * {
        font-family: "Cousine Nerd Font";
        font-weight: bold;
        font-size: 14px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background: #000000;
        color: #ffffff;
      }

      #workspaces button {
        padding: 6px 0;
        color: #ffffff;
        background: transparent;
      }

      #workspaces button.focused {
        color: #e1786e;
      }

      #workspaces button:hover {
        background: rgba(255, 255, 255, 0.1);
        box-shadow: none;
        text-shadow: none;
      }

      #custom-flake-age,
      #cpu,
      #memory,
      #pulseaudio,
      #clock {
        padding: 6px 0;
      }

      #custom-flake-age.stale {
        color: #ea9d34;
      }

      #custom-sep {
        color: rgba(255, 255, 255, 0.4);
      }
    '';
  };
}
