

import * as Caml_option from "../../../../../../node_modules/rescript/lib/es6/caml_option.js";
import * as Main$Meta3d from "../../src/Main.bs.js";
import * as PackageManagerTool$Meta3d from "./PackageManagerTool.bs.js";
import * as ImmutableHashMap$Meta3dCommonlib from "../../../../../../node_modules/meta3d-commonlib/lib/es6_global/src/structure/hash_map/ImmutableHashMap.bs.js";

function generateExtension(name, protocol, displayNameOpt, repoLinkOpt, descriptionOpt, fileStrOpt, dependentBlockProtocolNameMapOpt, param) {
  var displayName = displayNameOpt !== undefined ? displayNameOpt : "";
  var repoLink = repoLinkOpt !== undefined ? repoLinkOpt : "";
  var description = descriptionOpt !== undefined ? descriptionOpt : "";
  var fileStr = fileStrOpt !== undefined ? fileStrOpt : PackageManagerTool$Meta3d.buildEmptyExtensionFileStr(undefined);
  var dependentBlockProtocolNameMap = dependentBlockProtocolNameMapOpt !== undefined ? Caml_option.valFromOption(dependentBlockProtocolNameMapOpt) : ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined);
  return Main$Meta3d.generateExtension({
              name: name,
              protocol: protocol,
              displayName: displayName,
              repoLink: repoLink,
              description: description,
              dependentBlockProtocolNameMap: dependentBlockProtocolNameMap
            }, fileStr);
}

function generateContribute(name, protocol, displayNameOpt, repoLinkOpt, descriptionOpt, fileStrOpt, dependentBlockProtocolNameMapOpt, param) {
  var displayName = displayNameOpt !== undefined ? displayNameOpt : "";
  var repoLink = repoLinkOpt !== undefined ? repoLinkOpt : "";
  var description = descriptionOpt !== undefined ? descriptionOpt : "";
  var fileStr = fileStrOpt !== undefined ? fileStrOpt : PackageManagerTool$Meta3d.buildEmptyContributeFileStr(undefined);
  var dependentBlockProtocolNameMap = dependentBlockProtocolNameMapOpt !== undefined ? Caml_option.valFromOption(dependentBlockProtocolNameMapOpt) : ImmutableHashMap$Meta3dCommonlib.createEmpty(undefined, undefined);
  return Main$Meta3d.generateContribute({
              name: name,
              protocol: protocol,
              displayName: displayName,
              repoLink: repoLink,
              description: description,
              dependentBlockProtocolNameMap: dependentBlockProtocolNameMap
            }, fileStr);
}

export {
  generateExtension ,
  generateContribute ,
}
/* No side effect */
