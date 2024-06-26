open StateType

type actuallyDisposedTexture = Js.Nullable.t<texture>

type service = {
  createTexture: state => (state, texture),
  disposeTexture: (state, texture, material) => (state, actuallyDisposedTexture),
  addMaterial: (state, texture, material) => state,
  getName: (state, texture) => Js.Nullable.t<string>,
  setName: (state, texture, string) => state,
  getWrapS: (state, texture) => wrap,
  setWrapS: (state, texture, wrap) => state,
  getWrapT: (state, texture) => wrap,
  setWrapT: (state, texture, wrap) => state,
  getMagFilter: (state, texture) => filter,
  setMagFilter: (state, texture, filter) => state,
  getMinFilter: (state, texture) => filter,
  setMinFilter: (state, texture, filter) => state,
  getFormat: (state, texture) => format,
  setFormat: (state, texture, format) => state,
  getType: (state, texture) => textureDataType,
  setType: (state, texture, textureDataType) => state,
  getIsNeedUpdate: (state, texture) => bool,
  setIsNeedUpdate: (state, texture, bool) => state,
  getFlipY: (state, texture) => bool,
  setFlipY: (state, texture, bool) => state,
  getImage: (state, texture) => Dom.htmlImageElement,
  setImage: (state, texture, Dom.htmlImageElement) => state,
}
