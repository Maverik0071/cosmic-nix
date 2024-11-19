{ 
 inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Older Version of Nixpkgs
    nixpkgs-another-version.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs.follows = "nixos-cosmic/nixpkgs-stable"; # NOTE: change "nixpkgs" to "nixpkgs-stable" to use stable NixOS release

    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
      
    home-manager = {
       url = "github:nix-community/home-manager";
      };
  
    hyprland = {
       url = "github:hyprwm/Hyprland";
  	 };
   };

  outputs = { 
  self, 
  nixpkgs, 
  nixos-cosmic, 
  home-manager, 
  hyprland, 
  ... 
  } @inputs: let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
    
    # nix flake basic config
    nixosConfigurations = {
      # NOTE: change "host" to your system's hostname
      wolvesden = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
          nixos-cosmic.nixosModules.default
          inputs.home-manager.nixosModules.default
          ./configuration.nix
        ];
      };
    };
  };
}
