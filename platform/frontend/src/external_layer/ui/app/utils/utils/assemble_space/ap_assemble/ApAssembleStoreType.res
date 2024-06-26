type protocolIconBase64 = string

type protocolConfigStr = AssembleSpaceCommonType.protocolConfigStr

type id = string

// type newName = string

type version = string

type extension = {
  id: id,
  protocolIconBase64: protocolIconBase64,
  protocolConfigStr: option<protocolConfigStr>,
  // newName: option<newName>,
  // TODO remove
  isStart: bool,
  version: version,
  data: Meta3d.ExtensionFileType.extensionFileData,
}

type selectedExtensions = list<extension>

type contribute = {
  id: id,
  protocolIconBase64: protocolIconBase64,
  protocolConfigStr: option<protocolConfigStr>,
  // newName: option<newName>,
  version: version,
  data: Meta3d.ExtensionFileType.contributeFileData,
}

// type selectedContributes = list<(
//   contribute,
//   option<CommonType.protocolConfig>,
// )>

type selectedContributes = list<contribute>

type package = AssembleSpaceCommonType.packageData

type selectedPackages = list<package>

// type selectedElements = list<BackendCloudbaseType.elementAssembleData>

type isDebug = bool

type clearColor = (float, float, float, float)

type skinName = string

type apInspectorData = {
  isDebug: isDebug,
  clearColor: clearColor,
  skinName: option<skinName>,
}

type apInspectorDataFromFile = {
  isDebug: isDebug,
  clearColor: clearColor,
  skinName: Js.Nullable.t<skinName>,
}

type action =
  | ResetWhenEnter
  | ResetWhenSwitch
  | SelectPackage(package)
  | SelectExtension(
      protocolIconBase64,
      option<protocolConfigStr>,
      AssembleSpaceCommonType.extension,
    )
  | SetInspectorCurrentExtensionId(id)
  | StartPackage(id)
  | UnStartPackage(id)
  | StartExtension(id)
  | UnStartExtension(id)
  // | SetExtensionNewName(id, newName)
  | SelectContribute(
      protocolIconBase64,
      option<protocolConfigStr>,
      AssembleSpaceCommonType.contribute,
    )
  | SetInspectorCurrentContributeId(id)
  | SetInspectorCurrentPackageId(id)
  // | SetContributeNewName(id, newName)
  | ShowApInspector
  | SetIsDebug(isDebug)
  | SetClearColor(clearColor)
  | SetSkinName(option<skinName>)
  | SetApInspectorData(apInspectorDataFromFile)
  | UpdateSelectedExtension(id, Js.Typed_array.Uint8Array.t)
  | UpdateSelectedContribute(id, Js.Typed_array.Uint8Array.t)
  | UpdateSelectedPackage(id, Js.Typed_array.ArrayBuffer.t)
  | MarkIsPassDependencyGraphCheck(bool)
  | UpdateSelectedPackagesAndExtensionsAndContributes(
      selectedPackages,
      selectedExtensions,
      selectedContributes,
    )
  | StorePackageInApp(id)
  | UnStorePackageInApp(id)
  | BatchStorePackagesInApp(list<id>)
  // | SelectAllElements(selectedElements)
  | SetContributesAndPackages(
      selectedContributes,
      selectedPackages,
    )

type state = {
  selectedPackages: selectedPackages,
  selectedExtensions: selectedExtensions,
  selectedContributes: selectedContributes,
  // selectedElements: selectedElements,
  inspectorCurrentExtensionId: option<id>,
  inspectorCurrentContributeId: option<id>,
  inspectorCurrentPackageId: option<id>,
  isShowApInspector: bool,
  apInspectorData: apInspectorData,
  isPassDependencyGraphCheck: bool,
  storedPackageIdsInApp: AssembleSpaceCommonType.storedPackageIdsInApp,
  isChangeSelectedPackagesByDebug: bool,
}
