{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    presenterm
    alacritty
  ];

  shellHook = ''
    alacritty \
      --title "RISC-V on nixpkgs" \
      -o 'window.startup_mode="Fullscreen"' \
      -o 'font.size=18' \
      -e presenterm --present RISC_V__NixOS.md
  '';
}
