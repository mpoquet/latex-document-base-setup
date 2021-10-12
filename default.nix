{ pkgs ? import (
    fetchTarball "https://github.com/NixOS/nixpkgs/archive/21.05.tar.gz") {}
}:

let
  self = rec {
    # build the document from scratch
    # no build cache helps in making your document reproducible
    document = pkgs.stdenv.mkDerivation rec {
      name = "report";
      nativeBuildInputs = with pkgs; [
        texlive.combined.scheme-full
        ninja
        rubber
        asymptote
      ];
      # source filtering ensures build ignores local cache files
      src = pkgs.lib.sourceByRegex ./. [
        ".*\.tex"
        ".*\.bib"
        ".*\.sty"
        "build\.ninja"
        "fig"
        "fig/.*\.asy"
      ];
      installPhase = ''
        mkdir -p $out
        mv document.pdf $out/
      '';
    };

    # convenient for interactive development.
    # document will be regenerated whenever one of its input files is changed.
    # the killall command updates the llpp pdf renderer, customize it to your needs.
    autorebuild-shell = pkgs.mkShell rec {
      name = "autobuild-shell";
      buildInputs = [
        pkgs.entr pkgs.psmisc
      ] ++ document.nativeBuildInputs;
      shellHook = ''
        ls build.ninja *.tex *.bib fig/*.asy | entr -s "ninja ; killall -HUP --regexp '(.*bin/)?llpp'"
      '';
    };
  };
in
  self
