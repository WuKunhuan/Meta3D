import { state as meta3dState, extensionName } from "meta3d-type/src/Index"
import { actionName, actionContribute } from "../contribute/ActionContributeType"
import { state } from "../state/StateType"
import { customEvent, userData } from "./EventType.gen"
import { browser } from "./BrowserType.gen"
import { nullable } from "meta3d-commonlib-ts/src/nullable"
import { service as eventDataService } from "meta3d-event-data-protocol/src/service/ServiceType"
import { service as eventSourcingService } from "meta3d-event-sourcing-protocol/src/service/ServiceType"

type eventExtensionProtocolName = extensionName

type pointEventName =
    "meta3d_pointdown"
    | "meta3d_pointup"
    | "meta3d_pointtap"
    | "meta3d_pointmove"
    | "meta3d_pointscale"
    | "meta3d_pointdragstart"
    | "meta3d_pointdragover"
    | "meta3d_pointdragdrop"

type customEventName = string

type priority = number

export type handleFunc = (customEvent: customEvent) => void

type handleFunc2 = (meta3dState: meta3dState, customEvent: customEvent) => meta3dState

type handleFunc3 = (meta3dState: meta3dState, customEvent: customEvent) => Promise<meta3dState>

export type service = {
    eventData: (meta3dState: meta3dState) => eventDataService,
    eventSourcing: (meta3dState: meta3dState) => eventSourcingService,
    trigger: <uiData> (
        meta3dState: meta3dState,
        eventExtensionProtocolName: eventExtensionProtocolName,
        actionName: actionName,
        uiData: uiData
    ) => Promise<meta3dState>;
    registerAction: <uiData, state>(
        state: state,
        actionContribute: actionContribute<uiData, state>
    ) => state;
    onPointEvent(
        eventExtensionProtocolName: eventExtensionProtocolName,
        [pointEventName, priority, handleFunc]: [pointEventName, priority, handleFunc]
    ): void;
    onCustomGlobalEvent(
        eventExtensionProtocolName: eventExtensionProtocolName,
        [customEventName, priority, handleFunc]: [customEventName, priority, handleFunc]
    ): void;
    offCustomGlobalEventByHandleFunc(
        eventExtensionProtocolName: eventExtensionProtocolName,
        [customEventName, handleFunc]: [customEventName, handleFunc]
    ): void;
    onCustomGlobalEvent2(
        meta3dState: meta3dState,
        eventExtensionProtocolName: eventExtensionProtocolName,
        [customEventName, priority, handleFunc]: [customEventName, priority, handleFunc2]
    ): meta3dState;
    triggerCustomGlobalEvent2(
        meta3dState: meta3dState,
        eventExtensionProtocolName: eventExtensionProtocolName,
        customEvent: customEvent
    ): meta3dState;
    onCustomGlobalEvent3(
        meta3dState: meta3dState,
        eventExtensionProtocolName: eventExtensionProtocolName,
        [customEventName, priority, handleFunc]: [customEventName, priority, handleFunc3]
    ): meta3dState;
    triggerCustomGlobalEvent3(
        meta3dState: meta3dState,
        eventExtensionProtocolName: eventExtensionProtocolName,
        customEvent: customEvent
    ): Promise<meta3dState>;
    createCustomEvent(
        customEventName: customEventName,
        userData: nullable<userData>
    ): customEvent;
    initEvent(
        meta3dState: meta3dState,
        eventExtensionProtocolName: eventExtensionProtocolName,
    ): meta3dState;
    setBrowser(
        meta3dState: meta3dState,
        eventExtensionProtocolName: eventExtensionProtocolName,
        browser: browser
    ): meta3dState;
    setCanvas(
        meta3dState: meta3dState,
        eventExtensionProtocolName: eventExtensionProtocolName,
        canvas: HTMLCanvasElement
    ): meta3dState;
    setBody(
        meta3dState: meta3dState,
        eventExtensionProtocolName: eventExtensionProtocolName,
        body: HTMLBodyElement
    ): meta3dState;
    getBrowserChromeType(): browser;
    getBrowserFirefoxType(): browser;
    getBrowserAndroidType(): browser;
    getBrowserIOSType(): browser;
    getBrowserUnknownType(): browser;
    getPointDownEventName(): pointEventName;
    getPointUpEventName(): pointEventName;
    getPointTapEventName(): pointEventName;
    getPointMoveEventName(): pointEventName;
    getPointScaleEventName(): pointEventName;
    getPointDragStartEventName(): pointEventName;
    getPointDragOverEventName(): pointEventName;
    getAllActionContributes: <uiData, state>(state: state) => Array<actionContribute<uiData, state>>
};
