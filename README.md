# printemps-flake

This is a flake for the [printemps solver](https://github.com/snowberryfield/printemps).

## Usage

```nix
{
  description = "artemis execution environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    printemps-flake = {
      url = "github:espeon011/printemps-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    printemps-flake,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        devShells.default = pkgs.mkShell {
          name = "my-printemps-project";
          packages = [
            printemps-flake.packages.${system}.default
          ];
        };
      }
    );
}
```

in your `flake.nix`, then run

```shell
nix develop
```
