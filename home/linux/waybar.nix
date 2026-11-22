{
  programs.waybar = {
    enable = true;
    settings.main = {
      position = "left";
      modules-left = [ "sway/workspaces" ];
      modules-right = [
        "clock#m"
        "clock#d"
        "clock#H"
        "clock#M"
      ];
      "clock#m".format = "{:%m}";
      "clock#d".format = "{:%d}";
      "clock#H".format = "{:%H}";
      "clock#M".format = "{:%M}";
    };
    style = ''
      * {
        border: 20px;
      }
    '';
  };
}
