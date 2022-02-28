module ParsePipelineData = {
  // TODO use Result instead of throw err

  open Meta3dEngineCoreProtocol.PipelineType

  let _getStates = () => {
    StateContainer.unsafeGetState().states
  }

  let _setStates = (states): unit => {
    {
      ...StateContainer.unsafeGetState(),
      states: states,
    }->StateContainer.setState
  }

  let _findGroup = (groupName, groups) => {
    groups
    ->Meta3dCommonlib.ArraySt.filter(({name}: group) => name === groupName)
    ->Meta3dCommonlib.ArraySt.length > 1
      ? {
          Meta3dCommonlib.Exception.throwErr(
            Meta3dCommonlib.Exception.buildErr(j`groupName:$groupName has more than one in groups`),
          )
        }
      : {
          ()
        }

    switch groups
    ->Meta3dCommonlib.ListSt.fromArray
    ->Meta3dCommonlib.ListSt.getBy(({name}: group) => name === groupName) {
    | None =>
      Meta3dCommonlib.Exception.throwErr(
        Meta3dCommonlib.Exception.buildErr(j`groupName:$groupName not in groups`),
      )
    | Some(group) => group
    }
  }

  let _buildJobStream = (
    {just, flatMap, map}: Meta3dBsMostProtocol.ServiceType.service,
    elementFunc,
  ): Meta3dBsMostProtocol.StreamType.stream<unit> => {
    elementFunc->just->flatMap(func => func(_getStates()), _)->map(_setStates, _)
  }

  let rec _getElementFunc = (
    getElementFuncs: Meta3dEngineCoreProtocol.WorkManagerType.getElementFuncs,
    pipelineName,
    jobName,
  ): Meta3dEngineCoreProtocol.WorkManagerType.elementFunc => {
    getElementFuncs->Meta3dCommonlib.ListSt.length === 0
      ? Meta3dCommonlib.Exception.throwErr(
          Meta3dCommonlib.Exception.buildErr(
            Meta3dCommonlib.Log.buildFatalMessage(
              ~title="_getElementFunc",
              ~description=j`can't get elementFunc with pipelineName:${pipelineName}, jobName:${jobName}`,
              ~reason="",
              ~solution=j``,
              ~params=j``,
            ),
          ),
        )
      : {
          let list{headGetElementFunc, ...remainGetElementFuncs} = getElementFuncs

          let result = headGetElementFunc(pipelineName, jobName)

          result->Js.Nullable.isNullable
            ? _getElementFunc(remainGetElementFuncs, pipelineName, jobName)
            : result->Meta3dCommonlib.OptionSt.fromNullable->Meta3dCommonlib.OptionSt.getExn
        }
  }

  let _buildJobStreams = (
    mostService: Meta3dBsMostProtocol.ServiceType.service,
    (buildPipelineStreamFunc, getElementFuncs),
    (pipelineName, elements),
    groups,
  ) =>
    elements
    ->Meta3dCommonlib.ListSt.fromArray
    ->Meta3dCommonlib.ListSt.reduce(list{}, (streams, {name, type_}: element) =>
      switch type_ {
      | #job =>
        let elementFunc = _getElementFunc(getElementFuncs, pipelineName, name)

        streams->Meta3dCommonlib.ListSt.push(_buildJobStream(mostService, elementFunc))
      | #group =>
        let group = _findGroup(name, groups)
        let stream = buildPipelineStreamFunc(mostService, getElementFuncs, pipelineName, group, groups)
        streams->Meta3dCommonlib.ListSt.push(stream)
      }
    )

  let rec _buildPipelineStream = (
    mostService: Meta3dBsMostProtocol.ServiceType.service,
    getElementFuncs,
    pipelineName,
    {name, link, elements},
    groups,
  ) => {
    let streams = _buildJobStreams(
      mostService,
      (_buildPipelineStream, getElementFuncs),
      (pipelineName, elements),
      groups,
    )

    streams
    ->Meta3dCommonlib.ListSt.toArray
    ->switch link {
    | #merge => mostService.mergeArray
    | #concat => mostService.concatArray
    }
  }

  let parse = (
    state,
    mostService: Meta3dBsMostProtocol.ServiceType.service,
    getElementFuncs,
    {name, groups, first_group},
  ): Meta3dBsMostProtocol.StreamType.stream<Meta3dEngineCoreProtocol.StateType.state> => {
    let group = _findGroup(first_group, groups)

    state->StateContainer.setState

    _buildPipelineStream(mostService, getElementFuncs, name, group, groups)->mostService.map(
      () => StateContainer.unsafeGetState(),
      _,
    )
  }
}

