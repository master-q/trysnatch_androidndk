{-# LANGUAGE ForeignFunctionInterface #-}
import Foreign.Ptr
import Foreign.Storable
import AndroidNdk

main = return ()

type FuncHandleInput =
  Ptr AndroidApp -> Ptr AInputEvent -> IO Int
foreign export ccall "engineHandleInput"
  engineHandleInput :: FuncHandleInput
engineHandleInput :: FuncHandleInput
engineHandleInput appP evP = aInputEventGetType evP >>= go
  where
    go AInputEventTypeMotion = do
      engP <- appUserData `fmap` peek appP
      peek engP >>= updateEngine >>= poke engP
      return 1
    go _ = return 0
    updateEngine eng = do
      (x, y) <- aMotionEventGetXY evP
      let stat = engState eng
      return $ eng { engAnimating = 1
                   , engState = stat { sStateX = truncate x,
                                       sStateY = truncate y }}
