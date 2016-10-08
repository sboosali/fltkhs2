{-# LANGUAGE CPP, EmptyDataDecls, TypeSynonymInstances, FlexibleInstances, MultiParamTypeClasses, FlexibleContexts, UndecidableInstances #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
module Graphics.UI.FLTK.LowLevel.SysMenuBar
    (
     sysMenuBarNew
     -- * Hierarchy
     --
     -- $hierarchy

     -- * Functions
     --
     -- $functions
    )
where
#include "Fl_ExportMacros.h"
#include "Fl_Types.h"
#include "Fl_Sys_Menu_BarC.h"
#include "Fl_WidgetC.h"
import C2HS hiding (cFromEnum, cFromBool, cToBool,cToEnum)
import Foreign.C.Types
import Graphics.UI.FLTK.LowLevel.Fl_Enumerations
import Graphics.UI.FLTK.LowLevel.Fl_Types
import Graphics.UI.FLTK.LowLevel.Utils
import Graphics.UI.FLTK.LowLevel.Dispatch
import qualified Data.Text as T
import Graphics.UI.FLTK.LowLevel.Hierarchy
import Graphics.UI.FLTK.LowLevel.MenuItem
import Graphics.UI.FLTK.LowLevel.MenuPrim

{# fun Fl_Sys_Menu_Bar_New as sysMenuBarNew' { `Int',`Int',`Int',`Int' } -> `Ptr ()' id #}
{# fun Fl_Sys_Menu_Bar_New_WithLabel as sysMenuBarNewWithLabel' { `Int',`Int',`Int',`Int', unsafeToCString `T.Text'} -> `Ptr ()' id #}
sysMenuBarNew :: Rectangle -> Maybe T.Text -> IO (Ref SysMenuBar)
sysMenuBarNew rectangle l'=
    let (x_pos, y_pos, width, height) = fromRectangle rectangle
    in case l' of
        Nothing -> sysMenuBarNew' x_pos y_pos width height >>=
                             toRef
        Just l -> sysMenuBarNewWithLabel' x_pos y_pos width height l >>=
                               toRef
{# fun Fl_Sys_Menu_Bar_Destroy as sysMenuBarDestroy' { id `Ptr ()' } -> `()' supressWarningAboutRes #}
instance (impl ~ ( IO ())) => Op (Destroy ()) SysMenuBar orig impl where
  runOp _ _ win = swapRef win $ \winPtr -> do
    sysMenuBarDestroy' winPtr
    return nullPtr
{#fun Fl_Sys_Menu_Bar_handle as sysMenuBarHandle' { id `Ptr ()', id `CInt' } -> `Int' #}
instance (impl ~ ( Event -> IO (Either UnknownEvent ()))) => Op (Handle ()) SysMenuBar orig impl where
  runOp _ _ menu_bar event = withRef menu_bar (\p -> sysMenuBarHandle' p (fromIntegral . fromEnum $ event)) >>= return  . successOrUnknownEvent
{# fun Fl_Sys_Menu_Bar_remove as remove' { id `Ptr ()',`Int' } -> `()' #}
instance (impl ~ (Int  ->  IO ())) => Op (Remove ()) SysMenuBar orig impl where
  runOp _ _ menu_ index' = withRef menu_ $ \menu_Ptr -> remove' menu_Ptr index'
{# fun Fl_Sys_Menu_Bar_replace as replace' { id `Ptr ()',`Int', unsafeToCString `T.Text' } -> `()' #}
instance (impl ~ (Int -> T.Text ->  IO ())) => Op (Replace ()) SysMenuBar orig impl where
  runOp _ _ menu_ index' name = withRef menu_ $ \menu_Ptr -> replace' menu_Ptr index' name
{# fun Fl_Sys_Menu_Bar_clear as clear' { id `Ptr ()' } -> `()' #}
instance (impl ~ ( IO ())) => Op (Clear ()) SysMenuBar orig impl where
  runOp _ _ menu_ = withRef menu_ $ \menu_Ptr -> clear' menu_Ptr
{# fun Fl_Sys_Menu_Bar_clear_submenu as clearSubmenu' { id `Ptr ()',`Int' } -> `Int' #}
instance (impl ~ (Int ->  IO (Int))) => Op (ClearSubmenu ()) SysMenuBar orig impl where
  runOp _ _ menu_ index' = withRef menu_ $ \menu_Ptr -> clearSubmenu' menu_Ptr index'
{# fun Fl_Sys_Menu_Bar_shortcut as shortcut' { id `Ptr ()',`Int',id `CInt' } -> `()' #}
instance (impl ~ (Int -> ShortcutKeySequence ->  IO ())) => Op (SetShortcut ()) SysMenuBar orig impl where
  runOp _ _ menu_ index' (ShortcutKeySequence modifiers char) =
    withRef menu_ $ \menu_Ptr ->
        shortcut' menu_Ptr index' (keySequenceToCInt modifiers char)
{# fun Fl_Sys_Menu_Bar_set_mode as setMode' { id `Ptr ()',`Int',`Int' } -> `()' #}
instance (impl ~ (Int -> MenuItemFlags ->  IO ())) => Op (SetMode ()) SysMenuBar orig impl where
  runOp _ _ menu_ i fl = withRef menu_ $ \menu_Ptr -> setMode' menu_Ptr i (menuItemFlagsToInt fl)
{# fun Fl_Sys_Menu_Bar_mode as mode' { id `Ptr ()',`Int' } -> `Int' #}
instance (impl ~ (Int ->  IO (Maybe MenuItemFlags))) => Op (GetMode ()) SysMenuBar orig impl where
  runOp _ _ menu_ i = withRef menu_ $ \menu_Ptr -> mode' menu_Ptr i >>= return . intToMenuItemFlags
{# fun Fl_Sys_Menu_Bar_global as global' { id `Ptr ()' } -> `()' #}
instance (impl ~ ( IO ())) => Op (Global ()) SysMenuBar orig impl where
  runOp _ _ menu_ = withRef menu_ $ \menu_Ptr -> global' menu_Ptr
{# fun Fl_Sys_Menu_Bar_menu_with_m as menuWithM' { id `Ptr ()',id `Ptr ( Ptr () )',`Int' } -> `()' #}
instance (impl ~ ([Ref MenuItem] -> IO ())) => Op (SetMenu ()) SysMenuBar orig impl where
  runOp _ _ menu_ items =
    withRef menu_ $ \menu_Ptr ->
        withRefs items $ \menu_itemsPtr ->
            menuWithM' menu_Ptr menu_itemsPtr (length items)

{# fun Fl_Sys_Menu_Bar_add_with_name as add' { id `Ptr ()',unsafeToCString `T.Text'} -> `()' #}
instance (impl ~ (T.Text -> IO ())) => Op (AddName ()) SysMenuBar orig impl where
  runOp _ _ menu_ name' = withRef menu_ $ \menu_Ptr -> add' menu_Ptr name'

{# fun Fl_Sys_Menu_Bar_add_with_flags as addWithFlags' { id `Ptr ()',unsafeToCString `T.Text',id `CInt',id `FunPtr CallbackWithUserDataPrim',`Int' } -> `Int' #}
{# fun Fl_Sys_Menu_Bar_add_with_shortcutname_flags as addWithShortcutnameFlags' { id `Ptr ()', unsafeToCString `T.Text', unsafeToCString `T.Text',id `FunPtr CallbackWithUserDataPrim',`Int' } -> `Int' #}
instance (Parent a MenuItem, impl ~ ( T.Text -> Maybe Shortcut -> Maybe (Ref a-> IO ()) -> MenuItemFlags -> IO (MenuItemIndex))) => Op (Add ()) SysMenuBar orig (impl) where
  runOp _ _ menu_ name shortcut cb flags =
    addMenuItem (Left (safeCast menu_)) name shortcut cb flags addWithFlags' addWithShortcutnameFlags'

{# fun Fl_Sys_Menu_Bar_insert_with_flags as insertWithFlags' { id `Ptr ()',`Int',unsafeToCString `T.Text',id `CInt',id `FunPtr CallbackWithUserDataPrim',`Int'} -> `Int' #}
{# fun Fl_Sys_Menu_Bar_insert_with_shortcutname_flags as insertWithShortcutnameFlags' { id `Ptr ()',`Int',unsafeToCString `T.Text', unsafeToCString `T.Text',id `FunPtr CallbackWithUserDataPrim',`Int' } -> `Int' #}
instance (Parent a MenuPrim, impl ~ ( Int -> T.Text -> Maybe Shortcut -> (Ref a -> IO ()) -> MenuItemFlags -> IO (MenuItemIndex))) => Op (Insert ()) SysMenuBar orig impl where
  runOp _ _ menu_ index' name shortcut cb flags = insertMenuItem (safeCast menu_) index' name shortcut cb flags insertWithFlags' insertWithShortcutnameFlags'

-- $functions
-- @
--
-- add:: ('Parent' a 'MenuItem') => 'Ref' 'SysMenuBar' -> 'T.Text' -> 'Maybe' 'Shortcut' -> 'Maybe' ('Ref' a-> 'IO' ()) -> 'MenuItemFlags' -> 'IO' ('MenuItemIndex')
--
-- addName :: 'Ref' 'SysMenuBar' -> 'T.Text' -> 'IO' ()
--
-- clear :: 'Ref' 'SysMenuBar' -> 'IO' ()
--
-- clearSubmenu :: 'Ref' 'SysMenuBar' -> 'Int' -> 'IO' ('Int')
--
-- destroy :: 'Ref' 'SysMenuBar' -> 'IO' ()
--
-- getMode :: 'Ref' 'SysMenuBar' -> 'Int' -> 'IO' ('Maybe' 'MenuItemFlags')
--
-- global :: 'Ref' 'SysMenuBar' -> 'IO' ()
--
-- handle :: 'Ref' 'SysMenuBar' -> ('Event' -> 'IO' ('Either' 'UnknownEvent' ()))
--
-- insert:: ('Parent' a 'MenuPrim') => 'Ref' 'SysMenuBar' -> 'Int' -> 'T.Text' -> 'Maybe' 'Shortcut' -> ('Ref' a -> 'IO' ()) -> 'MenuItemFlags' -> 'IO' ('MenuItemIndex')
--
-- remove :: 'Ref' 'SysMenuBar' -> 'Int' -> 'IO' ()
--
-- replace :: 'Ref' 'SysMenuBar' -> 'Int' -> 'T.Text' -> 'IO' ()
--
-- setMenu :: 'Ref' 'SysMenuBar' -> ['Ref' 'MenuItem'] -> 'IO' ()
--
-- setMode :: 'Ref' 'SysMenuBar' -> 'Int' -> 'MenuItemFlags' -> 'IO' ()
--
-- setShortcut :: 'Ref' 'SysMenuBar' -> 'Int' -> 'ShortcutKeySequence' -> 'IO' ()
--
-- @

-- $hierarchy
-- @
-- "Graphics.UI.FLTK.LowLevel.Widget"
--  |
--  v
-- "Graphics.UI.FLTK.LowLevel.MenuPrim"
--  |
--  v
-- "Graphics.UI.FLTK.LowLevel.MenuBar"
--  |
--  v
-- "Graphics.UI.FLTK.LowLevel.SysMenuBar"
--
-- @
