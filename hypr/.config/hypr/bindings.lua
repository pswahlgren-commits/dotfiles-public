-- Personal keybinding overrides.  Add new bindings, or unbind a default
-- before rebinding the same key.
--
-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- Screenshot on a free combo, for keyboards with no PRINT key at all.
-- "fullscreen" skips the manual region click/drag: one keypress captures and
-- saves the focused monitor immediately (still copies to clipboard too).
o.bind("SUPER + SHIFT + CTRL + S", "Screenshot", "omarchy-capture-screenshot fullscreen")

-- Some keyboards (Logitech MX Keys among them) have no real PRINT keysym:
-- the key printed "Print Screen" actually sends Windows' modern screenshot
-- shortcut, Super+Shift+S, which you can confirm with `wev`.  That combo is
-- bound to a web app by default in Omarchy, so pressing the key opens a
-- browser instead of capturing anything.  Unbind it and use the key for what
-- its keycap says.
hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Screenshot (region)", "omarchy-capture-screenshot")

-- Snap the active window to a screen position using a numpad layout:
--   7 8 9      top-left / top half / top-right
--   4 5 6  ->  left half / maximize / right half
--   1 2 3      bottom-left / bottom half / bottom-right
--
-- Forces the window floating, then moves + resizes it to an exact percentage
-- of the current monitor.
--
-- Hyprland 0.56's Lua dispatch API dropped the old "moveactive/resizeactive
-- exact X%" string dispatchers in favour of hl.dsp.window.* calls that only
-- take absolute pixels, not percentages -- so the math, and the float/resize/
-- move ordering (resize keeps the window's centre fixed, so it has to run
-- before move or the position comes out wrong), live in a real script rather
-- than a one-line hyprctl --batch string.  See bin/hypr-snap-window.
local function snap(x, y, w, h)
  return ("hypr-snap-window %d %d %d %d"):format(x, y, w, h)
end

-- Each corner/edge is bound twice: once for the NumLock-on keysym (KP_7 etc.)
-- and once for the NumLock-off/navigation keysym the same physical numpad key
-- sends (KP_Home etc).
--
-- This matters more than it looks.  Hyprland resolves a plain "SUPER + KP_7"
-- bind against whatever numpad keysym was active when the config loaded, and
-- a NumLock toggle at runtime desyncs it from what the key actually sends.
-- The bind then silently never matches -- the keypress passes straight
-- through to the focused client instead of triggering the dispatcher, with no
-- error anywhere.  Binding both keysyms makes it work regardless of NumLock
-- state, and is harmless on a keyboard with no numpad: those keysyms simply
-- never get sent.
local function bind_snap(kp_key, nav_key, description, x, y, w, h)
  local dispatcher = snap(x, y, w, h)
  o.bind("SUPER + " .. kp_key, description, dispatcher)
  o.bind("SUPER + " .. nav_key, description, dispatcher)
end

bind_snap("KP_7", "KP_Home", "Snap window top-left", 0, 0, 50, 50)
bind_snap("KP_9", "KP_Prior", "Snap window top-right", 50, 0, 50, 50)
bind_snap("KP_1", "KP_End", "Snap window bottom-left", 0, 50, 50, 50)
bind_snap("KP_3", "KP_Next", "Snap window bottom-right", 50, 50, 50, 50)
bind_snap("KP_8", "KP_Up", "Snap window top half", 0, 0, 100, 50)
bind_snap("KP_2", "KP_Down", "Snap window bottom half", 0, 50, 100, 50)
bind_snap("KP_4", "KP_Left", "Snap window left half", 0, 0, 50, 100)
bind_snap("KP_6", "KP_Right", "Snap window right half", 50, 0, 50, 100)
bind_snap("KP_5", "KP_Begin", "Maximize window", 0, 0, 100, 100)

-- Same left/right snap on the easiest possible combo: plain Alt+arrow, no
-- Super needed, so it also works on keyboards without a numpad.
--
-- Trade-off, accepted: Alt+Left/Right is also the conventional back/forward
-- shortcut in browsers and file managers.  Binding it globally in Hyprland
-- means that stops working everywhere -- use the mouse back/forward buttons
-- or Backspace instead.
--
-- Real tiling (dwindle), not floating: floating windows always render above
-- tiled ones in Hyprland regardless of focus, so two floating snapped windows
-- covering the screen hide anything opened afterwards -- a file manager that
-- tiles by default opens behind them and is unreachable.  Tiling doesn't have
-- that problem: every tiled window stays on the visible layer, and other
-- tiled windows adapt to the new one automatically.
o.bind("ALT + LEFT", "Tile window left", "hypr-tile-window left")
o.bind("ALT + RIGHT", "Tile window right", "hypr-tile-window right")
