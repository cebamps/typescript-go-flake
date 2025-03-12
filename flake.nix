{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.ts-go-src = {
    url = "github:microsoft/typescript-go?submodules=1";
    flake = false;
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ts-go-src,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          default = ts-go;
          ts-go = pkgs.buildGo124Module rec {
            pname = "typescript-go";
            version = "0.0.0";

            src = ts-go-src;
            vendorHash = "sha256-Hxgoxmu2rqfDKKiJOXfXoPxNMt/iAQnqx4cRFQj1KWU=";

            meta = {
              homepage = "https://github.com/microsoft/typescript-go";
              license = nixpkgs.lib.licenses.asl20;
              mainProgram = "tsgo";
            };
          };
        };
        devShells.default = pkgs.mkShell {
          inputsFrom = [self.packages.${system}.ts-go];
        };
      }
    );
}
