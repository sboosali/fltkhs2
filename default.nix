{ mkDerivation, base, bytestring, c2hs, Cabal, directory, filepath
, fltk, language-c, libjpeg, mtl, parsec, stdenv, text
}:
mkDerivation {
  pname = "fltkhs";
  version = "0.5.4.5";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  setupHaskellDepends = [
    base c2hs Cabal directory filepath language-c
  ];
  libraryHaskellDepends = [ base bytestring text ];
  librarySystemDepends = [ fltk libjpeg ];
  libraryToolDepends = [ fltk ];
  executableHaskellDepends = [ base directory filepath mtl parsec ];
  homepage = "http://github.com/deech/fltkhs";
  description = "FLTK bindings";
  license = stdenv.lib.licenses.mit;
}
