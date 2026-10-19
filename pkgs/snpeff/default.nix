{ lib, stdenv, fetchurl, unzip, makeWrapper, jre }:

stdenv.mkDerivation {
  pname = "snpeff";
  version = "5.4C";

  src = fetchurl {
    # `latest` is the only published URL for the 5.4 line; the hash below pins
    # the exact artifact. Bump version + hash when upstream refreshes it.
    url = "https://snpeff-public.s3.amazonaws.com/versions/snpEff_latest_core.zip";
    sha256 = "0cyz1bqfj7qv2qwkzmkjsjky1lfkq64g11rk8gayprrrz7hs21iv";
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/share/java $out/bin

    cp snpEff/snpEff.jar $out/share/java/
    cp snpEff/SnpSift.jar $out/share/java/

    if [ -d "snpEff/data" ]; then
      mkdir -p $out/share/snpEff
      cp -r snpEff/data $out/share/snpEff/
    fi

    makeWrapper ${jre}/bin/java $out/bin/snpeff \
      --add-flags "-jar $out/share/java/snpEff.jar"

    makeWrapper ${jre}/bin/java $out/bin/snpsift \
      --add-flags "-jar $out/share/java/SnpSift.jar"
  '';

  meta = with lib; {
    description = "Genetic variant annotation and functional effect prediction toolbox";
    homepage = "https://pcingola.github.io/SnpEff/";
    license = licenses.lgpl3;
    platforms = platforms.linux;
  };
}
