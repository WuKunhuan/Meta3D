open Meta3dComponentWorkerUtils.BufferPBRMaterialUtils

let setDiffuseColor = (index, data, typeArr) =>
  Meta3dCommonlib.TypeArrayUtils.setFloat3(getDiffuseColorIndex(index), data, typeArr)

let setSpecular = (index, data, typeArr) =>
  Meta3dCommonlib.TypeArrayUtils.setFloat1(getSpecularIndex(index), data, typeArr)

let setSpecularColor = (index, data, typeArr) =>
  Meta3dCommonlib.TypeArrayUtils.setFloat3(getSpecularColorIndex(index), data, typeArr)

let setRoughness = (index, data, typeArr) =>
  Meta3dCommonlib.TypeArrayUtils.setFloat1(getRoughnessIndex(index), data, typeArr)

let setMetalness = (index, data, typeArr) =>
  Meta3dCommonlib.TypeArrayUtils.setFloat1(getMetalnessIndex(index), data, typeArr)

let setTransmission = (index, data, typeArr) =>
  Meta3dCommonlib.TypeArrayUtils.setFloat1(getTransmissionIndex(index), data, typeArr)

let setIOR = (index, data, typeArr) =>
  Meta3dCommonlib.TypeArrayUtils.setFloat1(getIORIndex(index), data, typeArr)
