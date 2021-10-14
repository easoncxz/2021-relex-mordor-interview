with (import <nixpkgs> {});

let
  hp = haskellPackages.extend (self: super: {
    mordor-interview = self.callPackage ./. {};
  });
  easy-hls = pkgs.callPackage easy-hls-src { ghcVersions = [hp.ghc.version]; };

in
hp.shellFor {
  packages = h: [h.mordor-interview];
  buildInputs = [
    cabal-install
    ghcid
    stylish-haskell
  ];
}
