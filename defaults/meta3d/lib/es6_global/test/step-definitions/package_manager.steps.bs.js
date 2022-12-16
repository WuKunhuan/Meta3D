

import * as Curry from "../../../../../../node_modules/rescript/lib/es6/curry.js";
import * as Caml_array from "../../../../../../node_modules/rescript/lib/es6/caml_array.js";
import * as Js_promise from "../../../../../../node_modules/rescript/lib/es6/js_promise.js";
import * as Main$Meta3d from "../../src/Main.bs.js";
import * as JestCucumber from "jest-cucumber";
import * as FileTool$Meta3d from "../tool/FileTool.bs.js";
import * as Tuple2$Meta3dCommonlib from "../../../../../../node_modules/meta3d-commonlib/lib/es6_global/src/structure/tuple/Tuple2.bs.js";
import * as ArraySt$Meta3dCommonlib from "../../../../../../node_modules/meta3d-commonlib/lib/es6_global/src/structure/ArraySt.bs.js";
import * as PackageManagerTool$Meta3d from "../tool/PackageManagerTool.bs.js";
import * as ExtensionManagerTool$Meta3d from "../tool/ExtensionManagerTool.bs.js";
import * as Operators$Meta3dBsJestCucumber from "../../../../../../node_modules/meta3d-bs-jest-cucumber/lib/es6_global/src/Operators.bs.js";
import * as ImmutableHashMap$Meta3dCommonlib from "../../../../../../node_modules/meta3d-commonlib/lib/es6_global/src/structure/hash_map/ImmutableHashMap.bs.js";
import * as CucumberAsync$Meta3dBsJestCucumber from "../../../../../../node_modules/meta3d-bs-jest-cucumber/lib/es6_global/src/CucumberAsync.bs.js";

var feature = JestCucumber.loadFeature("./test/features/package_manager.feature");

