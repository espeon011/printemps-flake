{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};

        printemps = pkgs.stdenv.mkDerivation (finalAttrs: {
          pname = "printemps";
          version = "v2.8.0";

          src = pkgs.fetchFromGitHub {
            owner = "snowberryfield";
            repo = "printemps";
            rev = finalAttrs.version;
            hash = "sha256-NM669kYXhQdccMBPF7+mqP2aFHn1vgW88BXhNZr3qM4=";
          };

          nativeBuildInputs = [
            pkgs.cmake
          ];
          buildInputs = [
            pkgs.llvmPackages.openmp
          ];

          dontUseCmakeConfigure = true;
          buildPhase = ''
            make -f makefile/Makefile.application
          '';
          installPhase = ''
            mkdir -p $out/bin
            cp ./build/application/Release/printemps $out/bin
            mkdir -p $out/include
            cp -r ./printemps/* $out/include
          '';

          meta = {
            homepage = "https://snowberryfield.github.io/printemps";
            mainProgram = "mps_solver";
            platforms = pkgs.lib.platforms.unix;
            license = pkgs.lib.licenses.mit;
          };
        });
      in {
        packages = {
          inherit printemps;
          default = printemps;
        };
      }
    );
}
