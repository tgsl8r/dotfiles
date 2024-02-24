#!/usr/bin/env python3
import alduin.draw

# Load existing settings made via :set
config.load_autoconfig(True)

# everforest.draw.konda(c, {"spacing": {"vertical": 5, "horizontal": 8}})
alduin.draw.konda(c)

c.fonts.default_family = "monospace"
c.fonts.hints = "12pt monospace"
c.fonts.keyhint = "12pt monospace"
c.fonts.prompts = "12pt monospace"
c.fonts.downloads = "12pt monospace"
c.fonts.statusbar = "12pt monospace"
c.fonts.contextmenu = "12pt monospace"
c.fonts.messages.info = "12pt monospace"
c.fonts.debug_console = "12pt monospace"
c.fonts.completion.entry = "12pt monospace"
c.fonts.completion.category = "12pt monospace"
c.url.start_pages = "~/.config/qutebrowser/startpage/index.html"
c.url.default_page = "~/.config/qutebrowser/startpage/index.html"
c.editor.command = ["/usr/bin/alacritty", "-e", "/usr/bin/vim {}"]

c.colors.webpage.darkmode.enabled =  False

# Tor browsing
# c.content.proxy = 'socks5://localhost:9050/'
c.url.searchengines = {
    "DEFAULT": "https://start.duckduckgo.com/?q={}",
    "aw": "https://wiki.archlinux.org/?search={}",
    "gh": "https://github.com/{unquoted}",
    "ghs": "https://github.com/search?q={}",
    "r": "https://www.reddit.com/r/{unquoted}",
    "rs": "https://www.reddit.com/search?q={}",
    "wiki": "https://en.wikipedia.org/wiki/{}",
    "gg": "https://www.google.com/search?q={}",
    "yt": "https://www.youtube.com/results?search_query={}",
}
# config.set("colors.webpage.darkmode.enabled", False)


# Toggle darkmode css
config.bind(
    ",t",
    'config-cycle content.user_stylesheets ~/.config/qutebrowser/alduin/alduin-all-sites.css ""',
)

# Qute-pass keubindings
config.bind(
    ",pp",
    "spawn --userscript qute-pass -d bemenu",
)

config.bind(
    ",pu",
    "spawn --userscript qute-pass --username-only -d bemenu",
)

config.bind(
    ",m",
    "spawn mpv {url}",
)

config.bind(
    ",M",
    "hint links spawn mpv {hint-url}",
)

config.bind(
    ",pP",
    "spawn --userscript qute-pass --password-only -d bemenu",
)

# Open download
config.bind(
    ",d",
    "spawn --userscript open_download",
)

# Cycle inputs
config.bind(
    "gi",
    "jseval -q -f ~/.config/qutebrowser/cycle-inputs.js",
)
