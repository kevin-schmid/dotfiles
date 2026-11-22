{ pkgs, ... }:

let
  rebuild = if pkgs.stdenv.isDarwin then "darwin-rebuild" else "nixos-rebuild";
in
{
  home.shell.enableBashIntegration = true;
  home.shellAliases = {
    ls = "ls --color=auto";
    l = "ls -lah";
    v = "nvim";
    g = "git";
    k = "kubectl";
    nix-rebuild = "sudo ${rebuild} switch --flake ~/.config/nix";
  };

  programs.bash = {
    enable = true;
    historyControl = [
      "erasedups"
      "ignoredups"
    ];
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
    settings.add_newline = false;
  };
}
