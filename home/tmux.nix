{ lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    baseIndex = 1;
    keyMode = "vi";
    escapeTime = 10;
    mouse = true;
    newSession = false;
    shell = "${pkgs.bash}/bin/bash";
    terminal = "tmux-256color";
    plugins = [
      {
        plugin = pkgs.tmuxPlugins.rose-pine;
        extraConfig = ''
          set -g @rose_pine_variant "dawn"
          set -g @rose_pine_bar_bg_disable 'on'
          set -g @rose_pine_bar_bg_disabled_color_option 'default'
        '';
      }
    ];
    extraConfig = ''
      ${lib.concatMapStrings
        ({ n, s }: ''
          bind -n M-${n} run-shell -b "tmux select-window -t :${n} 2>/dev/null || tmux new-window -t :${n}"
          bind -n 'M-${s}' if -F '#{!=:#{window_index},${n}}' 'run-shell -b "tmux join-pane -d -t :${n} 2>/dev/null || tmux break-pane -d -t :${n}"'
        '')
        [
          { n = "1"; s = "!"; }
          { n = "2"; s = "@"; }
          { n = "3"; s = "#"; }
          { n = "4"; s = "$"; }
          { n = "5"; s = "%"; }
          { n = "6"; s = "^"; }
          { n = "7"; s = "&"; }
          { n = "8"; s = "*"; }
          { n = "9"; s = "("; }
        ]
      }

      bind-key -n M-h if-shell -F '#{pane_at_left}'   'previous-window' 'select-pane -L'
      bind-key -n M-l if-shell -F '#{pane_at_right}'  'next-window'     'select-pane -R'
      bind-key -n M-j if-shell -F '#{pane_at_bottom}' 'run-shell true'  'select-pane -D'
      bind-key -n M-k if-shell -F '#{pane_at_top}'    'run-shell true'  'select-pane -U'

      # A pane spanning the full width/height has no neighbour in that
      # direction, so re-arrange the window layout instead of swapping.
      bind-key -n M-H if -F '#{pane_at_left}' {
        if -F '#{pane_at_right}' {
          select-layout even-horizontal
          if -F '#{pane_at_left}' 'run-shell true' 'swap-pane -d -t "{left-of}"'
        }
      } {
        swap-pane -d -t '{left-of}'
      }

      bind-key -n M-L if -F '#{pane_at_right}' {
        if -F '#{pane_at_left}' {
          select-layout even-horizontal
          if -F '#{pane_at_right}' 'run-shell true' 'swap-pane -d -t "{right-of}"'
        }
      } {
        swap-pane -d -t '{right-of}'
      }

      bind-key -n M-J if -F '#{pane_at_bottom}' {
        if -F '#{pane_at_top}' {
          select-layout even-vertical
          if -F '#{pane_at_bottom}' 'run-shell true' 'swap-pane -d -t "{down-of}"'
        }
      } {
        swap-pane -d -t '{down-of}'
      }

      bind-key -n M-K if -F '#{pane_at_top}' {
        if -F '#{pane_at_bottom}' {
          select-layout even-vertical
          if -F '#{pane_at_top}' 'run-shell true' 'swap-pane -d -t "{up-of}"'
        }
      } {
        swap-pane -d -t '{up-of}'
      }

      set-option -g status 2
      set-option -g status-format[1] ""
      set-option -g status-position top
      set-option -g status-justify absolute-centre
      set-option -g window-status-separator " • "
      set-option -g window-status-format " #W "
      set-option -g window-status-current-format " #W "
      set-option -g status-left-length 100
      set-option -g status-right-length 100
      set-option -g status-left '#[fg=#b4637a] #(kubectl config current-context)'
    '';
  };
}
