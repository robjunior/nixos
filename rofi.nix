{ lib, config, pkgs, ...}:

with lib;
let
 cfg = config.rofi;
in
{
 environment.systemPackages = [ pkgs.rofi ];
programs.rofi = {
 enable = true;
};
}
