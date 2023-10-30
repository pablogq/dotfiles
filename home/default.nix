{ config, osConfig, lib, pkgs, ... }: {

  fonts.fontconfig.enable = true;


  home.username = "pablogq";
  home.homeDirectory = "/Users/pablogq";

  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    awscli2
    bat
    curl
    doppler
    eza
    fd
    fnm
    fzf
    gh
    ripgrep
    rnix-lsp
    (nerdfonts.override { fonts = [ "VictorMono" "FiraCode" ]; })
    nodePackages.pnpm
    yarn
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

    # fnm
    set -gx FNM_DIR $HOME/.fnm
    fish_add_path $HOME/.fnm
    fnm env | source
  '';

  programs.starship.enable = true;
  programs.starship.enableFishIntegration = true;
  programs.starship.enableBashIntegration = false;
  programs.starship.enableZshIntegration = false;
  programs.starship.settings = {
    character.success_symbol = "[λ](bold green)";
    character.error_symbol = "[λ](bold red)";
  };

  programs.kitty.enable = true;

  programs.kitty.shellIntegration.enableFishIntegration = true;
  programs.kitty.shellIntegration.enableBashIntegration = false;
  programs.kitty.shellIntegration.enableZshIntegration = false;
  programs.kitty.settings = {
    font_size = 14;
    term = "xterm-kitty";
    enable_audio_bell = false;
    strip_trailing_spaces = "smart";
    window_padding_width = "0 10 4";
    macos_option_as_alt = "yes";
    macos_titlebar_color = "background";

    foreground = "#a6accd";
    background = "#1b1e28";
    url_color = "#5de4c7";

    # Black
    color0 = "#1b1e28";
    color8 = "#a6accd";

    # Red
    color1 = "#d0679d";
    color9 = "#d0679d";

    # Green
    color2 = "#5de4c7";
    color10 = "#5de4c7";

    # Yellow
    color3 = "#fffac2";
    color11 = "#fffac2";

    # Blue
    color4 = "#89ddff";
    color12 = "#add7ff";

    # Magenta
    color5 = "#fcc5e9";
    color13 = "#fae4fc";

    # Cyan
    color6 = "#add7ff";
    color14 = "#89ddff";

    # White
    color7 = "#ffffff";
    color15 = "#ffffff";

    # Cursor
    cursor = "#ffffff";
    cursor_shape = "underline";
    cursor_text_color = "#1b1e28";

    # Selection highlight
    selection_foreground = "none";
    selection_background = "#28344a";

    # Window borders
    active_border_color = "#3d59a1";
    inactive_border_color = "#101014";
    bell_border_color = "#fffac2";

    # Tab bar
    tab_bar_edge = "top";
    tab_bar_style = "fade";
    tab_fade = 1;
    active_tab_foreground = "#3d59a1";
    active_tab_background = "#16161e";
    active_tab_font_style = "bold";
    inactive_tab_foreground = "#787c99";
    inactive_tab_background = "#16161e";
    inactive_tab_font_style = "bold";
    tab_bar_background = "#101014";
  };
  programs.kitty.font = {
    package = (pkgs.nerdfonts.override { fonts = [ "VictorMono" ]; });
    name = "VictorMono Nerd Font Mono";
  };

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
}
