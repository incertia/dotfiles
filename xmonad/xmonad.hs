import Control.Exception            (catch, SomeException)
import Data.List                    (intercalate)
import qualified Data.Text as T
import qualified Data.Text.IO as T
import System.Environment           (getEnv)
import System.IO                    (hPutStrLn, hSetBuffering, hClose, stdout, BufferMode (LineBuffering), hSetEncoding, utf8)
import System.Locale.SetLocale
import System.Posix.IO              (openFd, fdToHandle, defaultFileFlags, OpenMode (..))
import System.Process               (spawnProcess, waitForProcess)
import XMonad                           -- well duh
import XMonad.Actions.CycleWS           -- nextWS and shiftToNext magics
import XMonad.Actions.Navigation2D
import XMonad.Actions.WindowBringer     -- dmenu for goto/bring window
import XMonad.Config
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers       -- manage hoook
import XMonad.Hooks.ManageDocks         -- manage docks
-- import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.NoBorders          -- smart borders for solo clients
import XMonad.Layout.Spacing            -- spacing for tiled
import XMonad.Layout.PerWorkspace       -- onWorkspace
import XMonad.Util.EZConfig             -- additionalKeys function for keybindings
import XMonad.Util.Loggers
import XMonad.Util.Run                  -- spawn, spawnSafe, etc

import XMonad.Layout.AnotherBinarySpacePartition

-- specialize catch to catch anything deriving SomeException
catchAny :: IO a -> (SomeException -> IO a) -> IO a
catchAny = catch

-- manage hook to float some windows when spawned
-- also can shift windows to workspaces when needed
-- use <+> to combine actions
myManageHook = composeAll
  [ resource  =? "desktop_window"     --> doIgnore
  , className =? "Xfce4-notifyd"      --> doIgnore
  , className =? "Arandr"             --> doFloat
  , className =? "Vlc"                --> doFloat
  , className =? "Steam"              --> doFloat
  , className =? "feh"                --> doFloat
  , className =? "Xmessage"           --> doFloat
  , title     =? "cs242-chess-gui"    --> doFloat
  , className =? "Firefox"            --> doShift "2:web"
  , className =? "plugin-container"   --> doShift "8:plugin-container"
  , isFullscreen --> doFullFloat
  -- urxvt named windows
  , title     =? "urxvt-weechat"      --> doShift "3:chat"
  , title     =? "urxvt-htop"         --> doShift "9:system-monitor"
  ]
  -- , className =? "feh"            --> doShift "3:graphic" ]


myLayoutHook = smartBorders myDefaultLayout
  where myDefaultLayout = emptyBSP ||| Full

