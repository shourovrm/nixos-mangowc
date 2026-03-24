# modules/nixos/locale.nix
# Timezone, default locale, and per-category locale overrides.
# Strategy: UI in en_US, measurements/currency/phone in Bangladeshi locale.
{ ... }:

{
  time.timeZone      = "Asia/Dhaka";    # GMT+6, no DST
  i18n.defaultLocale = "en_US.UTF-8";  # primary language / text encoding

  # Per-category overrides: use en_GB for formatting (DD/MM, A4 paper, metric)
  # and bn_BD for monetary and telephone (Bangladeshi conventions).
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "en_GB.UTF-8";  # postal address format
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT    = "en_GB.UTF-8";  # metric system
    LC_MONETARY       = "bn_BD";        # BDT currency symbol
    LC_NAME           = "en_GB.UTF-8";
    LC_NUMERIC        = "en_GB.UTF-8";
    LC_PAPER          = "en_GB.UTF-8";  # A4 paper size
    LC_TELEPHONE      = "bn_BD";        # Bangladesh phone format
    LC_TIME           = "en_GB.UTF-8";  # DD/MM/YYYY date format
  };
}
