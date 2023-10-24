{ config, osConfig, lib, pkgs, ... }: {

  fonts.fontconfig.enable = true;


  home.username = "pablogq";
  home.homeDirectory = "/Users/pablogq";

  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    rnix-lsp
    (nerdfonts.override { fonts = [ "VictorMono" ]; })
  ];

  programs.home-manager.enable = true;

  programs.fish.enable = true;
  programs.fish.functions.fish_greeting = "";
  programs.fish.functions.upgrade = ''
    pushd ~/.nix
    darwin-rebuild switch --flake .#$argv[1]
    popd
  '';

  # Fix an issue with $PATH and fish:
  # https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1659465635
  programs.fish.loginShellInit =
    let
      # This naive quoting is good enough in this case. There shouldn't be any
      # double quotes in the input string, and it needs to be double quoted in case
      # it contains a space (which is unlikely!)
      dquote = str: "\"" + str + "\"";

      makeBinPathList = map (path: path + "/bin");
    in
    ''
      fish_add_path --move --prepend --path ${lib.concatMapStringsSep " " dquote (makeBinPathList osConfig.environment.profiles)}
      set fish_user_paths $fish_user_paths
    '';

  programs.starship.enable = true;
  programs.starship.enableFishIntegration = true;
  programs.starship.enableBashIntegration = false;
  programs.starship.settings = {
    character.success_symbol = "[λ](bold green)";
    character.error_symbol = "[λ](bold red)";
  };

  programs.kitty.enable = true;
  programs.kitty.font = {
    package = (pkgs.nerdfonts.override { fonts = [ "VictorMono" ]; });
    name = "VictorMono Nerd Font Mono";
  };

}
