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

  home.stateVersion = "25.05";
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
    sudo darwin-rebuild switch --flake .#$argv[1]
    popd
  '';
  programs.fish.functions.garbage = ''
    echo "Cleaning Nix..."
    nix-collect-garbage -d
    echo "Cleaning Docker..."
    docker image prune --all --force
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

  programs.tmux.enable = true;
  programs.tmux.shortcut = "a";
  programs.tmux.baseIndex = 1;
  programs.tmux.escapeTime = 0;
  programs.tmux.keyMode = "vi";
  programs.tmux.shell = "${pkgs.fish}/bin/fish";
  programs.tmux.terminal = "xterm-256color";
  programs.tmux.mouse = true;
  programs.tmux.focusEvents = true;
  programs.tmux.plugins = with pkgs.tmuxPlugins; [
    sensible
    resurrect
    {
      plugin = continuum;
      extraConfig = ''
        set -g @continuum-restore 'on'
      '';
    }
    {
      plugin = catppuccin;
      extraConfig = ''
        set -g @catppuccin_flavor 'frappe'
        set -g @catppuccin_status_background 'none'
        set -g @catppuccin_window_status_style 'none'
        set -g @catppuccin_pane_status_enabled 'off'
        set -g @catppuccin_pane_border_status 'off'
      '';
    }
  ];
  programs.tmux.extraConfig = ''
    set -ga terminal-overrides ",xterm-256color:Tc"

    set -g status-position top
    set -g status-justify "absolute-centre"
    set -g status-interval 5

    set -g status-left-length 100
    set -g status-left ""
    set -ga status-left "#{?client_prefix,#{#[fg=#{@thm_fg},bold]  #S },#{#[fg=#{@thm_green}]  #S }}"
    set -ga status-left "#[fg=#{@thm_overlay_0},none]│"
    set -ga status-left "#[fg=#{@thm_maroon}]  #{pane_current_command} "
    set -ga status-left "#[fg=#{@thm_overlay_0},none]│"
    set -ga status-left "#[fg=#{@thm_blue}]  #{=/-32/...:#{s|$USER|~|:#{b:pane_current_path}}} "
    set -ga status-left "#[fg=#{@thm_overlay_0},none]#{?window_zoomed_flag,│,}"
    set -ga status-left "#[fg=#{@thm_yellow}]#{?window_zoomed_flag,  zoom ,}"

    set -g status-right-length 100
    set -g status-right ""
    set -ga status-right "#[fg=#{@thm_blue}] 󰭦 %m-%d 󰅐 %H:%M "

    set -g window-status-format " #I#{?#{!=:#{window_name},Window},: #W,} "
    set -g window-status-style "fg=#{@thm_overlay_0}"
    set -g window-status-last-style "fg=#{@thm_rosewater}"
    set -g window-status-activity-style "fg=#{@thm_red}"
    set -g window-status-bell-style "fg=#{@thm_red},bold"
    set -gF window-status-separator "#[fg=#{@thm_overlay_0}]│"

    set -g window-status-current-format " #I#{?#{!=:#{window_name},Window},: #W,} "
    set -g window-status-current-style "fg=#{@thm_peach},bold"
  '';

  programs.vim.enable = true;

  programs.git.enable = true;
  programs.git.settings.user.name = "Pablo Guerrero";
  programs.git.settings.user.email = "pablogq@outlook.com";
  programs.git.includes = [
    {
      condition = "gitdir:~/code/github/slidebean/";
      path = "~/code/github/slidebean/.gitconfig";
    }
    {
      condition = "gitdir:~/code/bitbucket/foshtech/";
      path = "~/code/bitbucket/foshtech/.gitconfig";
    }
    {
      condition = "gitdir:~/code/github/betanysports/";
      path = "~/code/github/betanysports/.gitconfig";
    }
  ];
  programs.git.settings = {
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
