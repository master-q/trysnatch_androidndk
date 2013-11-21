{-# LANGUAGE ForeignFunctionInterface #-}
module AndroidNdk.Import (
  aInputEventGetType,
  aMotionEventGetXY,
  AInputEventType(..),
  AInputEvent
  ) where
import Foreign.Ptr
import Foreign.C.Types

data AInputEventType =
  AInputEventTypeKey | AInputEventTypeMotion | AInputEventTypeFail
  deriving(Eq)
newtype {-# CTYPE "AInputEvent" #-} AInputEvent = AInputEvent ()

aInputEventGetType :: Ptr AInputEvent -> IO AInputEventType
aInputEventGetType p = do
  i <- c_AInputEvent_getType p
  return $ inputEventType i

inputEventType :: Int -> AInputEventType
inputEventType e | e == c_AINPUT_EVENT_TYPE_KEY    = AInputEventTypeKey
                 | e == c_AINPUT_EVENT_TYPE_MOTION = AInputEventTypeMotion
                 | otherwise = AInputEventTypeFail

aMotionEventGetXY :: Ptr AInputEvent -> IO (Float, Float)
aMotionEventGetXY ep = do
  x <- c_AMotionEvent_getX ep 0
  y <- c_AMotionEvent_getY ep 0
  return (x, y)

foreign import primitive "const.AINPUT_EVENT_TYPE_KEY"
  c_AINPUT_EVENT_TYPE_KEY :: Int
foreign import primitive "const.AINPUT_EVENT_TYPE_MOTION"
  c_AINPUT_EVENT_TYPE_MOTION :: Int
foreign import ccall "c_extern.h AInputEvent_getType"
  c_AInputEvent_getType :: Ptr AInputEvent -> IO Int
foreign import ccall "c_extern.h AMotionEvent_getX"
  c_AMotionEvent_getX :: Ptr AInputEvent -> CSize -> IO Float
foreign import ccall "c_extern.h AMotionEvent_getY"
  c_AMotionEvent_getY :: Ptr AInputEvent -> CSize -> IO Float
