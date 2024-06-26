import { getExtensionService as getExtensionServiceMeta3D, createExtensionState as createExtensionStateMeta3D, getExtensionLife as getLifeMeta3D, state as meta3dState } from "meta3d-type"
import { state } from "meta3d-engine-basic-protocol/src/state/StateType"
import { service } from "meta3d-engine-basic-protocol/src/service/ServiceType"
import { getExtensionServiceUtils } from "meta3d-engine-basic-utils/src/Main"

export let getExtensionService: getExtensionServiceMeta3D<
	service
> = (api) => {
	return getExtensionServiceUtils(api)
}

export let createExtensionState: createExtensionStateMeta3D<
	state
> = () => {
	return null
}

export let getExtensionLife: getLifeMeta3D<service> = (api, extensionProtocolName) => {
	return {
	}
}
