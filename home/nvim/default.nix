{ config, pkgs, ... }:

{
  # Out of store: lazy.nvim writes lazy-lock.json back into the repo.
  xdg.configFile.nvim.source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/home/nvim/config";

  home.packages = with pkgs; [
    bash-language-server
    dockerfile-language-server
    gopls
    helm-ls
    vscode-langservers-extracted
    terraform-ls
    yaml-language-server
    lua-language-server
    stylua
  ];
}
