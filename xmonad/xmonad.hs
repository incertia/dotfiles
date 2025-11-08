import Control.Exception (SomeException, catch)
import Data.List (intercalate, isInfixOf)
import Data.Text qualified as T
import Data.Text.IO qualified as T
import Graphics.X11 (doBlue)
import System.Environment (getEnv)
import System.IO (BufferMode (LineBuffering), hClose, hPutStrLn, hSetBuffering, hSetEncoding, stdout, utf8)
import System.Locale.SetLocale
import System.Posix.IO (FdOption (CloseOnExec), OpenMode (ReadWrite), defaultFileFlags, fdToHandle, openFd, setFdOption)
import System.Process (spawnProcess, waitForProcess)
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.Navigation2D
import XMonad.Actions.WindowBringer
import XMonad.Config
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.EqualSpacing
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Spacing
import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Util.Run

-- specialize catch to catch anything deriving SomeException
catchAny :: IO a -> (SomeException -> IO a) -> IO a
catchAny = catch

-- manage hook to float some windows when spawned
-- also can shift windows to workspaces when needed
-- use <+> to combine actions
myManageHook =
  composeAll
    [ resource =? "desktop_window" --> doIgnore
    , className =? "Xfce4-notifyd" --> doIgnore
    , className =? "Arandr" --> doFloat
    , className =? "Vlc" --> doFloat
    , className =? "mpv" --> doFloat
    , className =? "Steam" --> doFloat
    , className =? "feh" --> doFloat
    , className =? "Xmessage" --> doFloat
    , isInfixOf "pinentry" <$> className --> doFloat
    , className =? "Firefox" --> doShift "2:web"
    , className =? "plugin-container" --> doShift "8:plugin-container"
    , isFullscreen --> doFullFloat
    , title =? "vktest" --> doFloat
    , title =? "katla-test" --> doFloat
    , title =? "StardewValley.bin.x86_64" --> doFloat
    , -- urxvt named windows
      title =? "urxvt-weechat" --> doShift "3:chat"
    , title =? "urxvt-htop" --> doShift "9:system-monitor"
    ]

-- , className =? "feh"            --> doShift "3:graphic" ]

myLayoutHook = smartBorders myDefaultLayout
 where
  myDefaultLayout = emptyBSP ||| noBorders Full

-- workspaces
myWorkspaces =
  [ "1:main"
  , "2:web"
  , "3:chat"
  , "4:mail"
  , "5:files"
  , "6:media"
  , "7:misc"
  , "8:plugin-container"
  , "9:system-monitor"
  , "-2:extra-space-2"
  , "-1:extra-space-1"
  ]

