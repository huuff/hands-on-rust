{
  description = "Following 'Hands-on-Rust' examples";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-22.11";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, rust-overlay, nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ (import rust-overlay) ];
    };
  in with pkgs;
  {
    devShell.${system} = mkShell {
      nativeBuildInputs = [
        pkg-config
        clang
        lld # To use lld linker
      ];
      buildInputs = [
        (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
          extensions = [ "rust-src" ];
        }))
        cargo
        fontconfig
        rust-analyzer
        cmake
        xorg.libX11
        xlibsWrapper
        xorg.libXrandr
        xorg.libXcursor
        xorg.libXi
      ];
      shellHook = ''
      export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${
        lib.makeLibraryPath [
          udev
          alsaLib
          vulkan-loader
          libGL
        ]
      }"'';
    };
  };
}
