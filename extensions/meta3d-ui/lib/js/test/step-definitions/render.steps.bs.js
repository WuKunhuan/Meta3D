'use strict';

var Curry = require("rescript/lib/js/curry.js");
var Sinon = require("meta3d-bs-sinon/lib/js/src/sinon.bs.js");
var Sinon$1 = require("sinon");
var Caml_option = require("rescript/lib/js/caml_option.js");
var JestCucumber = require("jest-cucumber");
var MainTool$Meta3dUi = require("../tool/MainTool.bs.js");
var SinonTool$Meta3dUi = require("../tool/SinonTool.bs.js");
var Operators$Meta3dBsJestCucumber = require("meta3d-bs-jest-cucumber/lib/js/src/Operators.bs.js");
var ImguiRendererServiceTool$Meta3dUi = require("../tool/ImguiRendererServiceTool.bs.js");
var CucumberAsync$Meta3dBsJestCucumber = require("meta3d-bs-jest-cucumber/lib/js/src/CucumberAsync.bs.js");

var feature = JestCucumber.loadFeature("./test/features/render.feature");

JestCucumber.defineFeature(feature, (function (test) {
        var sandbox = {
          contents: 1
        };
        var _prepare = function (given) {
          return Curry._2(given, "prepare sandbox", (function (param) {
                        sandbox.contents = Sinon$1.sandbox.create();
                        
                      }));
        };
        test("set io data", (function (param) {
                var and = param.and;
                var state = {
                  contents: 1
                };
                var uiExtensionName = "uiExtensionName";
                var getExtensionStateStub = {
                  contents: 1
                };
                var setExtensionStateStub = {
                  contents: 1
                };
                var ioData = {
                  contents: 1
                };
                _prepare(param.given);
                Curry._2(and, "prepare imgui renderer service", (function (param) {
                        
                      }));
                Curry._2(and, "prepare io data", (function (param) {
                        ioData.contents = MainTool$Meta3dUi.buildIOData(true, undefined, undefined, undefined, undefined, undefined);
                        
                      }));
                Curry._2(and, "prepare api", (function (param) {
                        state.contents = MainTool$Meta3dUi.createState(undefined);
                        var __x = Sinon.createEmptyStub(sandbox.contents);
                        getExtensionStateStub.contents = Sinon.returns(state.contents, __x);
                        setExtensionStateStub.contents = Sinon.createEmptyStub(sandbox.contents);
                        
                      }));
                CucumberAsync$Meta3dBsJestCucumber.execStep(param.when, "render", (function (param) {
                        return MainTool$Meta3dUi.render(sandbox, undefined, Caml_option.some(getExtensionStateStub.contents), Caml_option.some(setExtensionStateStub.contents), uiExtensionName, undefined, 22, ioData.contents, undefined);
                      }));
                return Curry._2(param.then, "set io data", (function (param) {
                              var init = state.contents;
                              return Operators$Meta3dBsJestCucumber.$eq(expect(Sinon.getArgs(Sinon.getCall(0, setExtensionStateStub.contents))), {
                                          hd: 22,
                                          tl: {
                                            hd: uiExtensionName,
                                            tl: {
                                              hd: {
                                                elementFuncMap: init.elementFuncMap,
                                                elementStateMap: init.elementStateMap,
                                                elementExecOrderMap: init.elementExecOrderMap,
                                                isShowMap: init.isShowMap,
                                                isStateChangeMap: init.isStateChangeMap,
                                                skinContributeMap: init.skinContributeMap,
                                                customControlContributeMap: init.customControlContributeMap,
                                                reducers: init.reducers,
                                                ioData: ioData.contents
                                              },
                                              tl: /* [] */0
                                            }
                                          }
                                        });
                            }));
              }));
        test("if not show, not exec", (function (param) {
                var and = param.and;
                var state = {
                  contents: 1
                };
                var elementName1 = "e1";
                var getExtensionStateStub = {
                  contents: 1
                };
                var execFunc1Stub = {
                  contents: 1
                };
                _prepare(param.given);
                Curry._2(and, "prepare imgui renderer service", (function (param) {
                        
                      }));
                Curry._2(and, "prepare io data", (function (param) {
                        
                      }));
                Curry._2(and, "register element func1", (function (param) {
                        state.contents = MainTool$Meta3dUi.createState(undefined);
                        execFunc1Stub.contents = Sinon.createEmptyStub(sandbox.contents);
                        state.contents = MainTool$Meta3dUi.registerElement(sandbox, state.contents, execFunc1Stub.contents, elementName1, undefined, undefined, undefined);
                        
                      }));
                Curry._2(and, "hide it", (function (param) {
                        state.contents = MainTool$Meta3dUi.hide(state.contents, elementName1);
                        
                      }));
                Curry._2(and, "prepare api", (function (param) {
                        var __x = Sinon.createEmptyStub(sandbox.contents);
                        getExtensionStateStub.contents = Sinon.returns(state.contents, __x);
                        
                      }));
                CucumberAsync$Meta3dBsJestCucumber.execStep(param.when, "render", (function (param) {
                        return MainTool$Meta3dUi.render(sandbox, undefined, Caml_option.some(getExtensionStateStub.contents), undefined, undefined, undefined, undefined, undefined, undefined);
                      }));
                return Curry._2(param.then, "not exec func1", (function (param) {
                              return Operators$Meta3dBsJestCucumber.$eq(expect(Sinon.getCallCount(execFunc1Stub.contents)), 0);
                            }));
              }));
        test("else, exec and mark state not change by ascending order", (function (param) {
                var and = param.and;
                var state = {
                  contents: 1
                };
                var elementName1 = "e1";
                var elementName2 = "e2";
                var getExtensionStateStub = {
                  contents: 1
                };
                var setExtensionStateStub = {
                  contents: 1
                };
                var execFunc1Stub = {
                  contents: 1
                };
                var execFunc2Stub = {
                  contents: 1
                };
                _prepare(param.given);
                Curry._2(and, "prepare imgui renderer service", (function (param) {
                        
                      }));
                Curry._2(and, "prepare io data", (function (param) {
                        
                      }));
                Curry._2(and, "register element func1 with exec order=1", (function (param) {
                        state.contents = MainTool$Meta3dUi.createState(undefined);
                        var __x = Sinon.createEmptyStub(sandbox.contents);
                        execFunc1Stub.contents = Sinon.returns(Promise.resolve(1), __x);
                        state.contents = MainTool$Meta3dUi.registerElement(sandbox, state.contents, execFunc1Stub.contents, elementName1, 1, undefined, undefined);
                        
                      }));
                Curry._2(and, "register element func2 with exec order=0", (function (param) {
                        var __x = Sinon.createEmptyStub(sandbox.contents);
                        execFunc2Stub.contents = Sinon.returns(Promise.resolve(1), __x);
                        state.contents = MainTool$Meta3dUi.registerElement(sandbox, state.contents, execFunc2Stub.contents, elementName2, 0, undefined, undefined);
                        
                      }));
                Curry._2(and, "mark their states change", (function (param) {
                        state.contents = MainTool$Meta3dUi.markStateChange(state.contents, elementName1);
                        state.contents = MainTool$Meta3dUi.markStateChange(state.contents, elementName2);
                        
                      }));
                Curry._2(and, "show them", (function (param) {
                        state.contents = MainTool$Meta3dUi.show(state.contents, elementName1);
                        state.contents = MainTool$Meta3dUi.show(state.contents, elementName2);
                        
                      }));
                Curry._2(and, "prepare api", (function (param) {
                        var __x = Sinon.createEmptyStub(sandbox.contents);
                        getExtensionStateStub.contents = Sinon.returns(state.contents, __x);
                        setExtensionStateStub.contents = Sinon.createEmptyStub(sandbox.contents);
                        
                      }));
                CucumberAsync$Meta3dBsJestCucumber.execStep(param.when, "render", (function (param) {
                        return MainTool$Meta3dUi.render(sandbox, undefined, Caml_option.some(getExtensionStateStub.contents), Caml_option.some(setExtensionStateStub.contents), undefined, undefined, undefined, undefined, undefined);
                      }));
                Curry._2(param.then, "exec func2 and func1", (function (param) {
                        return Operators$Meta3dBsJestCucumber.$eq(expect([
                                        Sinon.getCallCount(execFunc1Stub.contents),
                                        Sinon.getCallCount(execFunc2Stub.contents),
                                        Sinon.calledBefore(execFunc2Stub.contents, execFunc1Stub.contents)
                                      ]), [
                                    1,
                                    1,
                                    true
                                  ]);
                      }));
                return Curry._2(and, "mark their states not change", (function (param) {
                              var state = SinonTool$Meta3dUi.getArg(setExtensionStateStub.contents, 1, 2, undefined);
                              return Operators$Meta3dBsJestCucumber.$eq(expect([
                                              MainTool$Meta3dUi.isStateChange(state, elementName1),
                                              MainTool$Meta3dUi.isStateChange(state, elementName2)
                                            ]), [
                                          false,
                                          false
                                        ]);
                            }));
              }));
        return test("render imgui renderer", (function (param) {
                      var and = param.and;
                      var newMeta3dState = {
                        contents: 12
                      };
                      var imguiRendererExtensionName = "imguiRendererExtensionName";
                      var imguiRendererService = {
                        contents: 1
                      };
                      var renderStub = {
                        contents: 1
                      };
                      var getExtensionServiceStub = {
                        contents: 1
                      };
                      var getExtensionStateStub = {
                        contents: 1
                      };
                      var setExtensionStateStub = {
                        contents: 1
                      };
                      _prepare(param.given);
                      Curry._2(and, "prepare imgui renderer service", (function (param) {
                              renderStub.contents = Sinon.returns(13, Sinon.createEmptyStub(sandbox.contents));
                              imguiRendererService.contents = ImguiRendererServiceTool$Meta3dUi.buildService(sandbox, undefined, renderStub.contents, undefined, undefined);
                              
                            }));
                      Curry._2(and, "prepare io data", (function (param) {
                              
                            }));
                      Curry._2(and, "prepare api", (function (param) {
                              var __x = Sinon.createEmptyStub(sandbox.contents);
                              getExtensionServiceStub.contents = Sinon.returns(imguiRendererService.contents, __x);
                              getExtensionStateStub.contents = Sinon.createEmptyStub(sandbox.contents);
                              var __x$1 = getExtensionStateStub.contents;
                              Sinon.returns(MainTool$Meta3dUi.createState(undefined), __x$1);
                              Sinon.returns(12, Sinon.onCall(2, getExtensionStateStub.contents));
                              setExtensionStateStub.contents = Sinon.createEmptyStub(sandbox.contents);
                              Sinon.returns(22, setExtensionStateStub.contents);
                              Sinon.returns(23, Sinon.onCall(2, setExtensionStateStub.contents));
                              
                            }));
                      CucumberAsync$Meta3dBsJestCucumber.execStep(param.when, "render", (function (param) {
                              var __x = MainTool$Meta3dUi.render(sandbox, Caml_option.some(getExtensionServiceStub.contents), Caml_option.some(getExtensionStateStub.contents), Caml_option.some(setExtensionStateStub.contents), undefined, imguiRendererExtensionName, 22, undefined, undefined);
                              return __x.then(function (meta3dState) {
                                          newMeta3dState.contents = meta3dState;
                                          return Promise.resolve(meta3dState);
                                        });
                            }));
                      Curry._2(param.then, "render imgui renderer", (function (param) {
                              return Operators$Meta3dBsJestCucumber.$eq(expect([
                                              Sinon.getCallCount(Sinon.withTwoArgs(22, imguiRendererExtensionName, getExtensionStateStub.contents)),
                                              Sinon.getCallCount(Sinon.withTwoArgs(22, imguiRendererExtensionName, getExtensionServiceStub.contents)),
                                              SinonTool$Meta3dUi.calledWithArg2(Sinon.getCall(0, renderStub.contents), 12, 22)
                                            ]), [
                                          1,
                                          1,
                                          true
                                        ]);
                            }));
                      return Curry._2(and, "update imgui renderer state", (function (param) {
                                    return Operators$Meta3dBsJestCucumber.$eq(expect([
                                                    SinonTool$Meta3dUi.calledWithArg3(Sinon.getCall(2, setExtensionStateStub.contents), 22, imguiRendererExtensionName, 13),
                                                    newMeta3dState.contents
                                                  ]), [
                                                true,
                                                23
                                              ]);
                                  }));
                    }));
      }));

exports.feature = feature;
/* feature Not a pure module */