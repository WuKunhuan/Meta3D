open Antd
%%raw("import 'antd/dist/reset.css'")
open AssembleSpaceType

module Method = {
  let getUIControls = SelectedContributesForElementUtils.getUIControls

  let _convertSpecificType = (
    specific: Meta3dType.UIControlProtocolConfigType.uiControlSpecificDataFields,
  ): ElementAssembleStoreType.specific => {
    specific->Meta3dCommonlib.ArraySt.map(({
      value,
      name,
      type_,
    }): ElementAssembleStoreType.specificData => {
      {
        name,
        type_,
        value: value->CommonType.SpecicFieldDataValue,
      }
    })
  }

  let _getScenViewUIControlProtocolName = () => "meta3d-ui-control-scene-view-protocol"

  let _checkShouldOnlyHasOneSceneViewUIControlAtMost = (
    protocolName,
    selectedUIControls: ElementAssembleStoreType.selectedUIControls,
  ) => {
    protocolName === _getScenViewUIControlProtocolName()
      ? {
          selectedUIControls
          ->Meta3dCommonlib.ListSt.filter(uiControl => {
            uiControl.data.contributePackageData.protocol.name === protocolName
          })
          ->Meta3dCommonlib.ListSt.length !== 0
            ? Some({j`只能有1个Scene View UI Control`})
            : None
        }
      : None
  }

  let selectUIControl = (
    service,
    dispatch,
    // handleWhenSelectUIControlFunc,
    eventEmitter: Event.eventEmitter,
    selectedUIControls,
    selectedContributes,
    protocolIconBase64,
    protocolConfigStr,
    displayName,
    data: Meta3d.ExtensionFileType.contributeFileData,
    parentUIControlId,
  ) => {
    let protocolConfigStr = protocolConfigStr->Meta3dCommonlib.OptionSt.getExn

    switch _checkShouldOnlyHasOneSceneViewUIControlAtMost(
      data.contributePackageData.protocol.name,
      selectedUIControls,
    ) {
    | Some(errorMessage) => service.console.error(. errorMessage, None)
    | None =>
      let id = IdUtils.generateId(service.other.random)

      dispatch(
        ElementAssembleStoreType.SelectUIControl(
          id,
          protocolIconBase64,
          protocolConfigStr,
          displayName,
          data,
          parentUIControlId,
          service.meta3d.getUIControlSpecificDataFields(.
            service.meta3d.serializeUIControlProtocolConfigLib(. protocolConfigStr),
          )->_convertSpecificType,
        ),
      )
      dispatch(
        ElementAssembleStoreType.SelectSelectedUIControl(
          (service.meta3d.hasChildren, service.meta3d.serializeUIControlProtocolConfigLib),
          id,
        ),
      )

      // handleWhenSelectUIControlFunc(data.contributePackageData.protocol.name)
      eventEmitter.emit(.
        EventUtils.getSelectUIControlEventName(),
        data.contributePackageData.protocol.name->Obj.magic,
      )
    }
  }

  let useSelector = ({assembleSpaceState, eventEmitter}: AppStoreType.state) => {
    let {apAssembleState, elementAssembleState} = assembleSpaceState

    let {selectedUIControls, parentUIControlId} = elementAssembleState

    ((selectedUIControls, parentUIControlId), eventEmitter)
  }
}

@react.component
let make = (
  ~service: service,
  // ~handleWhenShowUIControlsFunc,
  // ~handleWhenSelectUIControlFunc,
  ~setIsShowUIControls,
  ~selectedContributes,
  ~selectSceneViewUIControlTarget: React.ref<Js.Nullable.t<'a>>,
  ~selectGameViewUIControlTarget: React.ref<Js.Nullable.t<'a>>,
  ~selectWindowUIControlTarget: React.ref<Js.Nullable.t<'a>>,
  ~selectButtonUIControlTarget: React.ref<Js.Nullable.t<'a>>,
) => {
  let dispatch = ReduxUtils.ElementAssemble.useDispatch(service.react.useDispatch)

  let ((selectedUIControls, parentUIControlId), eventEmitter) = service.react.useAllSelector(.
    Method.useSelector,
  )

  // service.react.useEffect(.() => {
  //   // handleWhenShowUIControlsFunc()
  //   eventEmitter.emit(. EventUtils.getAddUIControlsEventName(), Obj.magic(1))

  //   None
  // })

  service.react.useEffect1(. () => {
    // handleWhenShowUIControlsFunc()
    // eventEmitter.emit(. EventUtils.getAddUIControlsEventName(), Obj.magic(1))

    None
  }, [])

  // TODO duplicate with ap view
  <List
    grid={{gutter: 16, column: 3}}
    dataSource={selectedContributes->Method.getUIControls->Meta3dCommonlib.ListSt.toArray}
    renderItem={({id, protocolIconBase64, protocolConfigStr, data}) => {
      // let name = data.contributePackageData.name
      let displayName = data.contributePackageData.displayName

      <List.Item
        ref={data.contributePackageData.protocol.name->GuideUtils.isSceneViewProtocolName
          ? selectSceneViewUIControlTarget
          : data.contributePackageData.protocol.name->GuideUtils.isGameViewProtocolName
          ? selectGameViewUIControlTarget
          : data.contributePackageData.protocol.name->GuideUtils.isWindowProtocolName
          ? selectWindowUIControlTarget
          : data.contributePackageData.protocol.name->GuideUtils.isButtonProtocolName
          ? selectButtonUIControlTarget
          : Meta3dCommonlib.NullableSt.getEmpty()->Obj.magic}>
        <Card
          key={id}
          onClick={_ => {
            MessageUtils.showCatchedErrorMessage(() => {
              Method.selectUIControl(
                service,
                dispatch,
                // handleWhenSelectUIControlFunc,
                eventEmitter,
                selectedUIControls,
                selectedContributes,
                protocolIconBase64,
                protocolConfigStr,
                displayName,
                data,
                parentUIControlId,
              )

              setIsShowUIControls(_ => false)
            }, 5->Some)
          }}
          bordered={false}
          bodyStyle={ReactDOM.Style.make(~padding="0px", ())}
          cover={<div
            style={ReactDOM.Style.make(
              ~display="flex",
              ~alignItems="center",
              ~justifyContent="center",
              (),
            )}>
            <Image preview=false src={protocolIconBase64} width=50 height=50 />
          </div>}>
          <Card.Meta
            title={<Row justify=#center>
              <span
                style={ReactDOM.Style.make(
                  ~whiteSpace="normal",
                  ~wordWrap="break-word",
                  ~wordBreak="break-all",
                  (),
                )}>
                {React.string(displayName)}
              </span>
            </Row>}
          />
        </Card>
      </List.Item>
    }}
  />
}
