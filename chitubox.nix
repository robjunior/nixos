{ fetchurl, lib, stdenv, buildFHSUserEnv }:

stdenv.mkDerivation rec {
  name = "chitubox-1.9.1";
  src = fetchurl {
    url = "https://sac.chitubox.com/software/download.do?softwareId=17839&softwareVersionId=v1.9.2&fileName=CHITUBOX_V1.9.2.tar.gz";
    sha256 = "0di0d3hg7jy2c63isdv50c3qsff9vk2x0305jjdqy8xpy62mh9dq";
  };
  
  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r $src/* $out/bin/
  '';

  meta = with lib; {
    description = "Chitubox 3D Printing Slicer";
    license = licenses.mit;
  };

  nativeBuildInputs = [ buildFHSUserEnv ];
  buildCommand = ''
    mkdir -p $out
    buildFHSUserEnv --dest $out --use-max-jobs --substitute --fallback ${stdenv.buildFHSUserEnv} \
      --set SHELL $SHELL --set PATH "$PATH" \
      --add-libs glibc
  '';
}