let registerPlugin = (
  {allRegisteredWorkPluginContribute} as state: Meta3dEngineCoreProtocol.StateType.state,
  contribute: Meta3dEngineCoreProtocol.WorkManagerType.workPluginContribute,
  jobOrders: Meta3dEngineCoreProtocol.RegisterWorkPluginType.jobOrders,
): Meta3dEngineCoreProtocol.StateType.state => {
  {
    ...state,
    allRegisteredWorkPluginContribute: allRegisteredWorkPluginContribute->Meta3dCommonlib.ListSt.push((
      contribute,
      jobOrders,
    )),
  }
}

let unregisterPlugin = (
  {allRegisteredWorkPluginContribute} as state: Meta3dEngineCoreProtocol.StateType.state,
  targetPluginName: string,
): Meta3dEngineCoreProtocol.StateType.state => {
  ...state,
  allRegisteredWorkPluginContribute: allRegisteredWorkPluginContribute->Meta3dCommonlib.ListSt.filter(
    (({pluginName}, _)) => {
      pluginName !== targetPluginName
    },
  ),
}

let init = (
  {allRegisteredWorkPluginContribute} as state: Meta3dEngineCoreProtocol.StateType.state,
): Meta3dEngineCoreProtocol.StateType.state => {
  allRegisteredWorkPluginContribute->Meta3dCommonlib.ListSt.reduce(
    {
      ...state,
      states: allRegisteredWorkPluginContribute->Meta3dCommonlib.ListSt.reduce(
        Meta3dCommonlib.ImmutableHashMap.createEmpty(),
        (states, ({pluginName, initFunc, createStateFunc}, _)) => {
          states->Meta3dCommonlib.ImmutableHashMap.set(pluginName, createStateFunc())
        },
      ),
    },
    ({states} as state, ({pluginName, initFunc}, _)) => {
      state->StateContainer.setState

      initFunc(
        states
        ->Meta3dCommonlib.ImmutableHashMap.get(pluginName)
        ->Meta3dCommonlib.OptionSt.unsafeGet,
      )

      StateContainer.unsafeGetState()
    },
  )
}

module MergePipelineData = {
  let _findInsertPluginName = (
    insertElementName,
    allRegisteredWorkPluginContribute: Meta3dEngineCoreProtocol.WorkManagerType.allRegisteredWorkPluginContribute,
  ): Meta3dCommonlib.Result.t2<Meta3dEngineCoreProtocol.IWorkForJs.pluginName> => {
    allRegisteredWorkPluginContribute
    ->Meta3dCommonlib.ListSt.find((({pluginName, allPipelineData}, _)) => {
      let {groups} = allPipelineData[0]

      groups->Meta3dCommonlib.ArraySt.includesByFunc(({elements}) => {
        elements->Meta3dCommonlib.ArraySt.includesByFunc(({name}) => {
          name === insertElementName
        })
      })
    })
    ->Meta3dCommonlib.OptionSt.map((({pluginName}, _)) => pluginName)
    ->Meta3dCommonlib.OptionSt.get
  }

  let _check = (
    (
      {allPipelineData},
      jobOrders,
    ) as registeredWorkPluginContribute: Meta3dEngineCoreProtocol.StateType.registeredWorkPluginContribute,
  ) => {
    allPipelineData->Meta3dCommonlib.ArraySt.length <= 1 &&
      jobOrders->Meta3dCommonlib.ArraySt.length <= 1
      ? registeredWorkPluginContribute->Meta3dCommonlib.Result.succeed
      : Meta3dCommonlib.Result.failWith(
          Meta3dCommonlib.Log.buildErrorMessage(
            ~title="allPipelineData or jobOrders should has the same pipeline <= 1",
            ~description="",
            ~reason="",
            ~solution="",
            ~params="",
          ),
        )
  }

