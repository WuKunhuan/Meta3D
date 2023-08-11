/*! perf: only here import three.js, others(e.g. meta3d-pipeline-webgl1-three) shouln't import three.js again
* 
*/

import { service } from "meta3d-three-api-protocol/src/service/ServiceType"
import { state } from "meta3d-three-api-protocol/src/state/StateType"
import { getExtensionService as getExtensionServiceMeta3D, createExtensionState as createExtensionStateMeta3D, getExtensionLife as getLifeMeta3D } from "meta3d-type"
import {
    BufferAttribute, Color, CubeTexture, FrontSide, Layers, Matrix3, Matrix4, NoBlending, Sphere, Texture, Vector3, Quaternion, WebGLRenderer,
    ClampToEdgeWrapping,
    DoubleSide,
    InterpolateDiscrete,
    InterpolateLinear,
    NoColorSpace,
    LinearFilter,
    LinearMipmapLinearFilter,
    LinearMipmapNearestFilter,
    MathUtils,
    MirroredRepeatWrapping,
    NearestFilter,
    NearestMipmapLinearFilter,
    NearestMipmapNearestFilter,
    PropertyBinding,
    RGBAFormat,
    RepeatWrapping,
    Scene,
    Source,
    SRGBColorSpace,
    CompressedTexture,

    PlaneGeometry,
    ShaderMaterial,
    Uniform,
    Mesh,
    PerspectiveCamera,
} from "three";

export let getExtensionService: getExtensionServiceMeta3D<service> = (_api) => {
    return {
        // WebGLRenderer: () => WebGLRenderer,
        // BufferAttribute: () => BufferAttribute,
        // Color: () => Color,
        // CubeTexture: () => CubeTexture,
        // FrontSide: () => FrontSide,
        // Layers: () => Layers,
        // Matrix3: () => Matrix3,
        // Matrix4: () => Matrix4,
        // NoBlending: () => NoBlending,
        // Sphere: () => Sphere,
        // Texture: () => Texture,
        // Vector3: () => Vector3,
        // ClampToEdgeWrapping: () => ClampToEdgeWrapping,
        // DoubleSide: () => DoubleSide,
        // InterpolateDiscrete: () => InterpolateDiscrete,
        // InterpolateLinear: () => InterpolateLinear,
        // NoColorSpace: () => NoColorSpace,
        // LinearFilter: () => LinearFilter,
        // LinearMipmapLinearFilter: () => LinearMipmapLinearFilter,
        // LinearMipmapNearestFilter: () => LinearMipmapNearestFilter,
        // MathUtils: () => MathUtils,
        // MirroredRepeatWrapping: () => MirroredRepeatWrapping,
        // NearestFilter: () => NearestFilter,
        // NearestMipmapLinearFilter: () => NearestMipmapLinearFilter,
        // NearestMipmapNearestFilter: () => NearestMipmapNearestFilter,
        // PropertyBinding: () => PropertyBinding,
        // RGBAFormat: () => RGBAFormat,
        // RepeatWrapping: () => RepeatWrapping,
        // Scene: () => Scene,
        // Source: () => Source,
        // SRGBColorSpace: () => SRGBColorSpace,
        // CompressedTexture: () => CompressedTexture,
        // PlaneGeometry: () => PlaneGeometry,
        // ShaderMaterial: () => ShaderMaterial,
        // Uniform: () => Uniform,
        // Mesh: () => Mesh,
        // PerspectiveCamera: () => PerspectiveCamera,

        WebGLRenderer: WebGLRenderer,
        BufferAttribute: BufferAttribute,
        Color: Color,
        CubeTexture: CubeTexture,
        FrontSide: FrontSide,
        Layers: Layers,
        Matrix3: Matrix3,
        Matrix4: Matrix4,
        NoBlending: NoBlending,
        Sphere: Sphere,
        Texture: Texture,
        Vector3: Vector3,
        Quaternion: Quaternion,
        ClampToEdgeWrapping: ClampToEdgeWrapping,
        DoubleSide: DoubleSide,
        InterpolateDiscrete: InterpolateDiscrete,
        InterpolateLinear: InterpolateLinear,
        NoColorSpace: NoColorSpace,
        LinearFilter: LinearFilter,
        LinearMipmapLinearFilter: LinearMipmapLinearFilter,
        LinearMipmapNearestFilter: LinearMipmapNearestFilter,
        MathUtils: MathUtils,
        MirroredRepeatWrapping: MirroredRepeatWrapping,
        NearestFilter: NearestFilter,
        NearestMipmapLinearFilter: NearestMipmapLinearFilter,
        NearestMipmapNearestFilter: NearestMipmapNearestFilter,
        PropertyBinding: PropertyBinding,
        RGBAFormat: RGBAFormat,
        RepeatWrapping: RepeatWrapping,
        Scene: Scene,
        Source: Source,
        SRGBColorSpace: SRGBColorSpace,
        CompressedTexture: CompressedTexture,
        PlaneGeometry: PlaneGeometry,
        ShaderMaterial: ShaderMaterial,
        Uniform: Uniform,
        Mesh: Mesh,
        PerspectiveCamera: PerspectiveCamera,
    }
}

export let createExtensionState: createExtensionStateMeta3D<state> = () => {
    return null
}

export let getExtensionLife: getLifeMeta3D<service> = (api, extensionProtocolName) => {
    return {
    }
}