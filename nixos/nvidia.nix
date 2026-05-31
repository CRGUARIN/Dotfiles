{ config, pkgs, ... }:

{
  # Soporte de gráficos y drivers NVIDIA (configurado para Victus 16)
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Clave para Steam y juegos viejos
  };

  # Decirle al sistema que use el driver propietario de Nvidia
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Driver open-source moderno (ideal para las Turing/Ampere/Ada de laptops)
    open = true;

    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Modo Híbrido Inteligente (Offload)
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true; # Te genera el comando 'nvidia-offload'
      };

      # IDs de hardware verificados de tu laptop
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
