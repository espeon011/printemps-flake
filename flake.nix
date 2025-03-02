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
            version = "2.6.1";
            src = pkgs.fetchFromGitHub {
              owner = "snowberryfield";
              repo = "printemps";
              rev = "v2.6.1";
              hash = "sha256-NwF8MzIpGzizVGaagsAxpAffKQFiJyzWRJAvaoMHXzY=";
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
              mkdir -p $out/include
              cp -r ./printemps/* $out/include
              export CPLUS_INCLUDE_PATH="$out/include":$CPLUS_INCLUDE_PATH
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
