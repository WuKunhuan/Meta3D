open Antd
%%raw("import 'antd/dist/reset.css'")

type values = {account: string}

@react.component
let make = (~service: FrontendType.service) => {
  let dispatch = AppStore.useDispatch()

  let _onFinish = values => {
    let {account} = values->Obj.magic

    service.backend.checkUserName(account)->Meta3dBsMostDefault.Most.flatMap(isPass => {
      !isPass
        ? {
            service.console.error(. `邮箱已经存在，请重新输入新的邮箱`, 2->Some)

            Meta3dBsMostDefault.Most.empty()
          }
        : {
            service.backend.registerUser(account)->Meta3dBsMostDefault.Most.tap(_ => {
              dispatch(AppStoreType.UserCenterAction(UserCenterStoreType.SetAccount(account)))

              RescriptReactRouter.push("/")
            }, _)
          }
    }, _)->Meta3dBsMostDefault.Most.drain->Js.Promise.catch(e => {
      service.console.errorWithExn(. e->Error.promiseErrorToExn, None)->Obj.magic
    }, _)->Obj.magic
  }

  let _onFinishFailed = errorInfo => {
    service.console.error(. {j`Failed: ${errorInfo->Obj.magic->Js.Json.stringify}`}, 2->Some)
  }

  <Layout>
    // <Layout.Header>
    //   <Nav currentKey="1" account=None />
    // </Layout.Header>
    <Layout.Content>
      <Form
        //   name="basic"
        labelCol={{
          "span": 8,
        }}
        wrapperCol={{
          "span": 6,
        }}
        initialValues={{
          "remember": true,
        }}
        onFinish={_onFinish}
        onFinishFailed={_onFinishFailed}
        autoComplete="off">
        <Form.Item
          label={`邮箱`}
          name="account"
          rules={[
            {
              _type: #email -> Meta3dCommonlib.NullableSt.return,
              required: true,
              message: `请输入正确的邮箱`,
            },
          ]}>
          <Input />
        </Form.Item>
        <Form.Item
          wrapperCol={{
            "offset": 8,
            "span": 16,
          }}>
          <Button _type=#primary htmlType="submit"> {React.string(`注册`)} </Button>
        </Form.Item>
      </Form>
    </Layout.Content>
  </Layout>
}
