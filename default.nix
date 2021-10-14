{ mkDerivation, aeson, base, bytestring, hedgehog, hspec
, hspec-hedgehog, lens, lens-aeson, lib, mtl, text, wai, warp, wreq
}:
mkDerivation {
  pname = "mordor-interview";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base bytestring mtl text wai warp ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [
    aeson base hedgehog hspec hspec-hedgehog lens lens-aeson mtl warp
    wreq
  ];
  license = lib.licenses.bsd3;
}
