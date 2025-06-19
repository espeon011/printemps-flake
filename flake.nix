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

        printemps =
          pkgs.stdenv.mkDerivation
          {
            pname = "printemps";
            version = "2.7.0";
            src = pkgs.fetchFromGitHub {
              owner = "snowberryfield";
              repo = "printemps";
              rev = "v2.7.0";
              hash = "sha256-gcP+eOH/WO4HEq10NaEbDKNFFvBrkPoBySvkvOaOgBM=";
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
              cp ./build/application/Release/mps_solver $out/bin
              cp ./build/application/Release/opb_solver $out/bin
              mkdir -p $out/include
              cp -r ./printemps/* $out/include
            '';

            meta = {
              homepage = "https://snowberryfield.github.io/printemps";
              mainProgram = "mps_solver";
              platforms = pkgs.lib.platforms.unix;
              license = pkgs.lib.licenses.mit;
            };
          };
      in {
        packages = {
          inherit printemps;
          default = printemps;
        };
      }
    );
}
