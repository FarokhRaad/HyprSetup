--Place this file in your .xmonad/lib directory and import module Colors into .xmonad/xmonad.hs config
--The easy way is to create a soft link from this file to the file in .xmonad/lib using ln -s
--Then recompile and restart xmonad.

module Colors
    ( wallpaper
    , background, foreground, cursor
    , color0, color1, color2, color3, color4, color5, color6, color7
    , color8, color9, color10, color11, color12, color13, color14, color15
    ) where

-- Shell variables
-- Generated by 'wal'
wallpaper="/home/farokh/wallpaper/astronaut_jellyfish.jpg"

-- Special
background="#0F161E"
foreground="#8ae1c1"
cursor="#8ae1c1"

-- Colors
color0="#0F161E"
color1="#32514E"
color2="#595A59"
color3="#B85154"
color4="#30A95B"
color5="#B6A743"
color6="#94439B"
color7="#8ae1c1"
color8="#609d87"
color9="#32514E"
color10="#595A59"
color11="#B85154"
color12="#30A95B"
color13="#B6A743"
color14="#94439B"
color15="#8ae1c1"
