# icpc-presentation-nix

Nix packages for [ICPC Tools](https://github.com/icpctools/icpctools), built from the upstream release zips, used by
[genix](https://github.com/GEHACK/genix).

| Package                   | Upstream zip                | Binaries                 |
| ------------------------- | --------------------------- | ------------------------ |
| `icpc-presentation`       | `presentations-<v>.zip`     | `presentation-client`    |
| `icpc-presentation-admin` | `presentationAdmin-<v>.zip` | `presentation-admin`     |
| `icpc-resolver`           | `resolver-<v>.zip`          | `resolver`, `awards`     |

The packages are listed in `tools.nix`. Adding another tool is a new entry there followed by `./update.sh`.

## Use

```nix
{
  inputs.icpc-presentation.url = "github:GEHACK/icpc-presentation-nix";
}
```

Add `inputs.icpc-presentation.overlays.default` to `nixpkgs.overlays` and use any of the packages above, e.g.
`pkgs.icpc-presentation`. The packages are built against the consumer's nixpkgs, so
`inputs.icpc-presentation.inputs.nixpkgs.follows = "nixpkgs"` is fine.

`presentation-client` takes the CDS contest URL, username and password:

```
presentation-client https://cds.example/api/contests/<id> <user> <password>
```

The JVM heap is `-Xmx4096m`; override with `pkgs.icpc-presentation.override { maxHeapSize = "8192m"; }`.

`presentation-admin` and `awards` are SWT applications and only run on `x86_64-linux`.

## Version pin

`source.json` pins a release and the hash of every zip in `tools.nix`. It must match the version of the CDS the tools
connect to.

```sh
nix develop --command ./update.sh <version>
```
