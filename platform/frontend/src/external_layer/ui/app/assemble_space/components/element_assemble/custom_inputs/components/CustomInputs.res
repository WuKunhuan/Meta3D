open Antd
%%raw("import 'antd/dist/antd.css'")
open AssembleSpaceType

module Method = {
  let buildDefaultInputFileStr = inputName => {
    j`window.Contribute = {
    getContribute: (api) => {
      return {
        inputName: "${inputName}",
        func: (meta3dState) =>{
            return Promise.resolve(null)
        }
      }
    }
}`
  }

  let useSelector = ({elementAssembleState}: AssembleSpaceStoreType.state) => {
    let {customInputs, currentCustomInputName} = elementAssembleState

    (customInputs, currentCustomInputName)
  }
}

@react.component
let make = (~service: service) => {
  let dispatch = ReduxUtils.ElementAssemble.useDispatch(service.react.useDispatch)

  let (customInputs, currentCustomInputName) = service.react.useSelector(. Method.useSelector)

  <CustomDomUtils
    service
    buildSelectActionFunc={key => ElementAssembleStoreType.SelectCustomInput(key)}
    buildAddActionFunc={customInput => ElementAssembleStoreType.AddCustomInput(customInput)}
    buildRemoveActionFunc={inputName => ElementAssembleStoreType.RemoveCustomInput(inputName)}
    buildDefaultFileStrFunc=Method.buildDefaultInputFileStr
    setCurrentCustomNameToGlobalFunc=CodeEditUtils.setCurrentCustomInputNameToGlobal
    currentCustomName= currentCustomInputName
    customs=customInputs
    prefix="Input"
  />
}