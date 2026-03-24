# modules/nixos/audio.nix
# Audio stack: PipeWire replaces PulseAudio.
# PipeWire provides modern low-latency audio + ALSA + Bluetooth audio support.
{ ... }:

{
  services.pulseaudio.enable = false;  # disable PulseAudio; PipeWire takes over
  security.rtkit.enable      = true;   # rtkit gives PipeWire real-time priority

  services.pipewire = {
    enable            = true;   # main PipeWire daemon
    alsa.enable       = true;   # ALSA compat layer (DAWs, games, etc.)
    alsa.support32Bit = true;   # needed for 32-bit apps (Steam, Wine)
    pulse.enable      = true;   # PulseAudio compat API (most desktop apps use this)
  };
}
