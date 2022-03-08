open Meta3dBsJestCucumber
open Cucumber
open Expect
open Operators

let feature = loadFeature("./test/features/gameobject.feature")

defineFeature(feature, test => {
  let contribute = ref(Obj.magic(1))

  let _buildGameObjectData = (
    ~createStateFunc=(. config) => Obj.magic(1),
    ~createGameObjectFunc=(. state) => (state, Obj.magic(1)),
    ~getAllGameObjectsFunc=(. state) => [],
    ~deferDisposeGameObjectFunc=(. state, gameObject) => state,
    ~batchDisposeGameObjectsFunc=(. states, batchDisposeTransformsFunc, gameObjects) => states,
    (),
  ): Meta3dEngineCoreProtocol.GameObjectType.gameObjectContribute => {
    createStateFunc: createStateFunc,
    createGameObjectFunc: createGameObjectFunc,
    getAllGameObjectsFunc: getAllGameObjectsFunc,
    deferDisposeGameObjectFunc: deferDisposeGameObjectFunc,
    batchDisposeGameObjectsFunc: batchDisposeGameObjectsFunc,
  }

  let _prepare = (given, \"when", \"and", c) => {
    given("prepare register", () => {
      CreateState.createState()->StateContainer.setState
    })

    \"when"("set gameObject contribute", () => {
      contribute := c

      MainTool.setGameObjectContribute(contribute.contents)
    })

    \"and"("create and set the gameObject state", () => {
      MainTool.createAndSetGameObjectState(Obj.magic(1))
    })
  }

  test(."create a gameObject", ({given, \"when", \"and", then}) => {
    _prepare(
      given,
      \"when",
      \"and",
      _buildGameObjectData(
        ~createStateFunc=(. config) => {
          {
            "maxUID": 0,
            "config": config,
          }->Obj.magic
        },
        ~createGameObjectFunc=(. state) => {
          let gameObject = JsObjTool.getObjValue(state, "maxUID")

          (
            {
              "maxUID": JsObjTool.getObjValue(state, "maxUID")->succ,
            }->Obj.magic,
            gameObject,
          )
        },
        ~getAllGameObjectsFunc=(. state) => {
          Meta3dCommonlib.ArraySt.range(0, JsObjTool.getObjValue(state, "maxUID") - 1)->Obj.magic
        },
        (),
      ),
    )

    then("createGameObject should create a gameObject", () => {
      MainTool.createGameObject()->expect == 0
    })
  })

  test(."defer dispose gameObject", ({given, \"and", \"when", then}) => {
    let g1 = ref(Obj.magic(1))

    _prepare(
      given,
      \"when",
      \"and",
      _buildGameObjectData(
        ~createStateFunc=(. config) => {
          {
            "needDisposeArray": [],
          }->Obj.magic
        },
        ~createGameObjectFunc=(. state) => {
          (state, 1->Obj.magic)
        },
        ~deferDisposeGameObjectFunc=(. state, gameObject) => {
          {
            "needDisposeArray": JsObjTool.getObjValue(
              state,
              "needDisposeArray",
            )->Meta3dCommonlib.ArraySt.push(gameObject),
          }->Obj.magic
        },
        (),
      ),
    )

    given("create a gameObject as g1", () => {
      g1 := MainTool.createGameObject()
    })

    \"when"("defer dispose g1", () => {
      MainTool.deferDisposeGameObject(g1.contents)
    })

    then("mark g1 as need dispose", () => {
      JsObjTool.getObjValue(MainTool.getGameObjectState(), "needDisposeArray")
      ->Js.Array.includes(g1.contents, _)
      ->expect == true
    })
  })

  test(."batch dispose gameObjects", ({given, \"and", \"when", then}) => {
    let g1 = ref(Obj.magic(1))
    let t1 = ref(Obj.magic(1))
    let transformContribute = ref(Obj.magic(1))
    let usedTransformContribute: ref<
      Meta3dEngineCoreProtocol.RegisterComponentType.usedComponentContribute,
    > = ref(Obj.magic(1))
    let transformName = Meta3dComponentTransformProtocol.Index.componentName

    let _prepareTransform = (\"when", \"and", c) => {
      \"when"("register transform contribute", () => {
        transformContribute := c

        MainTool.registerComponent(transformContribute.contents)
      })

      \"and"("create and set transform state", () => {
        MainTool.createAndSetComponentState(c.componentName, Obj.magic(1))
      })
    }

    _prepare(
      given,
      \"when",
      \"and",
      _buildGameObjectData(
        ~createStateFunc=(. config) => {
          {
            "disposedArray": [],
          }->Obj.magic
        },
        ~createGameObjectFunc=(. state) => {
          (state, 1->Obj.magic)
        },
        ~batchDisposeGameObjectsFunc=(. state, batchDisposeComponentsFunc, gameObjects) => {
          let transformState = batchDisposeComponentsFunc(.
            usedTransformContribute.contents.state,
            [t1.contents],
          )

          (
            {
              "disposedArray": JsObjTool.getObjValue(state, "disposedArray")->Js.Array.concat(
                gameObjects,
              ),
            }->Obj.magic,
            transformState,
          )
        },
        (),
      ),
    )

    _prepareTransform(
      \"when",
      \"and",
      ComponentTool.buildComponentContribute(
        ~componentName=transformName,
        ~createComponentFunc=(. state) => {
          let component = 1->Obj.magic

          (state, component)
        },
        ~createStateFunc=(. _) => {
          {
            "disposedArray": [],
          }->Obj.magic
        },
        ~batchDisposeComponentsFunc=(. state, components) => {
          {
            "disposedArray": JsObjTool.getObjValue(state, "disposedArray")->Js.Array.concat(
              components,
            ),
          }->Obj.magic
        },
        (),
      ),
    )

    \"and"("create a gameObject as g1", () => {
      g1 := MainTool.createGameObject()
    })

    \"and"("create a transform as t1", () => {
      let (d, transform) =
        MainTool.unsafeGetUsedComponentContribute(transformName)->MainTool.createComponent

      t1 := transform
      usedTransformContribute := d
    })

    \"and"("add t1 to g1", () => {
      ()
    })

    \"when"("batch dispose [g1]", () => {
      MainTool.batchDisposeGameObjects([g1.contents])
    })

    then("mark g1 as disposed", () => {
      JsObjTool.getObjValue(MainTool.getGameObjectState(), "disposedArray")
      ->Js.Array.includes(g1.contents, _)
      ->expect == true
    })

    \"and"("mark t1 as disposed", () => {
      JsObjTool.getObjValue(MainTool.getComponentState(transformName), "disposedArray")
      ->Js.Array.includes(t1.contents, _)
      ->expect == true
    })
  })

  test(."get all gameObjects", ({given, \"when", \"and", then}) => {
    let allGameObjects = []

    _prepare(
      given,
      \"when",
      \"and",
      _buildGameObjectData(
        ~createStateFunc=(. config) => {
          {
            "maxUID": 0,
            "config": config,
          }->Obj.magic
        },
        ~createGameObjectFunc=(. state) => {
          let gameObject = JsObjTool.getObjValue(state, "maxUID")

          (
            {
              "maxUID": JsObjTool.getObjValue(state, "maxUID")->succ,
            }->Obj.magic,
            gameObject,
          )
        },
        ~getAllGameObjectsFunc=(. state) => {
          Meta3dCommonlib.ArraySt.range(0, JsObjTool.getObjValue(state, "maxUID") - 1)->Obj.magic
        },
        (),
      ),
    )

    \"when"("create two gameObjects", () => {
      allGameObjects
      ->Meta3dCommonlib.ArraySt.push(MainTool.createGameObject())
      ->Meta3dCommonlib.ArraySt.push(MainTool.createGameObject())
      ->ignore
    })

    then("getAllGameObjects should return them", () => {
      MainTool.getAllGameObjects()->expect == allGameObjects
    })
  })
})
