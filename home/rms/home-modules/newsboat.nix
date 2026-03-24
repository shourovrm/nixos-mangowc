# home/rms/home-modules/newsboat.nix
# Newsboat RSS/Atom reader configuration via Home Manager.
#
# Config highlights:
#   - Vim-style keybindings (j/k/h/l navigation)
#   - link-handler as the default browser (smart URL dispatcher)
#   - fuzzel-handler accessible via macro 'd'
#   - yt-dlp queued audio/video downloads via qndl (macros 'a' / 't')
#   - links2 text browser via macro 'w'
#   - wl-copy for clipboard (macro 'c')
#   - mpv for video (macro 'v')
#   - Highlights styled to complement Noctalia Monochrome theme
#
# The newsboat URLs file (~/.config/newsboat/urls) is managed via
# home.file so it can hold the long arxiv query strings without
# fighting Nix's string escaping.
{ pkgs, ... }:

{
  programs.newsboat = {
    enable = true;

    # auto-reload on start; keeps feeds fresh when opened
    autoReload = true;

    # ── Keybindings ────────────────────────────────────────────────────────
    # Vim-style navigation throughout all views
    extraConfig = ''
      # ── Browser / URL handling ─────────────────────────────────────────
      # Default browser: smart dispatcher (video→mpv, pdf→zathura, text→nvim)
      browser link-handler

      # External URL viewer: show article links in a TUI selector
      external-url-viewer "urlscan -dc -r 'link-handler {}'"

      # ── Vim-style keybindings ──────────────────────────────────────────
      bind-key j down
      bind-key k up
      bind-key j next articlelist
      bind-key k prev articlelist
      bind-key J next-feed articlelist
      bind-key K prev-feed articlelist
      bind-key G end
      bind-key g home
      bind-key d pagedown
      bind-key u pageup
      bind-key l open
      bind-key h quit
      bind-key a toggle-article-read
      bind-key n next-unread
      bind-key N prev-unread
      bind-key D pb-download
      bind-key U show-urls
      bind-key x pb-delete

      # ── Macros (triggered with , then the letter) ─────────────────────
      # ,v  play in mpv
      macro v set browser "mpv" ; open-in-browser ; set browser link-handler
      # ,t  queue full video download via yt-dlp
      macro t set browser "qndl" ; open-in-browser ; set browser link-handler
      # ,a  queue audio-only download via yt-dlp
      macro a set browser "qndl-audio" ; open-in-browser ; set browser link-handler
      # ,w  open in links2 text browser (new foot window)
      macro w set browser "foot links2" ; open-in-browser ; set browser link-handler
      # ,d  fuzzel handler menu: choose how to open
      macro d set browser "fuzzel-handler" ; open-in-browser ; set browser link-handler
      # ,c  copy URL to Wayland clipboard (wl-copy accepts URL as argument)
      macro c set browser "wl-copy" ; open-in-browser ; set browser link-handler
      # ,,  open-in-browser with default handler
      macro , open-in-browser

      # ── Colours (Noctalia Monochrome-compatible palette) ───────────────
      color listnormal            cyan      default
      color listfocus             black     yellow    standout bold
      color listnormal_unread     blue      default
      color listfocus_unread      yellow    default   bold
      color info                  red       black     bold
      color article               white     default   bold

      # ── Highlights inside articles ────────────────────────────────────
      highlight all "---.*---" yellow
      highlight feedlist ".*(0/0))" black
      highlight article "(^Feed:.*|^Title:.*|^Author:.*)" cyan default bold
      highlight article "(^Link:.*|^Date:.*)" default default
      highlight article "https?://[^ ]+" green default
      highlight article "^(Title):.*$" blue default
      highlight article "\\[[0-9][0-9]*\\]" magenta default bold
      highlight article "\\[image\\ [0-9]+\\]" green default bold
      highlight article "\\[embedded flash: [0-9][0-9]*\\]" green default bold
      highlight article ":.*\\(link\\)$" cyan default
      highlight article ":.*\\(image\\)$" blue default
      highlight article ":.*\\(embedded flash\\)$" magenta default
    '';
  };

  # ── Feed URLs ─────────────────────────────────────────────────────────────
  # Managed as a plain file so the long arxiv query strings stay readable.
  # Each line: <url> "<title>" "<tag>"
  home.file.".config/newsboat/urls".text = ''
    # ── News ──────────────────────────────────────────────────────────────
    https://rss.nytimes.com/services/xml/rss/nyt/MostViewed.xml "~NYTimes Most Viewed" "news"
    https://feeds.bbci.co.uk/news/world/rss.xml "~BBC World News" "news"

    # ── Reddit multireddits ────────────────────────────────────────────────
    https://old.reddit.com/user/rmshourov/m/islam/.rss "~Islam - Multireddit" "reddit"
    https://old.reddit.com/user/rmshourov/m/ml_research/.rss "~ML Research - Multireddit" "reddit"
    https://old.reddit.com/user/rmshourov/m/ai_misc/.rss "~AI Misc - Multireddit" "reddit"
    https://old.reddit.com/user/rmshourov/m/grad_admission/.rss "~Grad Admission - Multireddit" "reddit"
    https://old.reddit.com/user/rmshourov/m/computer_architecture/.rss "~Computer Architecture - Multireddit" "reddit"
    https://old.reddit.com/user/rmshourov/m/exercise/.rss "~Exercise - Multireddit" "reddit"
    https://old.reddit.com/user/rmshourov/m/quantum/.rss "~Quantum - Multireddit" "reddit"
    https://old.reddit.com/user/rmshourov/m/neuro/.rss "~Neuro - Multireddit" "reddit"

    # ── YouTube channels ───────────────────────────────────────────────────
    https://www.youtube.com/feeds/videos.xml?channel_id=UCJgIbYl6C5no72a0NUAPcTA "~GPU MODE - YouTube" "youtube"
    https://www.youtube.com/feeds/videos.xml?channel_id=UCKHcqMU3zRT2qGduHcygJXw "~FHE.org - YouTube" "youtube" "cyber security"

    # ── arXiv queries ──────────────────────────────────────────────────────
    https://export.arxiv.org/api/query?search_query=((all:%22zero+knowledge%22+OR+all:ZKP+OR+all:zkSNARK+OR+all:zkSTARK)+OR+(all:%22fully+homomorphic+encryption%22+OR+all:FHE)+OR+(all:%22hardware+security%22+OR+all:%22secure+hardware%22+OR+all:%22secure+accelerator%22+OR+all:TEE)+OR+(all:%22side-channel%22+OR+all:%22power+analysis%22+OR+all:DPA+OR+all:SPA+OR+all:%22timing+attack%22))+AND+(all:hardware+OR+all:accelerator+OR+all:FPGA+OR+all:ASIC)+AND+(all:architecture+OR+all:pipeline+OR+all:throughput+OR+all:latency)+AND+(cat:cs.CR+OR+cat:cs.AR)&sortBy=submittedDate&sortOrder=descending&max_results=50 "~Secure Crypto HW Accelerators - Combined" "arxiv"
    https://export.arxiv.org/api/query?search_query=(all:%22fully+homomorphic+encryption%22+OR+all:FHE)+AND+(all:hardware+OR+all:accelerator+OR+all:FPGA+OR+all:ASIC)+AND+(cat:cs.CR+OR+cat:cs.AR)&sortBy=submittedDate&sortOrder=descending&max_results=50 "~FHE Hardware Accelerators" "arxiv"
    https://export.arxiv.org/api/query?search_query=(all:accelerator)+AND+(all:cryptography+OR+all:crypto+OR+all:encryption)+AND+(cat:cs.AR+OR+cat:cs.ET+OR+cat:cs.CR)&sortBy=submittedDate&sortOrder=descending&max_results=50 "~Crypto Hardware Accelerators" "arxiv"
    https://export.arxiv.org/api/query?search_query=(all:%22zero+knowledge%22+OR+all:ZKP+OR+all:zkSNARK+OR+all:zkSTARK)+AND+(all:hardware+OR+all:accelerator+OR+all:FPGA+OR+all:ASIC)+AND+(cat:cs.CR+OR+cat:cs.AR)&sortBy=submittedDate&sortOrder=descending&max_results=50 "~ZKP Hardware Accelerators" "arxiv"
    https://export.arxiv.org/api/query?search_query=(all:%22hardware+security%22+OR+all:%22secure+accelerator%22+OR+all:%22trusted+execution%22+OR+all:TEE)+AND+(all:hardware+OR+all:accelerator+OR+all:FPGA+OR+all:ASIC)+AND+(cat:cs.CR+OR+cat:cs.AR)&sortBy=submittedDate&sortOrder=descending&max_results=50 "~Hardware Security Accelerators" "arxiv"
    https://export.arxiv.org/api/query?search_query=(all:FPGA)+AND+(all:cryptography+OR+all:crypto+OR+all:encryption+OR+all:ZKP+OR+all:zkSNARK+OR+all:zkSTARK+OR+all:%22fully+homomorphic+encryption%22+OR+all:FHE)+AND+(cat:cs.AR+OR+cat:cs.CR)&sortBy=submittedDate&sortOrder=descending&max_results=50 "~FPGA Crypto Accelerators" "arxiv"
    https://export.arxiv.org/api/query?search_query=(all:ASIC)+AND+(all:cryptography+OR+all:crypto+OR+all:encryption+OR+all:ZKP+OR+all:zkSNARK+OR+all:zkSTARK+OR+all:%22fully+homomorphic+encryption%22+OR+all:FHE)+AND+(cat:cs.AR+OR+cat:cs.CR)&sortBy=submittedDate&sortOrder=descending&max_results=50 "~ASIC Crypto Accelerators" "arxiv"
    https://export.arxiv.org/api/query?search_query=((all:GPU+OR+all:CUDA+OR+all:%22graphics+processor%22)+AND+(all:cryptography+OR+all:crypto+OR+all:encryption+OR+all:%22zero+knowledge%22+OR+all:ZKP+OR+all:zkSNARK+OR+all:zkSTARK+OR+all:%22fully+homomorphic+encryption%22+OR+all:FHE+OR+all:%22hardware+security%22+OR+all:%22side-channel%22+OR+all:%22power+analysis%22+OR+all:%22timing+attack%22))+AND+(cat:cs.CR+OR+cat:cs.AR+OR+cat:cs.DC)&sortBy=submittedDate&sortOrder=descending&max_results=50 "~GPU Accelerators for Security & Crypto" "arxiv"
    https://export.arxiv.org/api/query?search_query=((all:%22AI+accelerator%22+OR+all:%22machine+learning+accelerator%22+OR+all:NPU+OR+all:TPU)+OR+((all:GPU+OR+all:FPGA+OR+all:ASIC)+AND+(all:%22neural+network%22+OR+all:%22deep+learning%22)))+AND+(all:architecture+OR+all:datapath+OR+all:memory+OR+all:throughput+OR+all:latency)+AND+(cat:cs.AR)&sortBy=submittedDate&sortOrder=descending&max_results=50 "~AI Accelerators" "arxiv"
    https://export.arxiv.org/api/query?search_query=((all:neuromorphic+OR+all:%22spiking+neural+network%22+OR+all:SNN+OR+all:%22event-driven%22+OR+all:%22brain-inspired%22)+AND+(all:architecture+OR+all:accelerator+OR+all:hardware+OR+all:processor+OR+all:ASIC+OR+all:FPGA))+AND+(cat:cs.AR+OR+cat:cs.NE+OR+cat:cs.AI)&sortBy=submittedDate&sortOrder=descending&max_results=50 "~Neuromorphic Models & Architectures" "arxiv"
  '';
}
