{ pkgs, ... }:

let
  danmu-tts-flake = builtins.getFlake "github:jiahaoxiang2000/danmu-tts";
in
danmu-tts-flake.packages.${pkgs.system}.default