  let _findAllSpecificPipelineRelatedData = (
    allRegisteredWorkPluginContribute: Meta3dEngineCoreProtocol.WorkManagerType.allRegisteredWorkPluginContribute,
    targetPipelineName: Meta3dEngineCoreProtocol.PipelineType.pipelineName,
  ): Meta3dCommonlib.Result.t2<
    list<Meta3dEngineCoreProtocol.WorkManagerType.specificPipelineRelatedData>,
  > => {
    allRegisteredWorkPluginContribute
    ->Meta3dCommonlib.ListSt.traverseResultM(((
      {allPipelineData} as workPluginContribute,
      jobOrders,
    )) => {
      (
        {
          ...workPluginContribute,
          allPipelineData: allPipelineData->Meta3dCommonlib.ArraySt.filter(({name}) => {
            name === targetPipelineName
          }),
        },
        jobOrders->Meta3dCommonlib.ArraySt.filter(({pipelineName}) => {
          pipelineName === targetPipelineName
        }),
      )->_check
    })
    ->Meta3dCommonlib.Result.mapSuccess(allRegisteredWorkPluginContribute => {
      allRegisteredWorkPluginContribute->Meta3dCommonlib.ListSt.filter(((
        {allPipelineData} as registeredWorkPluginContribute,
        _,
      )) => {
        allPipelineData->Meta3dCommonlib.ArraySt.length === 1
      })
    })
    ->Meta3dCommonlib.Result.bind(allRegisteredWorkPluginContribute => {
      allRegisteredWorkPluginContribute
      ->Meta3dCommonlib.ListSt.map(((
        {pluginName, getElementFunc, allPipelineData} as registeredWorkPluginContribute,
        jobOrders,
      )) => {
        (pluginName, getElementFunc, allPipelineData[0], jobOrders->Meta3dCommonlib.ArraySt.getFirst)
      })
      ->Meta3dCommonlib.ListSt.traverseResultM(((
        pluginName,
        getElementFunc,
        pipelineData,
        jobOrderOpt,
      )) => {
        jobOrderOpt
        ->Meta3dCommonlib.OptionSt.map(({insertElementName, insertAction}) => {
          _findInsertPluginName(
            insertElementName,
            allRegisteredWorkPluginContribute,
          )->Meta3dCommonlib.Result.mapSuccess((
            insertPluginName
          ): Meta3dEngineCoreProtocol.WorkManagerType.jobOrder => {
            {
              insertPluginName: insertPluginName,
              insertElementName: insertElementName,
              insertAction: insertAction,
            }
          })
        })
        ->Meta3dCommonlib.OptionSt.sequenceResultM
        ->Meta3dCommonlib.Result.mapSuccess((
          jobOrderOpt
        ): Meta3dEngineCoreProtocol.WorkManagerType.specificPipelineRelatedData => {
          {
            pluginName: pluginName,
            getElementFunc: getElementFunc,
            pipelineData: pipelineData,
            jobOrder: jobOrderOpt,
          }
        })
      })
    })
  }

  let _handleInsertedAsRootNode = (
    treeDataList,
    (pluginName, getElementFunc, pipelineData, nodeJobOrderOpt, nodeInsertPluginNameOpt),
  ) => {
    treeDataList->Meta3dCommonlib.ListSt.reduce((list{}, None), (
      (newTreeDataList, insertedTreeOpt),
      (sameLevelTreeList, insertPluginNameOpt) as treeData,
    ) => {
      switch insertPluginNameOpt {
      | Some(insertPluginName) if insertPluginName === pluginName =>
        let insertedTree = TreeNode.buildNode(
          pluginName,
          (getElementFunc, pipelineData, nodeJobOrderOpt),
          sameLevelTreeList,
        )

        (
          newTreeDataList->Meta3dCommonlib.ListSt.addInReduce((
            list{insertedTree},
            nodeInsertPluginNameOpt,
          )),
          Some(insertedTree),
        )
      | _ => (newTreeDataList->Meta3dCommonlib.ListSt.addInReduce(treeData), insertedTreeOpt)
      }
    })
  }

