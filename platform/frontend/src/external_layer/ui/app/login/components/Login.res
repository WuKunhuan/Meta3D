open FrontendUtils.Antd
%%raw("import 'antd/dist/antd.css'")

type values = {account: string, password: string}

@react.component
let make = (~service: FrontendUtils.FrontendType.service) => {
  let dispatch = AppStore.useDispatch()

  let (isLoginBegin, setIsLoginBegin) = React.useState(_ => false)

  let _login = () => {
    MetamaskExtend.ethereum->Meta3dCommonlib.NullableSt.isNullable
      ? {
          setIsLoginBegin(_ => false)
          Message.error(. {j`请开启MetaMask钱包`}, 5)
        }
      : {
          setIsLoginBegin(_ => true)

          let accountRef = ref(Obj.magic(1))

          let {request} = MetamaskExtend.ethereum->Meta3dCommonlib.NullableSt.unsafeGet

          request({
            method: #eth_requestAccounts,
          })
          ->Meta3dBsMost.Most.fromPromise
          ->Meta3dBsMost.Most.map(accounts => accounts[0], _)
          ->Meta3dBsMost.Most.flatMap(account => {
            accountRef := account

            service.backend.handleLogin(account)
          }, _)
          ->Meta3dBsMost.Most.tap(_ => {
            dispatch(AppStore.UserCenterAction(UserCenterStore.SetAccount(accountRef.contents)))

            RescriptReactRouter.push("/")
          }, _)
          ->Meta3dBsMost.Most.drain
          ->Js.Promise.then_(_ => {
            setIsLoginBegin(_ => false)

            ()->Js.Promise.resolve
          }, _)
          ->Js.Promise.catch(e => {
            FrontendUtils.ErrorUtils.errorWithExn(
              e->FrontendUtils.Error.promiseErrorToExn,
              None,
            )->Obj.magic
          }, _)
        }
  }

  // let _onFinish = values => {
  //   let {account, password} = values->Obj.magic

  //   BackendCloudbase.isLoginSuccess(account, password)
  //   ->Meta3dBsMost.Most.tap(((isSuccess, failMsg)) => {
  //     !isSuccess
  //       ? {
  //           Message.error(. Meta3dCommonlib.NullableSt.getExn(failMsg), 5)

  //           ()
  //         }
  //       : {
  //           dispatch(AppStore.UserCenterAction(UserCenterStore.SetUserName(account)))

  //           RescriptReactRouter.push("/")
  //         }
  //   }, _)
  //   ->Meta3dBsMost.Most.drain
  //   ->Obj.magic
  // }

  // let _onFinishFailed = errorInfo => {
  //   Message.error(. {j`Failed: ${errorInfo->Obj.magic->Js.Json.stringify}`}, 5)
  // }

  <>
    <Nav />
    <Button
      onClick={_ => {
        _login()->ignore
      }}>
      {React.string(`使用MetaMask钱包登录`)}
    </Button>
    <h1>
      <a href="https://zhuanlan.zhihu.com/p/112285438" target="_blank">
        {React.string(`如何开启MetaMask钱包？`)}
      </a>
    </h1>
    {isLoginBegin ? <p> {React.string({j`loging...`})} </p> : React.null}
  </>
}
