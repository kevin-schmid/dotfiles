{ pkgs, ... }:

{
  imports = [
    ./shell.nix
    ./tmux.nix
    ./nvim
    ./scripts
  ];

  home.stateVersion = "25.05"; # Check home-manager release before changing
  programs.home-manager.enable = true;
  xdg.enable = true;

  home.packages = with pkgs; [
    (azure-cli.withExtensions [
      azure-cli.extensions.aks-preview
      azure-cli.extensions.quota
    ])
    opentofu
    kubectl
    kubelogin-oidc
    kubernetes-helm
    argocd
    nodejs_24
    maven
    syft
    oras
    skopeo
    cosign
    gitsign
    devenv
    bruno
  ];

  programs.java = {
    enable = true;
    package = pkgs.jdk21_headless;
  };
  programs.go.enable = true;
  programs.firefox.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "Kevin Schmid";
      user.email = "schmid.kevin.manuel@gmail.com";
      init.defaultBranch = "main";
    };
  };

  xdg.configFile."ghostty/config".source = ./ghostty/config;

  programs.k9s = {
    enable = true;
    settings.k9s.ui.skin = "rose-pine-dawn";
    skins.rose-pine-dawn = ./k9s/rose-pine-dawn.yaml;
    aliases = {
      dp = "deployments";
      sec = "v1/secrets";
      jo = "jobs";
      cr = "clusterroles";
      crb = "clusterrolebindings";
      ro = "roles";
      rb = "rolebindings";
      np = "networkpolicies";
    };
  };

  xdg.configFile."opentofu/tofurc".text = ''
    plugin_cache_dir = "$XDG_CACHE_HOME/opentofu"
  '';
  home.file.".cache/opentofu/.home-manager".text = "workaround file to create directory";
}
