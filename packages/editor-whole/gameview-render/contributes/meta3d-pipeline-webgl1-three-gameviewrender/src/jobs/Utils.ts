import { state, states, pipelineName } from "meta3d-pipeline-webgl1-three-gameviewrender-protocol/src/StateType"

export let getState = (states: states): state  => {
    return states[pipelineName]
}

export let setState = (states: states, state: state): states  => {
    return Object.assign({}, states, {
        [pipelineName]: state
    });
}