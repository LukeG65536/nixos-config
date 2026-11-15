{ inputs, pkgs, lib, ... }:
let
  # Mod jars are pinned to Minecraft 1.21.4 compatible Modrinth releases.
  mod = name: url: hash: {
    name = "${name}.jar";
    path = pkgs.fetchurl { inherit url hash; };
  };
in
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

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
        online-mode = true;
        motd = "spruce 3rd";
      };

      symlinks.mods = pkgs.linkFarm "mods" [
        (mod "fabric-api" "https://cdn.modrinth.com/data/P7dR8mSH/versions/p96k10UR/fabric-api-0.119.4%2B1.21.4.jar" "sha512-FrZ59qQlSco7a8FH3nELLIui1eRmHtiN8ieCwFpKX2wRY9exOGdoftkazeD9/lpQN9BWYkMclGhltYOWKE5+5w==")
        (mod "lithium" "https://cdn.modrinth.com/data/gvQqBUqZ/versions/u8pHPXJl/lithium-fabric-0.15.3%2Bmc1.21.4.jar" "sha512-uLVBwOloVxyJcocrNC40uSVzvJIQ1FXcE0lYnzCmepDZMNv9mbF2q5sRA1DOtT4REYN43BOjXoOpCQgmYnvawA==")
        (mod "ferritecore" "https://cdn.modrinth.com/data/uXXizFIs/versions/7KqeXPRS/ferritecore-7.1.3-fabric.jar" "sha512-dEh9bvpulzkUZl0P3zZhVsR+JqDlKkkuxdW2jX6jMVNfostG65WohG47LwMYu8/f84hd8L/OG8g2lrIR2V6YYw==")
      ];
    };
  };
}
