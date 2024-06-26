open Js.Typed_array

type webgl1Context

type program

type buffer

type renderBuffer

type attributeLocation = int

type uniformLocation

type glenum = int

type glint = int

type glsizei = int

type shader

type texture

type fbo

type extension

type vaoExtension

type hex

type arrayBufferView = {
  buffer: Js.Typed_array.ArrayBuffer.t,
  byteLength: int,
  byteOffset: int,
}

type contextConfigJsObj = {
  "alpha": bool,
  "depth": bool,
  "stencil": bool,
  "failIfMajorPerformanceCaveat": bool,
  "powerPreference": string,
  "antialias": bool,
  "premultipliedAlpha": bool,
  "preserveDrawingBuffer": bool,
  "desynchronized": bool,
}

type canvas = Dom.htmlCanvasElement

// @genType
type service = {
  getContext: (. canvas, contextConfigJsObj) => webgl1Context,
  createProgram: (. webgl1Context) => program,
  linkProgram: (. program, webgl1Context) => unit,
  useProgram: (. program, webgl1Context) => unit,
  uniformMatrix4fv: (. uniformLocation, Float32Array.t, webgl1Context) => unit,
  uniform1i: (. uniformLocation, int, webgl1Context) => unit,
  uniform1f: (. uniformLocation, float, webgl1Context) => unit,
  uniform3f: (. uniformLocation, float, float, float, webgl1Context) => unit,
  getAttribLocation: (. program, string, webgl1Context) => attributeLocation,
  getUniformLocation: (. program, string, webgl1Context) => uniformLocation,
  shaderSource: (. shader, string, webgl1Context) => unit,
  compileShader: (. shader, webgl1Context) => unit,
  createShader: (. int, webgl1Context) => shader,
  getParameter: (. int, webgl1Context) => int,
  getLinkStatus: (. webgl1Context) => int,
  getShaderParameter: (. shader, int, webgl1Context) => bool,
  getProgramParameter: (. program, int, webgl1Context) => bool,
  getShaderInfoLog: (. shader, webgl1Context) => string,
  getProgramInfoLog: (. program, webgl1Context) => string,
  attachShader: (. program, shader, webgl1Context) => unit,
  deleteShader: (. shader, webgl1Context) => unit,
  bindAttribLocation: (. program, int, string, webgl1Context) => unit,
  getCompileStatus: (. webgl1Context) => int,
  getVertexShader: (. webgl1Context) => int,
  getFragmentShader: (. webgl1Context) => int,
  createBuffer: (. webgl1Context) => buffer,
  bindBuffer: (. int, buffer, webgl1Context) => unit,
  bufferFloat32Data: (. int, Float32Array.t, int, webgl1Context) => unit,
  bufferUint16Data: (. int, Uint16Array.t, int, webgl1Context) => unit,
  bufferUint32Data: (. int, Uint32Array.t, int, webgl1Context) => unit,
  getArrayBuffer: (. webgl1Context) => int,
  getElementArrayBuffer: (. webgl1Context) => int,
  getStaticDraw: (. webgl1Context) => int,
  getDynamicDraw: (. webgl1Context) => int,
  disableVertexAttribArray: (. int, webgl1Context) => unit,
  vertexAttribPointer: (. attributeLocation, int, int, bool, int, int, webgl1Context) => unit,
  enableVertexAttribArray: (. attributeLocation, webgl1Context) => unit,
  getExtension: (. string, webgl1Context) => unit,
  drawElements: (. int, int, int, int, webgl1Context) => unit,
  clearColor: (. float, float, float, float, webgl1Context) => unit,
  clear: (. int, webgl1Context) => unit,
  getColorBufferBit: (. webgl1Context) => int,
  getDepthBufferBit: (. webgl1Context) => int,
  getStencilBufferBit: (. webgl1Context) => int,
  viewport: (. int, int, int, int, webgl1Context) => unit,
  scissor: (. int, int, int, int, webgl1Context) => unit,
  enable: (. int, webgl1Context) => unit,
  disable: (. int, webgl1Context) => unit,
  getFloat: (. webgl1Context) => int,
  getDepthTest: (. webgl1Context) => int,
  getStencilTest: (. webgl1Context) => int,
  getScissorTest: (. webgl1Context) => int,
  getBlend: (. webgl1Context) => int,
  getCullFace: (. webgl1Context) => int,
  getFrontAndBack: (. webgl1Context) => int,
  getBack: (. webgl1Context) => int,
  getFront: (. webgl1Context) => int,
  getCurrentProgram: (. webgl1Context) => int,
  getBindingElementArrayBuffer: (. webgl1Context) => int,
  getBindingArrayBuffer: (. webgl1Context) => int,
  getSrcAlpha: (. webgl1Context) => int,
  getOneMinusSrcAlpha: (. webgl1Context) => int,
  isEnabled: (. int, webgl1Context) => bool,
  bindVertexArrayOES: (. Js.Null.t<buffer>, webgl1Context) => unit,
  blendFunc: (. int, int, webgl1Context) => unit,
  getTriangles: (. webgl1Context) => int,
  getTriangleFan: (. webgl1Context) => int,
  getUnsignedByte: (. webgl1Context) => glenum,
  getUnsignedInt: (. webgl1Context) => glenum,
  getUnsignedShort: (. webgl1Context) => glenum,
  bindTexture: (. glenum, Js.Null.t<texture>, webgl1Context) => unit,
  createTexture: (. webgl1Context) => Js.Null.t<texture>,
  texImage2D: (
    . glenum,
    glint,
    glint,
    glsizei,
    glsizei,
    glint,
    glenum,
    glenum,
    Js.Null.t<arrayBufferView>,
    webgl1Context,
  ) => unit,
  texParameteri: (. glenum, glenum, glint, webgl1Context) => unit,
  getTexture2DType: (. webgl1Context) => int,
  getRGBAType: (. webgl1Context) => int,
  getDrawingBufferWidth: (. webgl1Context) => int,
  getDrawingBufferHeight: (. webgl1Context) => int,
  getTextureMinFilterType: (. webgl1Context) => int,
  getLinearType: (. webgl1Context) => int,
  getTextureWrapSType: (. webgl1Context) => int,
  getTextureWrapTType: (. webgl1Context) => int,
  getClampToEdgeType: (. webgl1Context) => int,
  getFrameBufferType: (. webgl1Context) => int,
  getRenderBufferType: (. webgl1Context) => int,
  getColorAttachment0: (. webgl1Context) => int,
  getDepthAttachment: (. webgl1Context) => int,
  getDepthComponent16: (. webgl1Context) => glenum,
  createFramebuffer: (. webgl1Context) => Js.Null.t<fbo>,
  bindFramebuffer: (. glenum, Js.Null.t<fbo>, webgl1Context) => unit,
  framebufferTexture2D: (
    . glenum,
    glenum,
    glenum,
    Js.Null.t<texture>,
    glint,
    webgl1Context,
  ) => unit,
  createRenderbuffer: (. webgl1Context) => renderBuffer,
  bindRenderbuffer: (. glenum, renderBuffer, webgl1Context) => unit,
  renderbufferStorage: (. glenum, glenum, int, int, webgl1Context) => unit,
  framebufferRenderbuffer: (. glenum, glenum, glenum, renderBuffer, webgl1Context) => unit,
}

external parameterIntToNullableProgram: int => Js.Nullable.t<program> = "%identity"

external parameterIntToBuffer: int => buffer = "%identity"

// external parameterIntToNullableTexture : int => Js.Null.t<texture> =
//   "%identity"

// external intToHex : int => hex = "%identity"
