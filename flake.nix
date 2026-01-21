{
  description = "A Nix-flake-based Python development environment using uv";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";

  outputs =
    { self, ... }@inputs:

    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import inputs.nixpkgs { inherit system; };
          }
        );

      # Change this to update the Python version
      version = "3.13";
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        let
          # Helper to convert "3.13" -> "313" for nixpkgs lookup
          concatMajorMinor =
            v:
            pkgs.lib.pipe v [
              pkgs.lib.versions.splitVersion
              (pkgs.lib.sublist 0 2)
              pkgs.lib.concatStrings
            ];

          python = pkgs."python${concatMajorMinor version}";
        in
        {
          default = pkgs.mkShellNoCC {
            packages = [
              pkgs.uv
              python
            ];

            env = {
              # Tell uv to use the specific Python provided by Nix
              UV_PYTHON = "${python}/bin/python";
              # Tell uv not to download managed Python versions (we want to use the Nix one)
              UV_PYTHON_DOWNLOADS = "never";
              # Force venv creation in the project root
              UV_PROJECT_ENVIRONMENT = ".venv";
            };

            shellHook = ''
              # 1. Create venv if it doesn't exist
              #    uv is smart enough to recreate it if the python version changed
              uv venv .venv

              # 2. Activate the environment
              source .venv/bin/activate

              # 3. (Optional) Auto-install dependencies if pyproject.toml exists
              if [ -f "pyproject.toml" ]; then
                echo "Syncing dependencies..."
                uv sync
              fi
            '';

            # Fix for Linux: allows binary wheels (numpy, pandas, etc.) to link against system libs
            LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
              pkgs.stdenv.cc.cc
              pkgs.zlib
              # Add other system deps here if wheels fail to load, e.g.:
              # pkgs.glib
              # pkgs.libGL
            ];
          };
        }
      );
    };
}
