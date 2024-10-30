{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, poetry2nix }:
    let
      inherit (nixpkgs) lib;
      inherit (builtins) attrValues;
      eachSystem = f:
        lib.genAttrs [ "x86_64-linux" ]
        (system: f nixpkgs.legacyPackages.${system});
      inherit (poetry2nix.lib.mkPoetry2Nix {
        inherit (nixpkgs.legacyPackages."x86_64-linux")
        ;
      })
        mkPoetryApplication;
    in {
      packages.default = mkPoetryApplication {
        projectDir = self;
        overrides = poetry2nix.overrides.withDefaults (final: super:
          lib.mapAttrs (attr: systems:
            super.${attr}.overridePythonAttrs (old: {
              nativeBuildInputs = (old.nativeBuildInputs or [ ])
                ++ map (a: final.${a}) systems;
            })) {
              # https://github.com/nix-community/poetry2nix/blob/master/docs/edgecases.md#modulenotfounderror-no-module-named-packagename
              # package = [ "setuptools" ];
            });

      };
      devShells = eachSystem (pkgs: {
        default = pkgs.mkShell {
          packages = attrValues { inherit (pkgs) python3 poetry; };
          inputsFrom = [ self.packages.default ];
        };
      });

    };
}
