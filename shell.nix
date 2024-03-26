{ pkgs ? import (fetchTarball
  "https://github.com/NixOS/nixpkgs/archive/refs/tags/22.11.tar.gz") { } }:

pkgs.mkShellNoCC { packages = with pkgs; [ cocoapods ]; }
