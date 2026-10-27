{
  description = "ICPC Tools, packaged for Nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs =
    { nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      tools = import ./tools.nix;
      buildTools =
        pkgs:
        builtins.mapAttrs (pname: tool: pkgs.callPackage ./pkg.nix ({ inherit pname; } // tool)) tools;
      packages = buildTools pkgs;
    in
    {
      overlays.default = final: _prev: buildTools final;

      packages.x86_64-linux = packages // {
        default = packages.icpc-presentation;
      };

      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = with pkgs; [
          jq
        ];
      };
    };
}