JestCucumber.defineFeature(feature, (function (test) {
        var firstExtension = {
          contents: 1
        };
        var secondExtension = {
          contents: 1
        };
        var c1 = {
          contents: 1
        };
        var allExtensionNewNames = {
          contents: 1
        };
        var _prepare = function (given) {
          return Curry._2(given, "prepare", (function (param) {
                        FileTool$Meta3d.buildFakeTextDecoder(FileTool$Meta3d.convertUint8ArrayToBuffer);
                        return FileTool$Meta3d.buildFakeTextEncoder();
                      }));
        };
        test("convert allExtensionFileData and allContributeFileData", (function (param) {
                var and = param.and;
                var given = param.given;
                var firstExtension = {
                  contents: 1
                };
                var secondExtension = {
                  contents: 1
                };
                var firstContribute = {
                  contents: 1
                };
                var firstExtensionFileData = {
                  contents: 1
                };
                var secondExtensionFileData = {
                  contents: 1
                };
                var firstContributeFileData = {
                  contents: 1
                };
                var allExtensionNewNames = {
                  contents: 1
                };
                var allContributeNewNames = {
                  contents: 1
                };
                var entryExtensionName = {
                  contents: 1
                };
                _prepare(given);
                Curry._2(given, "generate two extensions that the seond is entry", (function (param) {
                        firstExtension.contents = Main$Meta3d.generateExtension({
                              name: "first-extension",
                              protocol: {
                                name: "first-extension-protocol",
                                version: "0.4.1"
                              },
                              dependentExtensionNameMap: ImmutableHashMap$Meta3dCommonlib.set(ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined), "second-extension", {
                                    protocolName: "second-extension-protocol",
                                    protocolVersion: ">=0.4.1 < 1.0.0"
                                  }),
                              dependentContributeNameMap: ImmutableHashMap$Meta3dCommonlib.set(ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined), "first-contribute", {
                                    protocolName: "first-contribute-protocol",
                                    protocolVersion: "^0.5.2"
                                  })
                            }, PackageManagerTool$Meta3d.buildEmptyExtensionFileStr(undefined));
                        secondExtension.contents = Main$Meta3d.generateExtension({
                              name: "second-extension",
                              protocol: {
                                name: "second-extension-protocol",
                                version: "0.5.2"
                              },
                              dependentExtensionNameMap: ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined),
                              dependentContributeNameMap: ImmutableHashMap$Meta3dCommonlib.set(ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined), "first-contribute", {
                                    protocolName: "first-contribute-protocol",
                                    protocolVersion: "^0.5.2"
                                  })
                            }, PackageManagerTool$Meta3d.buildEmptyExtensionFileStr(undefined));
                        entryExtensionName.contents = "second-extension";
                      }));
                Curry._2(and, "generate one contribute", (function (param) {
                        firstContribute.contents = Main$Meta3d.generateContribute({
                              name: "first-contribute",
                              protocol: {
                                name: "first-contribute-protocol",
                                version: "0.5.3"
                              },
                              dependentExtensionNameMap: ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined),
                              dependentContributeNameMap: ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined)
                            }, PackageManagerTool$Meta3d.buildEmptyContributeFileStr(undefined));
                      }));
                Curry._2(and, "prepare new names", (function (param) {
                        allExtensionNewNames.contents = [
                          "first-new-extension",
                          "second-extension"
                        ];
                        allContributeNewNames.contents = ["first-new-contribute"];
                      }));
                Curry._2(and, "load them as l1", (function (param) {
                        firstExtensionFileData.contents = Main$Meta3d.loadExtension(firstExtension.contents);
                        secondExtensionFileData.contents = Main$Meta3d.loadExtension(secondExtension.contents);
                        firstContributeFileData.contents = Main$Meta3d.loadContribute(firstContribute.contents);
                      }));
                Curry._2(param.when, "convert l1", (function (param) {
                        
                      }));
                Curry._2(param.then, "converted package data is correct", (function (param) {
                        var match = Main$Meta3d.convertAllFileDataForPackage([
                              firstExtensionFileData.contents,
                              secondExtensionFileData.contents
                            ], [firstContributeFileData.contents], [
                              allExtensionNewNames.contents,
                              [entryExtensionName.contents],
                              allContributeNewNames.contents
                            ]);
                        Operators$Meta3dBsJestCucumber.$eq(expect([
                                  ArraySt$Meta3dCommonlib.map(match[0], Tuple2$Meta3dCommonlib.getFirst),
                                  ArraySt$Meta3dCommonlib.map(match[1], Tuple2$Meta3dCommonlib.getFirst)
                                ]), [
                              [
                                {
                                  name: "first-new-extension",
                                  type_: /* Default */0,
                                  dependentExtensionNameMap: ImmutableHashMap$Meta3dCommonlib.set(ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined), "second-extension", "second-extension"),
                                  dependentContributeNameMap: ImmutableHashMap$Meta3dCommonlib.set(ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined), "first-contribute", "first-new-contribute")
                                },
                                {
                                  name: "second-extension",
                                  type_: /* Entry */2,
                                  dependentExtensionNameMap: ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined),
                                  dependentContributeNameMap: ImmutableHashMap$Meta3dCommonlib.set(ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined), "first-contribute", "first-new-contribute")
                                }
                              ],
                              [{
                                  name: "first-new-contribute",
                                  dependentExtensionNameMap: ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined),
                                  dependentContributeNameMap: ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined)
                                }]
                            ]);
                      }));
              }));
        test("load generated package", (function (param) {
                var and = param.and;
                var given = param.given;
                var firstExtension = {
                  contents: 1
                };
                var secondExtension = {
                  contents: 1
                };
                var firstContribute = {
                  contents: 1
                };
                var c1 = {
                  contents: 1
                };
                var allExtensionNewNames = {
                  contents: 1
                };
                var allContributeNewNames = {
                  contents: 1
                };
                var entryExtensions = {
                  contents: 1
                };
                var entryExtensionName = {
                  contents: 1
                };
                var state = {
                  contents: 1
                };
                _prepare(given);
                Curry._2(given, "prepare flag", (function (param) {
                        return PackageManagerTool$Meta3d.prepareStartFlag(undefined);
                      }));
                Curry._2(given, "generate two extensions", (function (param) {
                        firstExtension.contents = Main$Meta3d.generateExtension({
                              name: "first-extension",
                              protocol: {
                                name: "first-extension-protocol",
                                version: "0.4.1"
                              },
                              dependentExtensionNameMap: ImmutableHashMap$Meta3dCommonlib.set(ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined), "second-extension", {
                                    protocolName: "second-extension-protocol",
                                    protocolVersion: ">=0.4.1 < 1.0.0"
                                  }),
                              dependentContributeNameMap: ImmutableHashMap$Meta3dCommonlib.set(ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined), "first-contribute", {
                                    protocolName: "first-contribute-protocol",
                                    protocolVersion: "^0.5.2"
                                  })
                            }, PackageManagerTool$Meta3d.buildEmptyExtensionFileStr(undefined));
                        secondExtension.contents = Main$Meta3d.generateExtension({
                              name: "second-extension",
                              protocol: {
                                name: "second-extension-protocol",
                                version: "0.5.2"
                              },
                              dependentExtensionNameMap: ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined),
                              dependentContributeNameMap: ImmutableHashMap$Meta3dCommonlib.set(ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined), "first-contribute", {
                                    protocolName: "first-contribute-protocol",
                                    protocolVersion: "^0.5.2"
                                  })
                            }, PackageManagerTool$Meta3d.buildEmptyExtensionFileStr(undefined));
                      }));
                Curry._2(and, "generate one contribute", (function (param) {
                        firstContribute.contents = Main$Meta3d.generateContribute({
                              name: "first-contribute",
                              protocol: {
                                name: "first-contribute-protocol",
                                version: "0.5.3"
                              },
                              dependentExtensionNameMap: ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined),
                              dependentContributeNameMap: ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined)
                            }, PackageManagerTool$Meta3d.buildEmptyContributeFileStr(undefined));
                      }));
                Curry._2(and, "prepare new names and mark the second extension as entry", (function (param) {
                        allExtensionNewNames.contents = [
                          "first-extension",
                          "second-new-extension"
                        ];
                        allContributeNewNames.contents = ["first-new-contribute"];
                        entryExtensions.contents = ["second-new-extension"];
                      }));
                Curry._2(and, "load them and convert as c1", (function (param) {
                        var firstExtensionFileData = Main$Meta3d.loadExtension(firstExtension.contents);
                        var secondExtensionFileData = Main$Meta3d.loadExtension(secondExtension.contents);
                        var firstContributeFileData = Main$Meta3d.loadContribute(firstContribute.contents);
                        c1.contents = Main$Meta3d.convertAllFileDataForPackage([
                              firstExtensionFileData,
                              secondExtensionFileData
                            ], [firstContributeFileData], [
                              allExtensionNewNames.contents,
                              entryExtensions.contents,
                              allContributeNewNames.contents
                            ]);
                      }));
                Curry._2(param.when, "generate package with c1 and load it", (function (param) {
                        var match = Main$Meta3d.loadPackage(Main$Meta3d.generatePackage(c1.contents));
                        entryExtensionName.contents = match[2];
                        state.contents = match[0];
                      }));
                Curry._2(param.then, "the two extensions should be registered", (function (param) {
                        Operators$Meta3dBsJestCucumber.$eq(expect([
                                  ExtensionManagerTool$Meta3d.hasExtension(state.contents, "first-extension"),
                                  ExtensionManagerTool$Meta3d.hasExtension(state.contents, "second-new-extension")
                                ]), [
                              true,
                              true
                            ]);
                      }));
                Curry._2(and, "the one contribute should be registered", (function (param) {
                        Operators$Meta3dBsJestCucumber.$eq(expect(ExtensionManagerTool$Meta3d.hasContribute(state.contents, "first-new-contribute")), true);
                      }));
                Curry._2(and, "load result should has entry extension name", (function (param) {
                        Operators$Meta3dBsJestCucumber.$eq(expect(entryExtensionName.contents), Caml_array.get(entryExtensions.contents, 0));
                      }));
              }));
        var _prepareForLoadAndHandleGeneratedPackage = function (given, and, param) {
          var buildEmptyExtensionFileStrWithLifeHandle = param[1];
          var prepareFlag = param[0];
          var entryExtensionName = {
            contents: 1
          };
          Curry._2(given, "prepare flag", (function (param) {
                  Curry._1(prepareFlag, undefined);
                }));
          Curry._2(given, "generate two extensions", (function (param) {
                  firstExtension.contents = Main$Meta3d.generateExtension({
                        name: "first-extension",
                        protocol: {
                          name: "first-extension-protocol",
                          version: "0.4.1"
                        },
                        dependentExtensionNameMap: ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined),
                        dependentContributeNameMap: ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined)
                      }, Curry._1(buildEmptyExtensionFileStrWithLifeHandle, 1));
                  secondExtension.contents = Main$Meta3d.generateExtension({
                        name: "second-extension",
                        protocol: {
                          name: "second-extension-protocol",
                          version: "0.5.2"
                        },
                        dependentExtensionNameMap: ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined),
                        dependentContributeNameMap: ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined)
                      }, Curry._1(buildEmptyExtensionFileStrWithLifeHandle, 2));
                }));
          Curry._2(and, "prepare new names and mark the second extension as entry", (function (param) {
                  allExtensionNewNames.contents = [
                    "first-extension",
                    "second-new-extension"
                  ];
                  entryExtensionName.contents = "second-new-extension";
                }));
          Curry._2(and, "load them and convert as c1", (function (param) {
                  var firstExtensionFileData = Main$Meta3d.loadExtension(firstExtension.contents);
                  var secondExtensionFileData = Main$Meta3d.loadExtension(secondExtension.contents);
                  c1.contents = Main$Meta3d.convertAllFileDataForPackage([
                        firstExtensionFileData,
                        secondExtensionFileData
                      ], [], [
                        allExtensionNewNames.contents,
                        [entryExtensionName.contents],
                        []
                      ]);
                }));
        };
        test("load and init generated package", (function (param) {
                var given = param.given;
                var state = {
                  contents: 1
                };
                _prepare(given);
                _prepareForLoadAndHandleGeneratedPackage(given, param.and, [
                      PackageManagerTool$Meta3d.prepareInitFlag,
                      PackageManagerTool$Meta3d.buildEmptyExtensionFileStrWithOnInit
                    ]);
                CucumberAsync$Meta3dBsJestCucumber.execStep(param.when, "generate package with c1 and load it and init the entry extension", (function (param) {
                        var match = Main$Meta3d.loadPackage(Main$Meta3d.generatePackage(c1.contents));
                        var s = match[0];
                        state.contents = s;
                        var __x = Main$Meta3d.initExtension(s, match[2], 10);
                        return Js_promise.then_((function (s) {
                                      state.contents = s;
                                      return Promise.resolve(undefined);
                                    }), __x);
                      }));
                Curry._2(param.then, "the second extension should be inited", (function (param) {
                        Operators$Meta3dBsJestCucumber.$eq(expect(PackageManagerTool$Meta3d.getInitFlag(undefined)), 12);
                      }));
              }));
      }));

export {
  feature ,
}
/* feature Not a pure module */