  let _isInserted = Meta3dCommonlib.OptionSt.isSome

  let _add = (
    treeDataList: Meta3dEngineCoreProtocol.WorkManagerType.treeDataList,
    node,
    insertPluginNameOpt,
  ): Meta3dEngineCoreProtocol.WorkManagerType.treeDataList => {
    list{(list{node}, insertPluginNameOpt), ...treeDataList}
  }

  let _insertToAsChildNodeOrSameLevelTree = (
    treeDataList: Meta3dEngineCoreProtocol.WorkManagerType.treeDataList,
    nodeInsertPluginName,
    node: Meta3dEngineCoreProtocol.TreeType.tree,
  ): (Meta3dEngineCoreProtocol.WorkManagerType.treeDataList, bool) => {
    treeDataList->Meta3dCommonlib.ListSt.reduce((list{}, false), (
      (newTreeDataList, isInsertTo),
      (sameLevelTreeList, insertPluginNameOpt),
    ) => {
      switch insertPluginNameOpt {
      | Some(insertPluginName) if insertPluginName === nodeInsertPluginName => (
          newTreeDataList->Meta3dCommonlib.ListSt.addInReduce((
            sameLevelTreeList->Meta3dCommonlib.ListSt.push(node),
            insertPluginNameOpt,
          )),
          true,
        )
      | _ =>
        let (sameLevelTreeList, isInsertTo) = sameLevelTreeList->Meta3dCommonlib.ListSt.reduce(
          (list{}, false),
          ((sameLevelTreeList, isInsertTo), tree) => {
            let (tree, isInsertTo) = tree->OperateTree.insertNode(nodeInsertPluginName, node)

            (sameLevelTreeList->Meta3dCommonlib.ListSt.addInReduce(tree), isInsertTo)
          },
        )

        (
          newTreeDataList->Meta3dCommonlib.ListSt.addInReduce((
            sameLevelTreeList,
            insertPluginNameOpt,
          )),
          isInsertTo,
        )
      }
    })
  }

  let _removeInsertedTree = (
    treeDataList: Meta3dEngineCoreProtocol.WorkManagerType.treeDataList,
    insertedTree,
  ): Meta3dEngineCoreProtocol.WorkManagerType.treeDataList => {
    treeDataList
    ->Meta3dCommonlib.ListSt.map(((sameLevelTreeList, insertPluginNameOpt)) => {
      (
        sameLevelTreeList->Meta3dCommonlib.ListSt.filter(sameLevelTree =>
          !TreeNode.isEqual(sameLevelTree, insertedTree)
        ),
        insertPluginNameOpt,
      )
    })
    ->Meta3dCommonlib.ListSt.filter(((sameLevelTreeList, insertPluginNameOpt)) => {
      sameLevelTreeList->Meta3dCommonlib.ListSt.length > 0
    })
  }

  let _getTree = treeDataList => {
    treeDataList->Meta3dCommonlib.ListSt.length !== 1
      ? {
          Meta3dCommonlib.Result.failWith(
            Meta3dCommonlib.Log.buildErrorMessage(
              ~title="treeDataList.length should be 1",
              ~description="",
              ~reason={
                ""
              },
              ~solution="",
              ~params="",
            ),
          )
        }
      : {
          treeDataList
          ->Meta3dCommonlib.ListSt.head
          ->Meta3dCommonlib.OptionSt.get
          ->Meta3dCommonlib.Result.bind(((sameLevelTreeList, _)) => {
            sameLevelTreeList->Meta3dCommonlib.ListSt.length !== 1
              ? {
                  Meta3dCommonlib.Result.failWith(
                    Meta3dCommonlib.Log.buildErrorMessage(
                      ~title="sameLevelTreeList.length should be 1",
                      ~description="",
                      ~reason={
                        ""
                      },
                      ~solution="",
                      ~params="",
                    ),
                  )
                }
              : {
                  sameLevelTreeList->Meta3dCommonlib.ListSt.head->Meta3dCommonlib.OptionSt.get
                }
          })
        }
  }

