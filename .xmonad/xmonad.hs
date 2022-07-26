import XMonad

import System.Exit
import Data.Monoid

import Control.Monad ( join, when )
import XMonad.Layout.Fullscreen ( fullscreenEventHook, fullscreenManageHook, fullscreenSupport, fullscreenFull )
import XMonad.Util.SpawnOnce ( spawnOnce )
import XMonad.Hooks.ManageDocks ( avoidStruts, docks, manageDocks )
import XMonad.Hooks.EwmhDesktops ( ewmh )
import XMonad.Layout.Spacing ( spacingRaw, Border(Border) )
import XMonad.Layout.NoBorders
import XMonad.Prompt.ConfirmPrompt
import XMonad.Hooks.ManageHelpers ( doFullFloat, isFullscreen )
import XMonad.Layout.Gaps ( Direction2D(D, L, R, U), gaps, setGaps, GapMessage( DecGap, ToggleGaps, IncGap ) )

import qualified Data.Map as M
import qualified XMonad.StackSet as W
import Data.Maybe ( maybeToList )

myTerminal = "alacritty"
myModMask = mod4Mask
myBorderWidth = 2

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

myNormalBorderColor = "#3b4252"
myFocusedBorderColor = "#3dccec"

myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

rofi_applications = spawn "~/.config/rofi/launchers/colorful/launcher.sh"
rofi_powermenu = spawn "~/.config/rofi/applets/android/powermenu.sh"
maimsave = spawn "maim -s ~/Pictures/$(date +%Y-%m-%d_%H-%M-%S).png"

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
  [
    -- Laucnh terminal. Mod + shift + return
    ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf),
    -- Laucnh rofi applications menu
    ((modm, xK_r), rofi_applications),
    -- Restart xmonad. Mod + shift + r
    ((modm .|. shiftMask, xK_r), spawn "xmonad --recompile; xmonad --restart"),
    -- Quit xmonad. Mod + shift + q
    ((modm .|. shiftMask, xK_q), io(exitWith ExitSuccess)),
    -- Open the powermenu
    ((modm, xK_q), rofi_powermenu),
    -- Kill focused window. Mod + shift + c
    ((modm .|. shiftMask, xK_c), kill),
    -- Rotate through layouts. Mod + space
    ((modm, xK_space), sendMessage NextLayout),
    -- Reset to default layout. mod + shift + space
    ((modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf),
    -- Tab through focused windows. Mod + tab
    ((modm, xK_Tab), windows W.focusDown),
    -- Move focus to next window. Mod + j
    ((modm, xK_j), windows W.focusDown),
    -- Move focus to prevois window. Mod + k
    ((modm, xK_k), windows W.focusUp),
    -- Move focus to master window. Mod + m
    ((modm, xK_m), windows W.focusMaster),
    -- Swap focused window with master. Mod + shift + m
    ((modm .|. shiftMask, xK_m), windows W.swapMaster),
    -- swap focused window with next. Mod + shift + j
    ((modm .|. shiftMask, xK_j), windows W.swapDown),
    -- swap focused window with previous. Mod + shift + k
    ((modm .|. shiftMask, xK_k), windows W.swapUp),
    -- Retile window. Mod + t
    ((modm, xK_t), withFocused $ windows.W.sink),
    -- screen shot
    ((modm, xK_Print), maimsave)

  ]
  ++
  -- mod-[1-9], switch to workspace N
  -- mod-shift-[1-9], move window to workspace N
  [
    ((m.|.modm, k), windows $ f i)
    | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
  ]
  ++

  [
    -- Set focus to sreen 1, 2, 3 -> mod + i | o | p
    -- Move window to screen 1, 2, 3, -> mod + shift + i | o | p
    ((m.|.modm, key), screenWorkspace sc >>= flip whenJust (windows.f))
    | (key,sc) <- zip[xK_i, xK_o, xK_p] [0..]
    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
  ]

myMouseBindings (XConfig {XMonad.modMask=modm}) = M.fromList $
  [
    -- Set the window to floating mode. mod + mouse button 1 (left click)
    ((modm, button1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)),
    -- Raise the window to the top of the stack. mod + mouse button 2 (middle click)
    ((modm, button2), (\w -> focus w >> windows W.shiftMaster)),
    -- Set window to floating mode and resize by dragging. mod + button 3 (right click)
    ((modm, button3), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster))
  ]

addNETSupported :: Atom -> X ()
addNETSupported x = withDisplay $ \dpy -> do
  r <- asks theRoot
  a_NET_SUPPORTED <- getAtom "_NET_SUPPORTED"
  a <- getAtom "ATOM"
  liftIO $ do
    sup <- (join . maybeToList) <$> getWindowProperty32 dpy a_NET_SUPPORTED r
    when (fromIntegral x `notElem` sup) $
      changeProperty32 dpy r a_NET_SUPPORTED a propModeAppend [fromIntegral x]

addEWMHFullscreen :: X ()
addEWMHFullscreen = do
  wms <- getAtom "_NET_WM_STATE"
  wfs <- getAtom "_NET_WM_STATE_FULLSCREEN"
  mapM_ addNETSupported[wms, wfs]

myManageHook = fullscreenManageHook <+> manageDocks <+> composeAll
  [ className =? "MPlayer" --> doFloat,
    className =? "Gimp" --> doFloat,
    resource =? "desktop_window" --> doIgnore,
    resource =? "kdesktop" --> doIgnore,
    isFullscreen --> doFullFloat ]

myLayout = avoidStruts(tiled ||| Mirror tiled ||| Full)
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    ratio = 1/2
    delta = 3/100

myStartupHook = do
  spawnOnce "emacs --daemon"
  spawnOnce "picom --experimental-backends"
  spawnOnce "feh --bg-scale ~/wallpapers/forest.jpg"
  spawnOnce "xsetroot -cursor_name -left_ptr"

defaults = def {
    terminal = myTerminal,
    focusFollowsMouse = myFocusFollowsMouse,
    clickJustFocuses = myClickJustFocuses,
    borderWidth = myBorderWidth,
    modMask = myModMask,
    normalBorderColor = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,
    keys = myKeys,
    workspaces = myWorkspaces,
    manageHook = myManageHook,
    layoutHook = gaps [(L,4), (R,4), (U,4), (D,4)] $ spacingRaw True (Border 0 0 0 0) True (Border 8 8 8 8) True $ smartBorders $ myLayout,
    startupHook = myStartupHook >> addEWMHFullscreen
  }

main = xmonad $ fullscreenSupport $ docks $ ewmh defaults
