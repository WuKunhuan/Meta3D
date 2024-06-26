'use strict';

var OptionSt$Meta3dCommonlib = require("meta3d-commonlib/lib/js/src/structure/OptionSt.bs.js");
var MutableSparseMap$Meta3dCommonlib = require("meta3d-commonlib/lib/js/src/structure/sparse_map/MutableSparseMap.bs.js");

function get(param) {
  var gameObjectsMap = param.gameObjectsMap;
  return function (material) {
    return OptionSt$Meta3dCommonlib.getWithDefault(MutableSparseMap$Meta3dCommonlib.get(gameObjectsMap, material), []);
  };
}

exports.get = get;
/* No side effect */
