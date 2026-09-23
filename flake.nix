{
  description = "ICPC Tools presentation client, packaged for Nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs =
    { nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      icpc-presentation = pkgs.callPackage ./pkg.nix { };
    in
    {
      overlays.default = final: _prev: {
        icpc-presentation = final.callPackage ./pkg.nix { };
      };

      packages.x86_64-linux = {
        inherit icpc-presentation;
        default = icpc-presentation;
      };

      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = with pkgs; [
          jq
        ];
      };
    };
}
