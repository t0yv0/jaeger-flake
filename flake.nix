{
  description = "A flake defining Jaeger binary package via GitHub releases";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;
    jaeger-x86_64-linux = {
      url = "https://github.com/jaegertracing/jaeger/releases/download/v1.35.1/jaeger-1.35.1-linux-amd64.tar.gz";
      flake = false;
    };
    jaeger-x86_64-darwin = {
      url = "https://github.com/jaegertracing/jaeger/releases/download/v1.35.1/jaeger-1.35.1-darwin-amd64.tar.gz";
      flake = false;
    };
  };

  outputs =
    { self,
      nixpkgs,
      jaeger-x86_64-linux,
      jaeger-x86_64-darwin,
    }:

    let
      ver = "1.35.1";

      package = { system, src }:
        let
          pkgs = import nixpkgs { system = system; };
        in pkgs.stdenv.mkDerivation {
          name = "jaeger-${ver}";
          version = "${ver}";
          src = src;
          installPhase = "mkdir -p $out/bin && cp $src/jaeger* $out/bin/";
        };
    in {
      packages.x86_64-linux.default = package {
        system = "x86_64-linux";
        src = jaeger-x86_64-linux;
      };
      packages.x86_64-darwin.default = package {
        system = "x86_64-darwin";
        src = jaeger-x86_64-darwin;
      };
    };
}
