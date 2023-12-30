import { historyData, targetVersion } from "./HistoryData"
import { isNullable } from "meta3d-commonlib-ts/src/NullableUtils"
import { fromPromise, mergeArray, Stream } from "most";

export let upgradeDatabaseOldData = (
    [initFunc, updateAllDatabaseDataFunc]: [any, any],
    targetVersion: targetVersion): Stream<void> => {
    return initFunc().flatMap(backendInstance => {
        let data = historyData[targetVersion]

        if (isNullable(data)) {
            throw new Error(`targetVersion: ${targetVersion} not exist in historyData`)
        }

        return mergeArray(
            data.map(data => {
                return updateAllDatabaseDataFunc(data.mapFunc,
                    backendInstance,
                    data.collectionName)
            })
        )
    })
}