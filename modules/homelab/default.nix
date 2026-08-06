{ ... }:
{
  /*
  This file is just a long list of imports for homelab modules.
  It is used to keep the server.nix file clean and organized.
  If I need to add a homelab module to a non-server machine,
  I can import that module specifically in that machine's default.nix file.
  */
  imports = [
    ./audiobookshelf.nix
    ./cockpit.nix
    ./deluge.nix
    ./freshrss.nix
    ./homer.nix
    ./karakeep.nix
    ./linkding.nix
    ./linkwarden.nix
    ./nixflix.nix
  ];

}