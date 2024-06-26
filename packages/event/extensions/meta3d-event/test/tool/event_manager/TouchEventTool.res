open EventManagerStateType

open Meta3dEventProtocol.EventType

let setLastXY = (lastX, lastY) =>
  ContainerManager.getState(EventExtensionTool.buildEventExtentsionProtocolName())
  ->HandleTouchEventDoService.setLastXY(lastX, lastY)
  ->ContainerManager.setState(EventExtensionTool.buildEventExtentsionProtocolName())

let getIsDrag = () =>
  ContainerManager.getState(
    EventExtensionTool.buildEventExtentsionProtocolName(),
  )->HandleTouchEventDoService.getIsDrag

let setIsDrag = isDrag =>
  ContainerManager.getState(EventExtensionTool.buildEventExtentsionProtocolName())
  ->HandleTouchEventDoService.setIsDrag(isDrag)
  ->ContainerManager.setState(EventExtensionTool.buildEventExtentsionProtocolName())

let buildTouchData = (~pageX=10, ~pageY=20, ()) =>
  {
    "clientX": 0,
    "clientY": 0,
    "pageX": pageX,
    "pageY": pageY,
    "identifier": 0,
    "screenX": 0,
    "screenY": 0,
    "radiusX": 0,
    "radiusY": 0,
    "rotationAngle": 0,
    "force": 0,
  }

let buildTouchEvent = (
  ~touches=[buildTouchData()],
  ~changedTouches=[buildTouchData()],
  ~targetTouches=[buildTouchData()],
  ~preventDefaultFunc=() => (),
  ~stopPropagationFunc=() => (),
  (),
) =>
  {
    "touches": touches,
    "changedTouches": changedTouches,
    "targetTouches": targetTouches,
    "preventDefault": preventDefaultFunc,
    "stopPropagation": stopPropagationFunc,
  }

let prepareWithState = (
  ~sandbox,
  ~state,
  ~offsetLeft=1,
  ~offsetTop=2,
  ~offsetParent=Js.Nullable.undefined,
  ~setBrowserFunc=BrowserDetectTool.setAndroid,
  (),
) => {
  let canvasDom = EventTool.buildFakeCanvas((offsetLeft, offsetTop, offsetParent))

  state
  ->BodyDoService.setBody(BodyTool.getBody())
  ->CanvasDoService.setCanvas(canvasDom->Obj.magic)
  ->setBrowserFunc
  ->InitEventDoService.initEvent(EventExtensionTool.buildEventExtentsionProtocolName())
}

let prepare = (
  ~sandbox,
  ~offsetLeft=1,
  ~offsetTop=2,
  ~offsetParent=Js.Nullable.undefined,
  ~setBrowserFunc=BrowserDetectTool.setAndroid,
  (),
) => {
  prepareWithState(
    ~sandbox,
    ~offsetLeft,
    ~offsetTop,
    ~offsetParent,
    ~setBrowserFunc,
    ~state=ContainerManager.getState(EventExtensionTool.buildEventExtentsionProtocolName()),
    (),
  )->ContainerManager.setState(EventExtensionTool.buildEventExtentsionProtocolName())
}
