{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  makeWrapper,
  jre,
  maxHeapSize ? "4096m",
}:

let
  source = lib.importJSON ./source.json;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "icpc-presentation";
  inherit (source) version;

  src = fetchurl {
    url = "https://github.com/${source.owner}/${source.repo}/releases/download/v${finalAttrs.version}/resolver-${finalAttrs.version}.zip";
    inherit (source) hash;
  };

  nativeBuildInputs = [
    unzip
    makeWrapper
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icpc/lib
    cp -r lib/* $out/share/icpc/lib/

    classpath=$(find $out/share/icpc/lib -name '*.jar' | sort | tr '\n' ':')
    makeWrapper ${lib.getExe' jre "java"} $out/bin/presentation-client \
      --add-flags "-Xmx${maxHeapSize}" \
      --add-flags "-cp ''${classpath%:}" \
      --add-flags org.icpc.tools.presentation.contest.internal.ClientLauncher

    runHook postInstall
  '';

  meta = {
    description = "ICPC Tools presentation client";
    homepage = "https://github.com/icpctools/icpctools";
    license = lib.licenses.epl20;
    mainProgram = "presentation-client";
    platforms = lib.platforms.unix;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
})
