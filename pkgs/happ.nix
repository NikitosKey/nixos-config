{ pkgs ? import <nixpkgs> {}, stdenv, lib }:

let 
  hash_aarch64-linux = "sha256-xsjbFrtCZU5TCFnG86Pe6E9qG8Ywt4XxuyZPP4PQx8Y=";
  url_aarch64-linux= "https://github.com/Happ-proxy/happ-desktop/releases/download/${version}/Happ.linux.arm64.deb";
  hash_x86_64-linux = "1xgzifrhdrc80xd2hxn7zbmgskh58637b9q10bngbnm4542cxxsi";
  url_x86_64-linux = "https://github.com/Happ-proxy/happ-desktop/releases/download/${version}/Happ.linux.x64.deb";
  pname = "happ-desktop";
  version = "2.16.2";

  meta = {
    description = "Happ is a cross-platform application designed for convenient work with proxy servers, built on the powerful Xray core.";
    homepage = "https://happ.su/";
    license = lib.licenses.unfree;
    mainProgram = "Happ";
    maintainers = with lib.maintainers; [ crertel ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
in 
if stdenv.hostPlatform.system == "aarch64-linux" then
  pkgs.stdenv.mkDerivation rec {
    inherit pname meta version;
    src = pkgs.fetchurl {
      url = url_aarch64-linux;
      sha256 = hash_aarch64-linux; };


    nativeBuildInputs = with pkgs; [
      dpkg
      autoPatchelfHook
      makeWrapper
      qt6.wrapQtAppsHook
    ];

    buildInputs = with pkgs; [
      stdenv.cc.cc.lib
      glib
      dbus
      libGL
      libX11
      libSM
      libICE
      libXext
      libXi
      libXtst
      e2fsprogs
      fontconfig
      freetype
      libgpg-error
      qt6.qtwayland
      openssl
    ];

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/happ
      mkdir -p $out/share/applications
      mkdir -p $out/bin

      dpkg -x $src .
      cp -r opt/happ/* $out/happ/

      if [ -d "usr/share" ]; then
        cp -r usr/share/* $out/share/
      fi

      wrapProgram $out/happ/bin/Happ \
        --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [ pkgs.openssl ]}" \
        --set SSL_CERT_FILE "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"

      wrapProgram $out/happ/bin/happd \
        --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [ pkgs.openssl ]}" \
        --set SSL_CERT_FILE "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"

      ln -s $out/happ/bin/Happ $out/bin/happ

      runHook postInstall
    '';
  }
else
  pkgs.stdenv.mkDerivation rec {
    inherit pname meta version;
    src = pkgs.fetchurl {
      url = url_x86_64-linux;
      sha256 = hash_x86_64-linux; };


    nativeBuildInputs = with pkgs; [
      dpkg
      autoPatchelfHook
      makeWrapper
      qt6.wrapQtAppsHook
    ];

    buildInputs = with pkgs; [
      stdenv.cc.cc.lib
      glib
      dbus
      libGL
      libX11
      libSM
      libICE
      libXext
      libXi
      libXtst
      e2fsprogs
      fontconfig
      freetype
      libgpg-error
      qt6.qtwayland
      openssl
    ];

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/happ
      mkdir -p $out/share/applications
      mkdir -p $out/bin

      dpkg -x $src .
      cp -r opt/happ/* $out/happ/

      if [ -d "usr/share" ]; then
        cp -r usr/share/* $out/share/
      fi

      wrapProgram $out/happ/bin/Happ \
        --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [ pkgs.openssl ]}" \
        --set SSL_CERT_FILE "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"

      wrapProgram $out/happ/bin/happd \
        --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [ pkgs.openssl ]}" \
        --set SSL_CERT_FILE "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"

      ln -s $out/happ/bin/Happ $out/bin/happ

      runHook postInstall
    '';
  }
