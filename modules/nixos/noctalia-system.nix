# modules/nixos/noctalia-system.nix
# System-level services required by the Noctalia bar widgets.
# Bluetooth, power profiles, and battery status all need kernel/system daemons.
{ ... }:

{
  # Bluetooth: hardware support + blueman applet (used by Noctalia Bluetooth widget)
  hardware.bluetooth.enable      = true;   # load kernel Bluetooth stack
  hardware.bluetooth.powerOnBoot = true;   # adapter on by default after boot
  services.blueman.enable        = true;   # blueman-manager for pairing / agent

  # power-profiles-daemon: enables Balanced / Power-Saver / Performance switching.
  # NOTE: conflicts with services.tuned — use one or the other, not both.
  services.power-profiles-daemon.enable = true;

  # UPower: battery level / charging state polling used by Noctalia Battery widget
  services.upower.enable = true;
}
