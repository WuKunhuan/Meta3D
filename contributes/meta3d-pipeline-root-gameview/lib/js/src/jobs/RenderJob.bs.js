'use strict';

var Curry = require("rescript/lib/js/curry.js");
var Utils$Meta3dPipelineRootGameview = require("./Utils.bs.js");

function execFunc(meta3dState, param) {
  var match = Utils$Meta3dPipelineRootGameview.getState(Curry._1(param.getStatesFunc, meta3dState));
  return Curry._1(match.mostService.callFunc, (function (param) {
                console.log("render root job exec");
                return meta3dState;
              }));
}

exports.execFunc = execFunc;
/* Utils-Meta3dPipelineRootGameview Not a pure module */