  let _buildTree = (
    allSpecificPipelineRelatedData: list<
      Meta3dEngineCoreProtocol.WorkManagerType.specificPipelineRelatedData,
    >,
  ): Meta3dCommonlib.Result.t2<Meta3dEngineCoreProtocol.TreeType.tree> => {
    allSpecificPipelineRelatedData
    ->Meta3dCommonlib.ListSt.reduce(list{}, (
      treeDataList,
      {pluginName, getElementFunc, pipelineData, jobOrder},
    ) => {
      switch jobOrder {
      | None =>
        let (treeDataList, insertedTreeOpt) =
          treeDataList->_handleInsertedAsRootNode((
            pluginName,
            getElementFunc,
            pipelineData,
            None,
            None,
          ))

        _isInserted(insertedTreeOpt)
          ? treeDataList
          : treeDataList->_add(
              TreeNode.buildNode(pluginName, (getElementFunc, pipelineData, None), list{}),
              None,
            )
      | Some({insertPluginName, insertElementName, insertAction}) =>
        let nodeJobOrderOpt = (
          {
            insertElementName: insertElementName,
            insertAction: insertAction,
          }: Meta3dEngineCoreProtocol.TreeType.jobOrder
        )->Some

        let (treeDataList, insertedTreeOpt) =
          treeDataList->_handleInsertedAsRootNode((
            pluginName,
            getElementFunc,
            pipelineData,
            nodeJobOrderOpt,
            insertPluginName->Some,
          ))

        switch insertedTreeOpt {
        | Some(insertedTree) =>
          let (treeDataList, isInsertTo) =
            treeDataList->_insertToAsChildNodeOrSameLevelTree(insertPluginName, insertedTree)

          isInsertTo ? treeDataList->_removeInsertedTree(insertedTree) : treeDataList
        | None =>
          let node = TreeNode.buildNode(
            pluginName,
            (getElementFunc, pipelineData, nodeJobOrderOpt),
            list{},
          )

          let (treeDataList, isInsertTo) =
            treeDataList->_insertToAsChildNodeOrSameLevelTree(insertPluginName, node)

          isInsertTo ? treeDataList : treeDataList->_add(node, Some(insertPluginName))
        }
      }
    })
    ->_getTree
  }

  let _buildFirstGroupElement = (
    groups: Meta3dEngineCoreProtocol.PipelineType.groups,
    first_group,
  ): Meta3dCommonlib.Result.t2<Meta3dEngineCoreProtocol.PipelineType.element> => {
    groups
    ->Meta3dCommonlib.ArraySt.find(({name}) => {
      name === first_group
    })
    ->Meta3dCommonlib.OptionSt.map(({name}): Meta3dEngineCoreProtocol.PipelineType.element => {
      name: name,
      type_: #group,
    })
    ->Meta3dCommonlib.OptionSt.get
  }

  let _insertElement = (
    groups: Meta3dEngineCoreProtocol.PipelineType.groups,
    insertAction,
    insertElementName,
    insertElement: Meta3dEngineCoreProtocol.PipelineType.element,
  ) => {
    groups->Meta3dCommonlib.ArraySt.map(({name, elements} as group) => {
      {
        ...group,
        elements: elements->Meta3dCommonlib.ArraySt.reduceOneParam(
          (. result, {name} as element) => {
            name === insertElementName
              ? {
                  switch insertAction {
                  | Meta3dEngineCoreProtocol.RegisterWorkPluginType.Before =>
                    result
                    ->Meta3dCommonlib.ArraySt.push(insertElement)
                    ->Meta3dCommonlib.ArraySt.push(element)
                  | Meta3dEngineCoreProtocol.RegisterWorkPluginType.After =>
                    result
                    ->Meta3dCommonlib.ArraySt.push(element)
                    ->Meta3dCommonlib.ArraySt.push(insertElement)
                  }
                }
              : result->Meta3dCommonlib.ArraySt.push(element)
          },
          [],
        ),
      }
    })
  }

  let _mergeGroups = (
    groups: Meta3dEngineCoreProtocol.PipelineType.groups,
    insertGroups: Meta3dEngineCoreProtocol.PipelineType.groups,
  ): Meta3dEngineCoreProtocol.PipelineType.groups => {
    Js.Array.concat(groups, insertGroups)
  }

