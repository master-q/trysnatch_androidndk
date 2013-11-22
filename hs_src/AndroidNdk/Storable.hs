{-# LANGUAGE ForeignFunctionInterface #-}
module AndroidNdk.Storable (
  AndroidApp(..),
  AndroidEngine(..),
  SavedState(..),
  FuncHandleInput
  ) where
import Foreign.Storable
import Foreign.Ptr
import AndroidNdk.Import

type FuncHandleInput =
  Ptr AndroidApp -> Ptr AInputEvent -> IO Int

-- struct saved_state
foreign import primitive "const.sizeof(struct saved_state)"
  sizeOf_SavedState :: Int
foreign import primitive "const.offsetof(struct saved_state, x)"
  offsetOf_SavedState_x :: Int
foreign import primitive "const.offsetof(struct saved_state, y)"
  offsetOf_SavedState_y :: Int
data SavedState =
  SavedState { sStateX :: Int
             , sStateY :: Int }
instance Storable SavedState where
  sizeOf    = const sizeOf_SavedState
  alignment = sizeOf
  poke p sstat = do
    pokeByteOff p offsetOf_SavedState_x $ sStateX sstat
    pokeByteOff p offsetOf_SavedState_y $ sStateY sstat
  peek p = do
    x <- peekByteOff p offsetOf_SavedState_x
    y <- peekByteOff p offsetOf_SavedState_y
    return $ SavedState { sStateX = x, sStateY = y }

-- struct engine
foreign import primitive "const.sizeof(struct engine)"
  sizeOf_Engine :: Int
foreign import primitive "const.offsetof(struct engine, animating)"
  offsetOf_Engine_animating :: Int
foreign import primitive "const.offsetof(struct engine, state)"
  offsetOf_Engine_state :: Int
data AndroidEngine =
  AndroidEngine { engAnimating :: Int
                , engState     :: SavedState }
instance Storable AndroidEngine where
  sizeOf    = const sizeOf_Engine
  alignment = sizeOf
  poke p eng = do
    pokeByteOff p offsetOf_Engine_animating $ engAnimating eng
    pokeByteOff p offsetOf_Engine_state     $ engState eng
  peek p = do
    animating <- peekByteOff p offsetOf_Engine_animating
    state     <- peekByteOff p offsetOf_Engine_state
    return $ AndroidEngine { engAnimating = animating
                           , engState     = state }

-- struct android_app
foreign import primitive "const.sizeof(struct android_app)"
  sizeOf_AndroidApp :: Int
foreign import primitive "const.offsetof(struct android_app, userData)"
  offsetOf_AndroidApp_appUserData :: Int
foreign import primitive "const.offsetof(struct android_app, onInputEvent)"
  offsetOf_AndroidApp_appOnInputEvent :: Int
data AndroidApp = AndroidApp { appUserData :: Ptr AndroidEngine
                             , appOnInputEvent :: FunPtr FuncHandleInput }
instance Storable AndroidApp where
  sizeOf    = const sizeOf_AndroidApp
  alignment = sizeOf
  poke p app = do
    pokeByteOff p offsetOf_AndroidApp_appUserData $ appUserData app
    pokeByteOff p offsetOf_AndroidApp_appOnInputEvent $ appOnInputEvent app
  peek p = do
    userData <- peekByteOff p offsetOf_AndroidApp_appUserData
    onInput <- peekByteOff p offsetOf_AndroidApp_appOnInputEvent
    return $ AndroidApp { appUserData = userData
                        , appOnInputEvent = onInput }
