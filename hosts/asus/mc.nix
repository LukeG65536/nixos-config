{ pkgs, lib, ... }:
let
  # Mod jars come from Modrinth. Get the URL and hash from each mod's "Versions" tab.
  # Use lib.fakeHash first, build once, and Nix will print the real hash.
  mod = name: url: hash: {
    name = "${name}.jar";
    path = pkgs.fetchurl { inherit url hash; };
  };
in
{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "minecraft-server" ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = false;   # playit connects locally

    servers.main = {
      enable = true;

      # Check `nix flake show github:Infinidoge/nix-minecraft` for current version names
      package = pkgs.fabricServers.fabric-1_21_4.override {
        loaderVersion = "0.16.10";
      };

      jvmOpts = "-Xms3G -Xmx4G";

      serverProperties = {
        server-port = 25565;
        difficulty = "normal";
        gamemode = "survival";
        max-players = 20;
        view-distance = 16;
        simulation-distance = 8;
        white-list = false;
        black-list = true;
        online-mode = true;
        motd = "spruce 3rd";
      };

      symlinks.mods = pkgs.linkFarm "mods" [
        (mod "fabric-api" "https://cdn.modrinth.com/data/.../fabric-api.jar" lib.fakeHash)
        (mod "lithium"    "https://cdn.modrinth.com/data/.../lithium.jar"    lib.fakeHash)
        (mod "ferritecore" "https://cdn.modrinth.com/data/.../ferritecore.jar" lib.fakeHash)
      ];
    };
  };
}
