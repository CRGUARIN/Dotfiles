# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nvidia.nix
    ];

  # Bootloader -----------------------------------------------------------------------------------------
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "victus"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Bogota";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_MX.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CO.UTF-8";
    LC_IDENTIFICATION = "es_CO.UTF-8";
    LC_MEASUREMENT = "es_CO.UTF-8";
    LC_MONETARY = "es_CO.UTF-8";
    LC_NAME = "es_CO.UTF-8";
    LC_NUMERIC = "es_CO.UTF-8";
    LC_PAPER = "es_CO.UTF-8";
    LC_TELEPHONE = "es_CO.UTF-8";
    LC_TIME = "es_CO.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable SDDM.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  
  # Keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  #Desktop environments
  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;
  
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "latam";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "la-latin1";

  # Automatic generation clean
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 3d"; # older than 3d
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;
  
  # External devices service 
  services.udisks2.enable = true;

  # Bluetooth service 
  hardware.bluetooth.enable = true; 
  hardware.bluetooth.powerOnBoot = false;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.crguarin = {
    isNormalUser = true;
    description = "CRGUARIN";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Special programs
  programs.steam.enable = true;
  programs.fish.enable = true; 
  
  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono  
    noto-fonts
  ];
 
  # Dynamic executables
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    # Esential 
    pkgs.git
    pkgs.yazi
    pkgs.waybar
    pkgs.swaynotificationcenter
    pkgs.swayosd
    pkgs.bibata-cursors
    
    # Apps 
    pkgs.btop
    pkgs.matugen
    pkgs.spotify
    pkgs.fuzzel
    pkgs.fzf
    pkgs.neovim-unwrapped
    pkgs.neovide
    pkgs.gcc
    pkgs.bluetui
    pkgs.kitty
    pkgs.waypaper
    pkgs.awww
    pkgs.zathura
    pkgs.fastfetch
    pkgs.firefox
    pkgs.wl-clipboard
    pkgs.nwg-look
    
    # Screenshots
    pkgs.grim
    pkgs.slurp
    pkgs.swappy
    pkgs.seahorse
    pkgs.lazygit
    
    # System
    pkgs.wiremix
    pkgs.udiskie
  ];

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

  # Open ports in the firewall.
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
