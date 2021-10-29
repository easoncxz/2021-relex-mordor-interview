with (import <nixpkgs> {});

let
  hp = haskellPackages.extend (self: super: {
    mordor-interview = self.callPackage ./. {};
  });

in
hp.shellFor {
  packages = h: [h.mordor-interview];
  buildInputs = [
    cabal-install
    ghcid
    stylish-haskell
  ];
}
