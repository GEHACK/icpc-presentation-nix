# icpc-presentation-nix

Nix package for the [ICPC Tools](https://github.com/icpctools/icpctools) presentation client, built
from the upstream `resolver-<version>.zip` release, used by [genix](https://github.com/GEHACK/genix).

## Use

```nix
{
  inputs.icpc-presentation.url = "github:GEHACK/icpc-presentation-nix";
}
```

Add `inputs.icpc-presentation.overlays.default` to `nixpkgs.overlays` and use `pkgs.icpc-presentation`. The package is
built against the consumer's nixpkgs, so `inputs.icpc-presentation.inputs.nixpkgs.follows = "nixpkgs"` is fine.

The binary is `presentation-client`; it takes the CDS contest URL, username and password:

```
presentation-client https://cds.example/api/contests/<id> <user> <password>
```

The JVM heap is `-Xmx4096m`; override with `pkgs.icpc-presentation.override { maxHeapSize = "8192m"; }`.

## Version pin

`source.json` pins a release. It must match the version of the CDS the client connects to.

```sh
nix develop --command ./update.sh <version>
```
