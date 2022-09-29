open FrontendUtils.Antd
%%raw("import 'antd/dist/antd.css'")
open FrontendUtils.AssembleSpaceType

// TODO refactor: duplicate

module Method = {
  let selectContribute = (dispatch, id) => {
    dispatch(FrontendUtils.ApViewStoreType.SetInspectorCurrentContributeId(id))
  }

  let useSelector = ({selectedContributes}: FrontendUtils.ApViewStoreType.state) => {
    selectedContributes
  }
}

@react.component
let make = (~service: service) => {
  let dispatch = ReduxUtils.ApView.useDispatch(service.react.useDispatch)

  let selectedContributes = ReduxUtils.ApView.useSelector(
    service.react.useSelector,
    Method.useSelector,
  )

  <List
    grid={{gutter: 16, column: 1}}
    dataSource={selectedContributes->Meta3dCommonlib.ListSt.toArray}
    renderItem={({id, protocolIconBase64, newName, data} as contribute) => {
      <List.Item>
        <Card
          key={id}
          onClick={_ => {
            Method.selectContribute(dispatch, id)
          }}
          bodyStyle={ReactDOM.Style.make(~padding="0px", ())}
          cover={<img
            style={ReactDOM.Style.make(~width="50px", ~height="50px", ())} src={protocolIconBase64}
          />}>
          <Card.Meta
            style={ReactDOM.Style.make(~width="100px", ())}
            title={React.string(NewNameUtils.getName(newName, data.contributePackageData.name))}
          />
        </Card>
      </List.Item>
    }}
  />
}