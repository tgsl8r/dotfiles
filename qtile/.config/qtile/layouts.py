# Layout configuration

from libqtile import layout
from libqtile.config import Match
from colors import colors

# Default style
layout_theme = {"border_width": 3,
                "margin": 0,
                "border_focus": colors['neutral_green'],
                "border_normal": colors['dark0']
                }

layouts = [
    layout.Columns(**layout_theme),
    layout.MonadTall(**layout_theme, single_border_width=2),
    layout.Stack(num_stacks=2, **layout_theme),
    layout.Max(),
    layout.Bsp(**layout_theme),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),

]

floating_layout = layout.Floating(
    **layout_theme,
    float_rules=[
        # *layout.Floating.default_float_rules,
        Match(title='Quit and close tabs?'),
        Match(wm_type='utility'),
        Match(wm_type='notification'),
        Match(wm_type='toolbar'),
        Match(wm_type='splash'),
        Match(wm_type='dialog'),
        Match(wm_class='gimp-2.99'),
        Match(wm_class='file_progress'),
        Match(wm_class='confirm'),
        Match(wm_class='dialog'),
        Match(wm_class='download'),
        Match(wm_class='error'),
        Match(wm_class='notification'),
        Match(wm_class='splash'),
        Match(wm_class='toolbar'),
        Match(title='About LibreOffice'),
        Match(wm_class='confirmreset'),  # gitk
        Match(wm_class='makebranch'),  # gitk
        Match(wm_class='maketag'),  # gitk
        Match(wm_class='ssh-askpass'),  # ssh-askpass
        Match(title='branchdialog'),  # gitk
        Match(wm_class='pinentry-qt'),  # GPG key password entry
        # Match(func=lambda c: c.is_transient_for()),  # automatically float a window if it has a parent
    ],
)
