'use strict';

var ArraySt$Meta3dCommonlib = require("../structure/ArraySt.bs.js");

function removeFromArray(arr, isDebug, target) {
  var index = arr.indexOf(target);
  if (index === -1) {
    return arr;
  }
  var lastIndex = arr.length - 1 | 0;
  ArraySt$Meta3dCommonlib.deleteBySwap(arr, isDebug, index, lastIndex);
  return arr;
}

function batchRemoveFromArray(arr, targets) {
  return arr.filter(function (value) {
              return !targets.includes(value);
            });
}

exports.removeFromArray = removeFromArray;
exports.batchRemoveFromArray = batchRemoveFromArray;
/* No side effect */
