import {

    getUIControlSpecificDataFields as getUIControlSpecificDataFieldsMeta3D,
    hasChildren as hasChildrenMeta3D,
    getUIControlSupportedEventNames as getUIControlSupportedEventNamesMeta3D, generateHandleUIControlEventStr as generateHandleUIControlEventStrMeta3D
} from "meta3d-type/src/contribute/UIControlProtocolConfigType"
import { isNullable } from "meta3d-commonlib-ts/src/NullableUtils"



let _generateUniqueId = () => {
    return Math.floor(Math.random() * 1000000.0).toString()
}

export let getUIControlSpecificDataFields: getUIControlSpecificDataFieldsMeta3D = () => [
    {
        name: "label",
        type_: "string",
        value: "复选框##" + _generateUniqueId()
    },
    {
        name: "isSelect",
        type_: "bool",
        value: false
    }
]

export let hasChildren: hasChildrenMeta3D = () => false

export let getUIControlSupportedEventNames: getUIControlSupportedEventNamesMeta3D = () => ["checkbox_select"]

export let generateHandleUIControlEventStr: generateHandleUIControlEventStrMeta3D = ([selectActionName]) => {
    if (!isNullable(selectActionName)) {
        return `
                if (!api.nullable.isNullable(data[1])) {
                    let { trigger } = api.getExtensionService(meta3dState, "meta3d-event-protocol")

                    return trigger(meta3dState, "meta3d-event-protocol", "${selectActionName}", api.nullable.getExn(data[1]))
                }
                `
    }

    return ""
}