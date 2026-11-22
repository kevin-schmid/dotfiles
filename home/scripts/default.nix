{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "cb";
      text = builtins.readFile ./cb;
    })
  ];
}
