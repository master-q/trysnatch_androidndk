{-# LANGUAGE ForeignFunctionInterface #-}
module OpenGLES (
  combineGLBitField,
  gLColorBufferBit,
  gLDepthBufferBit,
  glStenciBufferBit,
  glClear,
  glClearColor,
  eglSwapBuffers,
  EGLDisplay,
  EGLSurface
) where
import Data.Word
import Data.Bits
import Foreign.Ptr

type C_GLbitfield = Word32
newtype EGLDisplayT = EGLDisplayT ()
newtype EGLSurfaceT = EGLSurfaceT ()
type EGLDisplay = Ptr EGLDisplayT
type EGLSurface = Ptr EGLSurfaceT

newtype GLBitField = GLBitField { unGLBitField :: Word32 }
gLColorBufferBit, gLDepthBufferBit, glStenciBufferBit :: GLBitField
gLColorBufferBit  = GLBitField c_GL_COLOR_BUFFER_BIT
gLDepthBufferBit  = GLBitField c_GL_DEPTH_BUFFER_BIT
glStenciBufferBit = GLBitField c_GL_STENCIL_BUFFER_BIT
combineGLBitField :: [GLBitField] -> GLBitField
combineGLBitField = GLBitField . foldr ((.|.) . unGLBitField) 0

glClear :: GLBitField -> IO ()
glClear = c_glClear . unGLBitField

glClearColor :: Float -> Float -> Float -> Float -> IO ()
glClearColor = c_glClearColor

eglSwapBuffers :: EGLDisplay -> EGLSurface -> IO Word32
eglSwapBuffers = c_eglSwapBuffers

foreign import primitive "const.GL_COLOR_BUFFER_BIT"
  c_GL_COLOR_BUFFER_BIT :: C_GLbitfield
foreign import primitive "const.GL_DEPTH_BUFFER_BIT"
  c_GL_DEPTH_BUFFER_BIT :: C_GLbitfield
foreign import primitive "const.GL_STENCIL_BUFFER_BIT"
  c_GL_STENCIL_BUFFER_BIT :: C_GLbitfield
foreign import ccall "GLES/gl.h glClearColor"
  c_glClearColor :: Float -> Float -> Float -> Float -> IO ()
foreign import ccall "GLES/gl.h glClear"
  c_glClear :: C_GLbitfield -> IO ()
foreign import ccall "EGL/egl.h eglSwapBuffers"
  c_eglSwapBuffers :: EGLDisplay -> EGLSurface -> IO Word32
