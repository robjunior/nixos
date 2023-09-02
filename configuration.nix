# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Mount the great XOL HD
  fileSystems."/mnt/xol" = {
    device = "/dev/sda1";
    fsType = "ext4";  # Replace with the appropriate filesystem type
  };

  fileSystems."/mnt/xeol" = {
    device = "/dev/sdc1";
    fsType = "ntfs";  # Replace with the appropriate filesystem type
  };

  networking = {
    hostName = "xenon";
    networkmanager = {
      enable = true;
    };
  };
  
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Make sure opengl is enabled
	hardware.opengl = {
	  enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Tell Xorg to use the nvidia driver (also valid for Wayland)
  hardware.nvidia = {
    # Modesetting is needed for most Wayland compositors
    modesetting.enable = true;
    # Use the open source version of the kernel module
    # Only available on driver 515.43.04+
    open = false;
    # Enable the nvidia settings menu
    nvidiaSettings = true;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";

  # Xserver Config
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
    layout = "us";
    xkbVariant = "altgr-intl";
    xkbOptions = "compose:menu";

    desktopManager = {
      xterm = { enable = false; };
    };
    displayManager = {
      defaultSession = "none+i3";
      lightdm = { enable = true; };
      autoLogin = {
        enable = true;
        user = "xenon";
      };
    };
    windowManager = {
      i3 = { enable = true; };
    };
    libinput = {
      enable = true;
      # disabling mouse acceleration
      mouse = {
        accelProfile = "flat";
      };
      # disabling touchpad acceleration
      touchpad = {
        accelProfile = "flat";
      };
    };
  };

  # Pipewire (sound) configuration
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define xenon user account
  users.users.xenon = {
    isNormalUser = true;
    description = "Xenon";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Thunar
  programs.thunar.enable = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    polybar
    alacritty
    spotify
    lutris
    wget
    scrot
    gimp
    inkscape
    git
    rofi
    obsidian
    transmission-qt
    (wine.override { wineBuild = "wine64"; })
    (pkgs.discord.override {
        # remove any overrides that you don't want
        withOpenASAR = true;
        withVencord = true;
    })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

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
  system.stateVersion = "23.05"; # Did you read the comment?  
}