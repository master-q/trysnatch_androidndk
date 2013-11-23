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
import OpenGLES

type FuncHandleInput =
  Ptr AndroidApp -> Ptr AInputEvent -> IO Int

-- struct saved_state
foreign import primitive "const.sizeof(struct saved_state)"
  sizeOf_SavedState :: Int
foreign import primitive "const.offsetof(struct saved_state, x)"
  offsetOf_SavedState_x :: Int
foreign import primitive "const.offsetof(struct saved_state, y)"
  offsetOf_SavedState_y :: Int
foreign import primitive "const.offsetof(struct saved_state, angle)"
  offsetOf_SavedState_angle :: Int
data SavedState =
  SavedState { sStateX :: Int
             , sStateY :: Int
             , sStateAngle :: Float }
instance Storable SavedState where
  sizeOf    = const sizeOf_SavedState
  alignment = sizeOf
  poke p sstat = do
    pokeByteOff p offsetOf_SavedState_x $ sStateX sstat
    pokeByteOff p offsetOf_SavedState_y $ sStateY sstat
    pokeByteOff p offsetOf_SavedState_angle $ sStateAngle sstat
  peek p = do
    x <- peekByteOff p offsetOf_SavedState_x
    y <- peekByteOff p offsetOf_SavedState_y
    angle <- peekByteOff p offsetOf_SavedState_angle
    return $ SavedState { sStateX = x, sStateY = y, sStateAngle = angle }

-- struct engine
foreign import primitive "const.sizeof(struct engine)"
  sizeOf_Engine :: Int
foreign import primitive "const.offsetof(struct engine, animating)"
  offsetOf_Engine_animating :: Int
foreign import primitive "const.offsetof(struct engine, state)"
  offsetOf_Engine_state :: Int
foreign import primitive "const.offsetof(struct engine, width)"
  offsetOf_Engine_width :: Int
foreign import primitive "const.offsetof(struct engine, height)"
  offsetOf_Engine_height :: Int
foreign import primitive "const.offsetof(struct engine, display)"
  offsetOf_Engine_display :: Int
foreign import primitive "const.offsetof(struct engine, surface)"
  offsetOf_Engine_surface :: Int
data AndroidEngine =
  AndroidEngine { engAnimating :: Int
                , engState     :: SavedState
                , engWidth      :: Int
                , engHeight     :: Int
                , engEglDisplay :: EGLDisplay
                , engEglSurface :: EGLSurface }
instance Storable AndroidEngine where
  sizeOf    = const sizeOf_Engine
  alignment = sizeOf
  poke p eng = do
    pokeByteOff p offsetOf_Engine_animating $ engAnimating eng
    pokeByteOff p offsetOf_Engine_state     $ engState eng
    pokeByteOff p offsetOf_Engine_width     $ engWidth eng
    pokeByteOff p offsetOf_Engine_height    $ engHeight eng
    pokeByteOff p offsetOf_Engine_display   $ engEglDisplay eng
    pokeByteOff p offsetOf_Engine_surface   $ engEglSurface eng
  peek p = do
    animating <- peekByteOff p offsetOf_Engine_animating
    state     <- peekByteOff p offsetOf_Engine_state
    width               <- peekByteOff p offsetOf_Engine_width
    height              <- peekByteOff p offsetOf_Engine_height
    eglDisp             <- peekByteOff p offsetOf_Engine_display
    eglSurf             <- peekByteOff p offsetOf_Engine_surface
    return $ AndroidEngine { engAnimating = animating
                           , engState     = state
                           , engWidth      = width
                           , engHeight     = height
                           , engEglDisplay = eglDisp
                           , engEglSurface = eglSurf }

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
