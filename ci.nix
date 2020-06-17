builtins.mapAttrs (k: _v:
  let
    url = "https://github.com/NixOS/nixpkgs/archive/2255f292063ccbe184ff8f9b35ce475c04d5ae69.tar.gz";
    pkgs = import (builtins.fetchTarball url) { system = k; };
  in
  pkgs.recurseIntoAttrs {
    # These two attributes will appear in your job for each platform.
    make-html = pkgs.runCommand "make-html" {
      buildInputs = [  ];
    } ''
      make html
    '';
  }
) {
  x86_64-linux = {};
}