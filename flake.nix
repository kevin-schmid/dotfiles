{
  description = "nix-darwin and NixOS systems with a shared Home Manager setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
    }:
    let
      homeManager = user: platformModule: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user}.imports = [
          ./home
          platformModule
        ];
      };
    in
    {
      darwinConfigurations."MAC-HF3F9FNP25" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit self; };
        modules = [
          ./hosts/work-mac
          home-manager.darwinModules.home-manager
          (homeManager "kevin.schmid" ./home/darwin)
        ];
      };

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit self; };
        modules = [
          ./hosts/desktop
          home-manager.nixosModules.home-manager
          (homeManager "kf" ./home/linux)
        ];
      };
    };
}
