{ nixpkgs ? import <nixpkgs> {} }:
  nixpkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = [
        nixpkgs.git
        nixpkgs.sapling
        nixpkgs.gh
        nixpkgs.yarn
    ];
}
