# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./tmpfs.nix
    ];



  #---------------------------------------------------------------------
  # Bootloader - EFI
  #---------------------------------------------------------------------
  boot = {
    tmp.cleanOnBoot = true;
    loader = {
      efi.canTouchEfiVariables = true;    # Enables the ability to modify EFI variables.
      systemd-boot.enable = true;         # Activates the systemd-boot bootloader.

    };
     
    kernelParams = [
      "quiet"
      # "splash"
      # "boot.shell_on_fail"
      "loglevel=0"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=0"
      "udev.log_priority=0"
    ];
    consoleLogLevel = 0;
    # https://github.com/NixOS/nixpkgs/pull/108294


    initrd.systemd.enable = true;         # Enables systemd services in the initial ramdisk (initrd).
    initrd.verbose = true;               # silent boot
    plymouth = {
      enable = true;
      theme = "spinner_alt";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "spinner_alt" ];
        })
      ];
    };  
   
  };



  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Panama";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_PA.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_PA.UTF-8";
    LC_IDENTIFICATION = "es_PA.UTF-8";
    LC_MEASUREMENT = "es_PA.UTF-8";
    LC_MONETARY = "es_PA.UTF-8";
    LC_NAME = "es_PA.UTF-8";
    LC_NUMERIC = "es_PA.UTF-8";
    LC_PAPER = "es_PA.UTF-8";
    LC_TELEPHONE = "es_PA.UTF-8";
    LC_TIME = "es_PA.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.displayManager.autoLogin = false;
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    # theme = "catppuccin-mocha";
    # package = pkgs.kdePackages.sddm;
  };
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "latam";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "la-latin1";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

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
  # programs.home-manager.enable = true;
  users.users.wux4an = {
    isNormalUser = true;
    description = "wux4an";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    packages = with pkgs; [
      kdePackages.bluez-qt
      kdePackages.kcharselect
      libsForQt5.partitionmanager
      kdePackages.isoimagewriter
      bluez-tools
      bluez
      bluez-alsa
      fish 
      tmux
      git
      vscodium
      conda
      starship
      nodejs_22
      firefox
      obsidian
      yakuake
      keepassxc
      vim
      vlc
      papirus-icon-theme
      rar
      zip
      unzip
      ffmpeg
      mpv
      openssh
      podman-tui
      podman-compose
      tree
      topgrade
      neofetch
      cava
      cmatrix
      kittysay
      bat
      wget
      helix
      figlet
      espeak
      glow
    ];
  };

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-extra
      noto-fonts-emoji
      source-han-sans
      font-awesome
      open-sans
      fira-code
      fira-code-symbols
      (nerdfonts.override { fonts = [ "FiraMono" "SpaceMono" "ShareTechMono" ]; })
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" "Source Han Serif" ];
        sansSerif = [ "Open Sans" "Source Han Sans" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  #Shell Configuration
  users.users.wux4an.shell = pkgs.fish;
  programs.fish.enable = true;

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = false;
  # services.xserver.displayManager.autoLogin.user = "dell-inck";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [{}];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  
  # Virtualization
  # virtualisation.libvirtd.enable = true;
  # programs.virt-manager.enable = true;


  # Container Virtualization
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
    
   # docker = {
   #   enable = true;
   #   rootless = {
   #     enable = true;
   #	 setSocketVariable = true;
   #   };
   # };
  };
 
  
  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  
  # Other Config
  programs.dconf.enable = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    conda
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
