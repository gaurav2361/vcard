{
  description = "Python (uv) development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs, ... }:

    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              # Apply the overlay defined below to the packages
              overlays = [ self.overlays.default ];
            };
          }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        let
          # 2. Select Python Version
          python = pkgs.python313;
        in
        {
          default = pkgs.mkShellNoCC {

            # 3. Environment Variables
            # Tell uv to use the specific Python version provided by Nix
            UV_PYTHON = "${python}/bin/python";
            # Tell pip (if used inside uv) not to check for updates
            PIP_DISABLE_PIP_VERSION_CHECK = "1";

            packages = with pkgs; [
              uv
              python
            ];

            # Automatically creates/activates the uv venv
            shellHook = ''
              echo "Loading Hybrid Dev Environment"

              # uv Setup
              if [ ! -d ".venv" ]; then
                echo "Creating uv virtual environment..."
                uv venv
              fi

              # Activate venv
              source .venv/bin/activate

              # Display versions
              echo "Versions:"
              echo "  Python: $(python --version)"
              echo "  uv:     $(uv --version)"
            '';
          };
        }
      );
    };
}
