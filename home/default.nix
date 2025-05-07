{
  osConfig,
  lib,
  pkgs,
  ...
}:
{

  fonts.fontconfig.enable = true;

  home.username = "pablogq";
  home.homeDirectory = "/Users/pablogq";

  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    awscli2
    bat
    bun
    curl
    doppler
    eza
    fd
    fnm
    fzf
    gh
    go
    httpstat
    nil
    rover
    ripgrep
    sqlite
    nerd-fonts.fira-code
    nerd-fonts.victor-mono
  ];

  programs.home-manager.enable = true;

  programs.fish.enable = true;
  programs.fish.functions.fish_greeting = "";
  programs.fish.functions.upgrade = ''
    pushd ~/.nix
    nix flake update
    brew update
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
      fish_add_path --move --prepend --path ${
        lib.concatMapStringsSep " " dquote (makeBinPathList osConfig.environment.profiles)
      }
      set fish_user_paths $fish_user_paths
    '';

  programs.fish.interactiveShellInit = ''
    set -g fish_color_autosuggestion '555'  'brblack'
    set -g fish_color_cancel -r
    set -g fish_color_command --bold
    set -g fish_color_comment red
    set -g fish_color_cwd green
    set -g fish_color_cwd_root red
    set -g fish_color_end brmagenta
    set -g fish_color_error brred
    set -g fish_color_escape 'bryellow'  '--bold'
    set -g fish_color_history_current --bold
    set -g fish_color_host normal
    set -g fish_color_match --background=brblue
    set -g fish_color_normal normal
    set -g fish_color_operator bryellow
    set -g fish_color_param cyan
    set -g fish_color_quote yellow
    set -g fish_color_redirection brblue
    set -g fish_color_search_match 'bryellow'  '--background=brblack'
    set -g fish_color_selection 'white'  '--bold'  '--background=brblack'
    set -g fish_color_user brgreen
    set -g fish_color_valid_path --underline

    # homebrew
    fish_add_path /opt/homebrew/bin

    # fnm
    set -gx FNM_DIR $HOME/.fnm
    fish_add_path $HOME/.fnm
    fnm env --use-on-cd | source

    # go
    set -gx GOPATH $HOME/.go
    fish_add_path $HOME/.go/bin
  '';

  programs.starship.enable = true;
  programs.starship.enableFishIntegration = true;
  programs.starship.enableBashIntegration = false;
  programs.starship.enableZshIntegration = false;
  programs.starship.settings = lib.mkMerge [
    {
      command_timeout = 1000;
      character.success_symbol = "[λ](bold green)";
      character.error_symbol = "[λ](bold red)";
      hostname = {
        ssh_only = true;
        format = "on [$hostname](bold red) ";
      };
    }
    (builtins.fromTOML (
      builtins.readFile "${pkgs.starship}/share/starship/presets/nerd-font-symbols.toml"
    ))
  ];

  # ghostty is marked as broken for darwin systems and it is installed with brew
  # using null for package to handle the config with home-manager.
  # https://github.com/nix-community/home-manager/blob/11e6d20803cb660094a7657b8f1653d96d61b527/modules/programs/ghostty.nix#L34
  programs.ghostty.package = null;
  programs.ghostty.enable = true;
  programs.ghostty.enableFishIntegration = true;
  programs.ghostty.enableBashIntegration = false;
  programs.ghostty.enableZshIntegration = false;

  programs.ghostty.settings = {
    font-size = 14;
    font-family = "VictorMono Nerd Font Mono";
    term = "xterm-256color";
    theme = "catppuccin-frappe";
    window-padding-x = 10;
    window-padding-y = "2";
    macos-titlebar-style = "tabs";
    background-opacity = 0.9;
    background-blur = true;
    confirm-close-surface = false;
    copy-on-select = "clipboard";
  };

  programs.vim.enable = true;

  programs.git.enable = true;
  programs.git.userName = "Pablo Guerrero";
  programs.git.userEmail = "pablogq@outlook.com";
  programs.git.includes = [
    {
      condition = "gitdir:~/code/github/slidebean/";
      path = "~/code/github/slidebean/.gitconfig";
    }
  ];
  programs.git.extraConfig = {
    core = {
      whitespace = "trailing-space,space-before-tab";
    };
    ui.color = "always";
    github.user = "pablogq";
    protocol.keybase.allow = "always";
    credential.helper = "osxkeychain";
    pull.rebase = "true";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Don't show the "Last login" message for every new terminal.
  home.file.".hushlogin" = {
    text = "";
  };
}
