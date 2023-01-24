import { state, states, pipelineName } from "meta3d-pipeline-webgl1-detectgl-protocol/src/StateType"
import { pipelineName as dataPipelineName } from "meta3d-pipeline-webgl1-data-protocol/src/StateType"
import { getExn } from "meta3d-commonlib-ts/src/NullableUtils"

export function getState(states: states): state {
    return states[pipelineName]
}

export function setState(states: states, state: state): states {
    return Object.assign({}, states, {
        [pipelineName]: state
    });
}

export function getGL(states: states) {
    return getExn(states[dataPipelineName].gl)
}