  let _mergeGetElementFuncs = (
    getElementFuncs: Meta3dEngineCoreProtocol.WorkManagerType.getElementFuncs,
    insertGetElementFuncs,
  ) => {
    Meta3dCommonlib.ListSt.concat(getElementFuncs, insertGetElementFuncs)
  }

  let _mergeToRootNode = (tree: Meta3dEngineCoreProtocol.TreeType.tree): Meta3dCommonlib.Result.t2<(
    list<
      Meta3dEngineCoreProtocol.IWorkForJs.getElementFunc<
        Meta3dEngineCoreProtocol.RegisterWorkPluginType.states,
      >,
    >,
    Meta3dEngineCoreProtocol.PipelineType.pipelineData,
  )> => {
    IterateTree.postOrderCataWithParentNode(
      ~tree,
      ~nodeFunc=(
        parentNodeOpt,
        pluginName,
        {getElementFuncs, pipelineData, jobOrder} as nodeData,
        children,
      ) => {
        let node = TreeNode.buildNodeByNodeData(pluginName, nodeData, children)

        switch parentNodeOpt {
        | None => node->Meta3dCommonlib.Result.succeed
        | Some(parentNode) =>
          let parentNodeData = TreeNode.getNodeData(parentNode)

          jobOrder
          ->Meta3dCommonlib.OptionSt.get
          ->Meta3dCommonlib.Result.bind(({insertElementName, insertAction}) => {
            _buildFirstGroupElement(
              pipelineData.groups,
              pipelineData.first_group,
            )->Meta3dCommonlib.Result.mapSuccess(insertElement => {
              parentNodeData.pipelineData = {
                ...parentNodeData.pipelineData,
                groups: parentNodeData.pipelineData.groups
                ->_insertElement(insertAction, insertElementName, insertElement)
                ->_mergeGroups(pipelineData.groups),
              }
              parentNodeData.getElementFuncs = _mergeGetElementFuncs(
                parentNodeData.getElementFuncs,
                getElementFuncs,
              )

              node
            })
          })
        }
      },
      (),
    )->Meta3dCommonlib.Result.mapSuccess(tree => {
      let {getElementFuncs, pipelineData} = TreeNode.getNodeData(tree)

      (getElementFuncs, pipelineData)
    })
  }

  let merge = (
    allRegisteredWorkPluginContribute: Meta3dEngineCoreProtocol.WorkManagerType.allRegisteredWorkPluginContribute,
    pipelineName: Meta3dEngineCoreProtocol.PipelineType.pipelineName,
  ): Meta3dCommonlib.Result.t2<(
    list<
      Meta3dEngineCoreProtocol.IWorkForJs.getElementFunc<
        Meta3dEngineCoreProtocol.RegisterWorkPluginType.states,
      >,
    >,
    Meta3dEngineCoreProtocol.PipelineType.pipelineData,
  )> => {
    allRegisteredWorkPluginContribute
    ->_findAllSpecificPipelineRelatedData(pipelineName)
    ->Meta3dCommonlib.Result.bind(_buildTree)
    ->Meta3dCommonlib.Result.bind(_mergeToRootNode)
  }
}

let runPipeline = (
  {allRegisteredWorkPluginContribute, states} as state: Meta3dEngineCoreProtocol.StateType.state,
  mostService: Meta3dBsMostProtocol.ServiceType.service,
  pipelineName: Meta3dEngineCoreProtocol.PipelineType.pipelineName,
): Meta3dCommonlib.Result.t2<
  Meta3dBsMostProtocol.StreamType.stream<Meta3dEngineCoreProtocol.StateType.state>,
> => {
  // TODO check is allRegisteredWorkPluginContribute duplicate

  allRegisteredWorkPluginContribute
  ->MergePipelineData.merge(pipelineName)
  ->Meta3dCommonlib.Result.mapSuccess(((getElementFuncs, pipelineData)) => {
    ParsePipelineData.parse(state, mostService, getElementFuncs, pipelineData)
  })
}