-- xmonad main
main = do
  setLocale LC_ALL (Just "en_US.UTF-8")
  home <- getEnv "HOME"
  input_pipe <- getEnv "XMOBAR_INPUT_PIPE"
  notif_pipe <- getEnv "XMOBAR_NOTIFICATION_PIPE"
  xmb_input <- fdToHandle =<< tryOpenFile input_pipe
  xmb_notif <- fdToHandle =<< tryOpenFile notif_pipe
  hSetBuffering xmb_input LineBuffering
  hSetBuffering xmb_notif LineBuffering
  hSetEncoding xmb_input utf8
  hSetEncoding xmb_notif utf8
  hPutStrLn xmb_notif "starting xmonad..."
  xmonad $ defaults xmb_input xmb_notif `additionalKeys` myBindings home
  hClose xmb_input
  hClose xmb_notif
 where
  defaults xmb_input xmb_notif =
    docks $
      def
        { modMask = mod4Mask
        , manageHook = myManageHook
        , layoutHook = avoidStruts myLayoutHook
        , startupHook = myStartupHook
        , logHook = myLogHook xmb_input xmb_notif
        , terminal = "alacritty"
        , normalBorderColor = "#63c0f5"
        , focusedBorderColor = "#00d000"
        , borderWidth = 2
        , workspaces = myWorkspaces
        }

  myStartupHook = return ()

  myLogHook xmb_input xmb_notif =
    dynamicLogWithPP
      xmobarPP
        { ppOutput = \s -> output xmb_input s >> output xmb_notif "no notifications"
        , ppHidden = takeUntil ':'
        , ppTitle = shorten 80
        , ppExtras = []
        }
   where
    output handle = T.hPutStrLn handle . T.pack
    takeUntil :: (Eq a) => a -> [a] -> [a]
    takeUntil _ [] = []
    takeUntil x (a : as) = if a == x then [] else a : takeUntil x as

  myBindings home =
    concat
      [ bspBindings
      , printScreenBindings home
      , termSpawnBindings
      , wsShiftBindings
      , miscBindings
      ]
   where
    bspBindings =
      [ ((myModMask .|. shiftMask, xK_l), sendMessage $ ExpandTowardsDelta delta R)
      , ((myModMask .|. shiftMask, xK_h), sendMessage $ ExpandTowardsDelta delta L)
      , ((myModMask .|. shiftMask, xK_j), sendMessage $ ExpandTowardsDelta delta D)
      , ((myModMask .|. shiftMask, xK_k), sendMessage $ ExpandTowardsDelta delta U)
      , ((myModMask .|. controlMask .|. shiftMask, xK_l), sendMessage $ ShrinkFromDelta delta R)
      , ((myModMask .|. controlMask .|. shiftMask, xK_h), sendMessage $ ShrinkFromDelta delta L)
      , ((myModMask .|. controlMask .|. shiftMask, xK_j), sendMessage $ ShrinkFromDelta delta D)
      , ((myModMask .|. controlMask .|. shiftMask, xK_k), sendMessage $ ShrinkFromDelta delta U)
      , ((myModMask, xK_r), sendMessage Rotate)
      , ((myModMask, xK_s), sendMessage Swap)
      , ((myModMask, xK_n), sendMessage FocusParent)
      , ((myModMask .|. controlMask, xK_n), sendMessage SelectNode)
      , ((myModMask .|. shiftMask, xK_n), sendMessage MoveNode)
      , ((myModMask, xK_a), sendMessage Balance)
      , ((myModMask .|. shiftMask, xK_a), sendMessage Equalize)
      , ((myModMask, xK_l), windowGo R False)
      , ((myModMask, xK_h), windowGo L False)
      , ((myModMask, xK_j), windowGo D False)
      , ((myModMask, xK_k), windowGo U False)
      ]
    delta = 0.002

    printScreenBindings home =
      [ ((0, xK_Print), maimRoot) -- use PrintScr to scrot the entire screen
      , ((leftAltMask, xK_Print), maimSelect) -- use LeftAlt-PrintScr to scrot the current window
      ]
     where
      scrot = "maim"
      scrotFilename = "%Y-%m-%d_%T.png"
      scrotFile = do
        fname <- trim <$> runProcessWithInput "date" ["+" <> scrotFilename] ""
        pure $ home <> "/scrots/" <> fname
      maimRoot = do
        f <- scrotFile
        safeSpawn scrot ["-u", "-i", "root", f]
      maimSelect = do
        f <- scrotFile
        safeSpawn scrot ["-u", "-s", "-t", "2", f]

    termSpawnBindings =
      [ ((myModMask .|. shiftMask, xK_Return), safeSpawn "alacritty" [])
      , ((controlMask .|. leftAltMask, xK_t), safeSpawn "alacritty" ["-o", "font.size=13.0"])
      , ((controlMask .|. leftAltMask .|. shiftMask, xK_t), safeSpawn "xterm" [])
      ]
     where
      commaSep = intercalate ","

    wsShiftBindings =
      [ ((myModMask, xK_Right), nextWS)
      , ((myModMask, xK_Left), prevWS)
      , ((myModMask .|. shiftMask, xK_Right), shiftToNext >> nextWS)
      , ((myModMask .|. shiftMask, xK_Left), shiftToPrev >> prevWS)
      , ((myModMask, xK_z), toggleWS)
      ]

    miscBindings =
      [ ((myModMask, xK_g), gotoMenu)
      , ((myModMask, xK_b), bringMenu)
      , ((myModMask, xK_y), sendMessage $ ToggleStrut U)
      -- , ((myModMask .|. shiftMask, xK_r), spawn "xmonad --recompile && xmonad --restart")
      ]

  tryOpenFile fname = openFile fname `catchAny` \e -> openFile "/dev/null"
   where
    openFile fname = do
      fd <- openFd fname ReadWrite defaultFileFlags
      setFdOption fd CloseOnExec True
      return fd

-- define some masks to make things more readable
leftAltMask :: KeyMask
leftAltMask = mod1Mask

rightAltMask :: KeyMask
rightAltMask = mod3Mask

myModMask :: KeyMask
myModMask = mod4Mask
