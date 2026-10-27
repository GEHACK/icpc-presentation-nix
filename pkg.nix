{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  makeWrapper,
  jre,
  glib,
  gtk3,
  gsettings-desktop-schemas,
  libxtst,
  pname,
  archive,
  description,
  mainProgram,
  programs,
  usesSwt ? false,
  maxHeapSize ? "4096m",
}:

let
  source = lib.importJSON ./source.json;
  swtWrapperFlags = lib.optionalString usesSwt (
    lib.escapeShellArgs [
      "--prefix"
      "LD_LIBRARY_PATH"
      ":"
      (lib.makeLibraryPath [
        gtk3
        libxtst
      ])
      "--prefix"
      "XDG_DATA_DIRS"
      ":"
      "${glib.getSchemaDataDirPath gtk3}:${glib.getSchemaDataDirPath gsettings-desktop-schemas}"
    ]
  );
in
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname;
  inherit (source) version;

  src = fetchurl {
    url = "https://github.com/${source.owner}/${source.repo}/releases/download/v${finalAttrs.version}/${archive}-${finalAttrs.version}.zip";
    hash = source.hashes.${archive};
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
    rm -f $out/share/icpc/lib/swtLauncher.jar $out/share/icpc/lib/swt-{cocoa,win32}-*.jar

    classpath=$(find $out/share/icpc/lib -name '*.jar' | sort | tr '\n' ':')
    ${lib.concatMapAttrsStringSep "\n" (program: mainClass: ''
      makeWrapper ${lib.getExe' jre "java"} $out/bin/${program} \
        --add-flags "-Xmx${maxHeapSize}" \
        --add-flags "-cp ''${classpath%:}" \
        --add-flags ${mainClass} \
        ${swtWrapperFlags}
    '') programs}

    runHook postInstall
  '';

  meta = {
    inherit description mainProgram;
    homepage = "https://github.com/icpctools/icpctools";
    license = lib.licenses.epl20;
    platforms = if usesSwt then [ "x86_64-linux" ] else lib.platforms.unix;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
})
