# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, modulesPath, lib, inputs, home-manager, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
     # inputs.nixos-cosmic.nixosModules.default
     inputs.home-manager.nixosModules.default
    ];
   
  # XWayland
  programs.xwayland = {
  enable = false;
  };

############ amdgpu setup #############
#   Enable OpenGL
#  hardware.opengl = {
#    enable = true;
#    driSupport = true;
#    driSupport32Bit = true;
#  };

#  hardware.opengl.extraPackages = with pkgs; [
#  amdvlk
#  ];
# For 32 bit applications
#  hardware.opengl.extraPackages32 = with pkgs; [
#  driversi686Linux.amdvlk
#  ];
#  
#  # Load nvidia driver for Xorg and Wayland
#  services.xserver.videoDrivers = ["amdgpu radeon"];
#  
#  hardware.nvidia = {
#
#    # Modesetting is required.
#    modesetting.enable = true;
#
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
#    powerManagement.enable = false;
 #   # Fine-grained power management. Turns off GPU when not in use.
 #   # Experimental and only works on modern Nvidia GPUs (Turing or newer).
 #   powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
#    open = false;

    # Enable the Nvidia settings menu,
# accessible via `nvidia-settings`.
#    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
#    package = config.boot.kernelPackages.nvidiaPackages.stable;
#  };

  # Bootloader
  #boot.loader.grub.enable = true;
  #boot.loader.grub.device = "nodev";
  #boot.loader.grub.fontSize = "20";
  #boot.loader.grub.configurationLimit = 7;
  #boot.loader.grub.useOSProber = false;
 
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.modprobeConfig.enable = true;
  # services.hddfancontrol.enable = true;
 
  boot.initrd.kernelModules = ["kvm-intel"];
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  #direnv
  programs.direnv.enable = true;
  programs.direnv.loadInNixShell = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.silent = true;    

  networking.hostName = "wolvesden"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Detroit";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # gnome desktop
  programs.dconf.enable = true;
  nixpkgs.config.allowAliases = false;
  services.sysprof.enable = true;
  # nixpkgs.config.firefox.enableGnomeExtensions = true;
 
  # hyprland
  # programs.hyprland.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkbVariant = "";
  };

  # enable flatpak
  services.flatpak.enable = true;
 
  # xdg portals
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-cosmic pkgs.xdg-desktop-portal-hyprland ];
  xdg.portal.config.common.default = "gtk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.densetsu = {
    isNormalUser = true;
    description = "densetsu";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      ungoogled-chromium
      vlc
    ];
  };

  # for virtualization like gnome-boces or virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # podman
  virtualisation.podman.enable = true;
  # virtualisation.podman.networkSocket.enable = true;

  # docker
  virtualisation.docker.enable = true;
  # virtualisation.podman.dockerSocket.enable = true;
 
  #spices (virtualization)
  services.spice-vdagentd.enable = true;  
 
  # LF file manager
  # programs.lf.enable = true;

  # ZRAM
  zramSwap.enable = true;
 
  # zsh terminal
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable Flakes and the command-line tool with nix command settings
  nix.settings.experimental-features = [ "nix-command flakes"];
 
   # Set default editor to vim
  environment.variables.EDITOR = "lvim";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
   # bash and zsh
    nix-bash-completions
    nix-zsh-completions
    zsh-autocomplete
    zsh-autosuggestions
    zsh-powerlevel10k
    zsh-syntax-highlighting
    zsh-history-substring-search
    zsh-fast-syntax-highlighting
    nixd
    zsh-nix-shell
    nix-search-cli
    pkgs.nvd
    nix-output-monitor
    nix-top
    nix-doc
    nix-pin
    nix-tree
    nix-melt
    nix-info
    nix-diff
    nix-serve
    nix-index
    nix-update
    nix-script
    nix-bundle
    nixos-icons
    nixos-shell
    nix-plugins
    nixpkgs-lint
    nixos-option
    nixos-generators
    nix-build-uncached
    nom
    nitch
    nh
    nil

    # zsh configs
    zsh-z
    zsh-bd
    zsh-abbr
    zsh-defer
    zsh-zhooks
    zsh-prezto
    zsh-forgit
    zsh-f-sy-h
    zsh-nix-shell
    zsh-clipboard
    zsh-completions
    zsh-git-prompt
    zsh-powerlevel10k
    zsh-autocomplete

    # system packages
    gzip
    wget
    curl
    pkgs.libsForQt5.ark
    git
    meson
    gcc
    clang
    zig
    cmake
    ninja
    libsForQt5.full
    libsForQt5.qt5.qtbase
    qt6.full
    lm_sensors
    xsensors
    qt6.qtbase
    gnumake
    gnumake42
    zsh
    fzf-zsh
    tmux
    fastfetch
    lsd
    zsh
    #nitrogen
    pfetch
    neofetch
    gh
    pasystray
    dhcpdump
    btop
    postgresql
    w3m
    usbimager
    wezterm
    lunarvim
    distrobox
    lshw
    rPackages.gbm
    gtk-layer-shell
    clipit
    gvfs
    topgrade
    libvirt
    neocmakelsp
    lua
    toybox
    lsp-plugins
    wayland-protocols
    cheese
   
   # hyprland packages
    yazi
    yazi-unwrapped
    waypaper
    hyprpaper
    xfce.thunar-archive-plugin
    xfce.thunar
    xfce.thunar-volman
    dmenu
    rofi
    autotiling
    lxappearance
    xfce.xfce4-terminal
    xfce.xfce4-settings
    dunst
    pavucontrol
    jgmenu
    picom
    networkmanager_dmenu
    papirus-folders
    papirus-nord
    sweet
    clipmenu
    brightnessctl
    nwg-look
    feh
    wl-clipboard
    wlogout
    ranger
    variety
    clipit
    # volumeicon
    rofi-power-menu
    blueberry
    hyprland-protocols
    libdrm
    wayland
    wayland-protocols
    xdg-desktop-portal-hyprland
    wofi
    kitty
    kitty-themes
    swaybg
    gnumake
    gnumake42
    wl-clipboard
    lxappearance-gtk2

    # waybar appllcations
    # waybar
    #gtkmm3
    #jsoncpp
    #fmt
    #spdlog
    # libgtk-3-dev #[gtk-layer-shell]
    #gobject-introspection #[gtk-layer-shell]
    # libpulse #[Pulseaudio module]
    #libnl #[Network module]
    #libappindicator-gtk3 #[Tray module]
    #libdbusmenu-gtk3 #[Tray module]
    #libmpdclient #[MPD module]
    # libsndio #[sndio module# ]
    #libevdev #[KeyboardState module]
    # xkbregistry
    #upower #[UPower battery module]

   # smartcard applications
    pam_p11
    #pam_usb
    nss
    nss_latest
    pkgs.pcscliteWithPolkit
    pkgs.pcsc-tools
    pkgs.scmccid
    pkgs.ccid
    pkgs.pcsclite
    pkgs.opensc

   # vim and programming langauges
    vim
    neovim
    lunarvim
    vimPlugins.nvim-treesitter-textsubjects
    nodejs_22
    lua
    python3
   
    flam3
    qosmic

    xdg-desktop-portal-cosmic

   # gaming
    sc-controller
    gamescope
    protonup-qt
    lutris
    #steam-run
   
    # applications
    virt-manager
    sublime4
    gnome-boxes
    alacritty
    alacritty-graphics
    kdePackages.okular
    libreoffice-still
    swaybg
    hyprpaper
    brave

   ];
   
   # fonts, folders, themes, icons
    fonts = {
    fonts = with pkgs; [
      noto-fonts
      font-awesome
      font-awesome_5
      font-awesome_4
      source-han-sans
      open-sans
      openmoji-color
      hermit
      source-code-pro
      nerd-fonts.noto
      nerd-fonts.hack
      nerd-fonts.ubuntu
      terminus_font
      jetbrains-mono
      nixos-icons
      material-icons
      material-design-icons
      sweet-folders
      sweet
      powerline-fonts
      corefonts
      google-fonts
      jetbrains-mono
      udev-gothic
      hack-font
      beauty-line-icon-theme
   
     ];

    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Source Han Serif" ];
      sansSerif = [ "Open Sans" "Source Han Sans" ];
      emoji = [ "openmoji-color" ];
      };
    };    

    # NH environment.sessionVariables
   programs.nh = {
   enable = true;
   clean.enable = true;
   clean.extraArgs = "--keep-since 7d --keep 5";
   flake = "/etc/nixos/";
   };

    # cosmic-comp (for clipboard - to copy things in cosmic)
    environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;
    #systemd.packages = [ pkgs.observatory ];
    #systemd.services.monitord.wantedBy = [ "multi-user.target" ];

   # Hyprland window manager
    programs.hyprland.enable = true;
    programs.waybar = { 
    enable = true;
    systemd.target = "hyprland.target";
      };
 
    # withUWSM = true;
    security.pam.services.hyprlock = {};
 

   # nix grub generations
   system.autoUpgrade = {
   enable = true;
   flake = "/etc/nixos/flake.nix";
   flags = [
    "nix-update"
    "nixpkgs"
    "-L" # print build logs
   ];
   operation = "boot";
   randomizedDelaySec = "30min";
   dates = "24:00";
      };
   #nix.settings.auto-optimise-store = true;
   #nix.gc = {
   #automatic = true;
   #dates = "Sun 24:00";
   #options = "--delete-older-than 7d";
   #  };

    nixpkgs.config.permittedInsecurePackages = [
    "nodejs-12.22.12"
    "python-2.7.18.7"
    "nix-2.17.1"
    "openssl-1.1.1w"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

   # Thinkpad
    services.thinkfan.enable = true;
    # services.thinkfan.levels = [ "level auto"];
    # services.tlp.enable = true;
   
  services.power-profiles-daemon.enable = true;


  # List services that you want to enable:
    services.sshd.enable = true;
    services.pcscd.enable = true;
    security.pam.p11.enable = true;
  #  services.teamviewer.enable = true;
    services.postgresql.enable = true;
    services.tailscale.enable = true;
    services.gvfs.enable = true;
    services.smartd.enable = true;
    services.picom.enable = true;
    services.picom.activeOpacity = 0.8;
    services.picom.shadowOpacity = 0.75;
    services.picom.menuOpacity = 0.8;
    #services.pulseaudo.enable = true;

  # list of programs with services
    programs.steam.enable = true;
  #  programs.steam.extest.enable = true;
    programs.gamescope.enable = true;
    programs.zsh.enableLsColors = true;
    programs.zsh.enableCompletion = true;
    programs.zsh.enableBashCompletion = true;
    programs.zsh.autosuggestions.strategy = [
     "history"
      ];
    programs.thunar.enable = true;
    programs.zsh.autosuggestions.async = true;
    virtualisation.kvmgt.enable = true;
    programs.file-roller.enable = true;
     programs.coolercontrol = {
     enable = true;
     nvidiaSupport = false;
       };
 

    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.debian.pcsc-lite.access_pcsc" &&
          subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      });
  '';  
             
   
  # cosmic-desktop & other desktop services
  # List services that you want to enable:
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.desktopManager.xfce.enableXfwm = true;
  services.desktopManager.cosmic.enable = true;
  #services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.xwayland.enable = true;
  services.greetd = {
  enable = true;
  vt = 3;
  settings = {
      default_session = {
    command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd hyprland";
        };
      };
    };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.ports = [
  22 80
   ];

  # Open ports in the firewall.
   networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