-- workspaces
myWorkspaces = [ "1:main"
               , "2:web"
               , "3:chat"
               , "4:graphic"
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
  setLocale LC_CTYPE (Just "en_US.UTF-8")
  input_pipe <- getEnv "XMOBAR_INPUT_PIPE"
  notif_pipe <- getEnv "XMOBAR_NOTIFICATION_PIPE"
  xmb_input <- fdToHandle =<< tryOpenFile input_pipe
  xmb_notif <- fdToHandle =<< tryOpenFile notif_pipe
  hSetBuffering xmb_input LineBuffering
  hSetBuffering xmb_notif LineBuffering
  hPutStrLn xmb_notif "starting xmonad..."
  xmonad $ defaults xmb_input xmb_notif `additionalKeys` myBindings
  hClose xmb_input
  hClose xmb_notif

  where
    defaults xmb_input xmb_notif = defaultConfig
      { modMask               = mod4Mask
      , manageHook            = myManageHook <+> manageDocks
      , layoutHook            = avoidStruts $ myLayoutHook
      , startupHook           = myStartupHook
      , logHook               = myLogHook xmb_input xmb_notif
      , handleEventHook       = docksEventHook
      , terminal              = "urxvtc"
      , normalBorderColor     = "#63c0f5"
      , focusedBorderColor    = "#00d000"
      , borderWidth           = 2
      , workspaces            = myWorkspaces }

    myStartupHook = return ()

    myLogHook xmb_input xmb_notif = dynamicLogWithPP xmobarPP
      { ppOutput = \s -> output xmb_input s >> output xmb_notif "no notifications"
      , ppHidden = takeUntil ':'
      , ppTitle = shorten 32
      , ppExtras = []
      }
      where output handle = T.hPutStrLn handle . T.pack
            takeUntil :: Eq a => a -> [a] -> [a]
            takeUntil _ [] = []
            takeUntil x (a:as) = if a == x then [] else a:takeUntil x as

    myBindings = concat [ bspBindings
                        , printScreenBindings
                        , termSpawnBindings
                        , wsShiftBindings
                        , miscBindings ]
      where
        bspBindings =
          [ ((myModMask .|. shiftMask, xK_l)               , sendMessage $ ExpandTowards R)
          , ((myModMask .|. shiftMask, xK_h)               , sendMessage $ ExpandTowards L)
          , ((myModMask .|. shiftMask, xK_j)               , sendMessage $ ExpandTowards D)
          , ((myModMask .|. shiftMask, xK_k)               , sendMessage $ ExpandTowards U)
          , ((myModMask .|. controlMask .|.shiftMask, xK_l), sendMessage $ ShrinkFrom R)
          , ((myModMask .|. controlMask .|.shiftMask, xK_h), sendMessage $ ShrinkFrom L)
          , ((myModMask .|. controlMask .|.shiftMask, xK_j), sendMessage $ ShrinkFrom D)
          , ((myModMask .|. controlMask .|.shiftMask, xK_k), sendMessage $ ShrinkFrom U)
          , ((myModMask, xK_r)                             , sendMessage $ Rotate)
          , ((myModMask, xK_s)                             , sendMessage $ Swap)
          , ((myModMask, xK_n)                             , sendMessage $ FocusParent)
          , ((myModMask .|. controlMask, xK_n)             , sendMessage $ SelectNode)
          , ((myModMask .|. shiftMask, xK_n)               , sendMessage $ MoveNode)
          , ((myModMask, xK_a)                             , sendMessage $ Balance)
          , ((myModMask .|. shiftMask, xK_a)               , sendMessage $ Equalize)
          , ((myModMask, xK_l)                             , windowGo R False)
          , ((myModMask, xK_h)                             , windowGo L False)
          , ((myModMask, xK_j)                             , windowGo D False)
          , ((myModMask, xK_k)                             , windowGo U False)
          ]

        printScreenBindings =
          [ ((0          , xK_Print), safeSpawn "scrot" scrotArgs)    -- use PrintScr to scrot the entire screen
          , ((leftAltMask, xK_Print), safeSpawn "scrot" ("-s":scrotArgs)) ]  -- use LeftAlt-PrintScr to scrot the current window
          where
            scrotPostCmd = "mv $f ~/scrots/"
            scrotFilename = "%Y-%m-%d_%T.png"
            scrotArgs = [scrotFilename, "-e", scrotPostCmd]

        termSpawnBindings =
          [ ((myModMask .|. shiftMask, xK_Return), safeSpawn "urxvtc" [])
          , ((controlMask .|. leftAltMask, xK_t), safeSpawn "urxvtc" ["-fn", commaSep ["xft:monospace:size=13", "xft:ipagothic:size=13"]])
          , ((controlMask .|. leftAltMask .|. shiftMask, xK_t), safeSpawn "xfce4-terminal" []) ]
          where commaSep = intercalate ","

        wsShiftBindings =
          [ ((myModMask              , xK_Right), nextWS)
          , ((myModMask              , xK_Left) , prevWS)
          , ((myModMask .|. shiftMask, xK_Right), shiftToNext >> nextWS)
          , ((myModMask .|. shiftMask, xK_Left) , shiftToPrev >> prevWS)
          , ((myModMask              , xK_z)    , toggleWS) ]

        miscBindings =
          [ ((myModMask, xK_g), gotoMenu)
          , ((myModMask, xK_b), bringMenu)
          , ((myModMask, xK_y), sendMessage $ ToggleStrut U)
          , ((myModMask .|. shiftMask, xK_r), spawn "xmonad --recompile && xmonad --restart")
          ]

    tryOpenFile fname = openFile fname `catchAny` \e -> openFile "/dev/null"
      where openFile fname = openFd fname ReadWrite Nothing defaultFileFlags

-- define some masks to make things more readable
leftAltMask  :: KeyMask
leftAltMask  =  mod1Mask
rightAltMask :: KeyMask
rightAltMask =  mod3Mask
myModMask    :: KeyMask
myModMask    =  mod4Mask
