import { fromPromise } from "most";
import { isPublisherRegistered } from "meta3d-tool-utils/src/publish/PublishUtils"

function _throwError(msg: string): never {
    throw new Error(msg)
}

function _getPublishedCollectionName(fileType: "extension" | "contribute") {
    switch (fileType) {
        case "extension":
            return "publishedextensionprotocols"
        case "contribute":
            return "publishedcontributeprotocols"
    }
}

function _isPNG(iconPath: string) {
    return iconPath.match(/\.png$/) !== null
}

export function publish([readFileSyncFunc, logFunc, errorFunc, readJsonFunc, initFunc, hasAccountFunc, getCollectionFunc, isContainFunc, addDataFunc, addDataToBodyFunc]: [any, any, any, any, any, any, any, any, any, any], packageFilePath: string, iconPath: string, fileType: "extension" | "contribute") {
    return readJsonFunc(packageFilePath).flatMap(packageJson => {
        return initFunc().map(backendInstance => [backendInstance, packageJson])
    }).flatMap(([backendInstance, packageJson]) => {
        let account = packageJson.publisher

        return isPublisherRegistered(hasAccountFunc, backendInstance, account).flatMap(isPublisherRegistered => {
            if (!isPublisherRegistered) {
                _throwError("找不到publishser，请至少登录过一次")
            }

            if (!_isPNG(iconPath)) {
                _throwError("icon's format should be png")
            }

            return fromPromise(
                getCollectionFunc(
                    backendInstance,
                    _getPublishedCollectionName(fileType),
                ).then(res => {
                    return isContainFunc(
                        ({ name, version }) => {
                            return name === packageJson.name && version === packageJson.version
                        },
                        res).then(isContain => [isContain, res])
                }).then(([isContain, res]) => {
                    if (isContain) {
                        _throwError("version: " + packageJson.version + " already exist, please update version")
                    }

                    return addDataFunc(backendInstance,
                        addDataToBodyFunc,
                        _getPublishedCollectionName(fileType),
                        _getPublishedCollectionName(fileType),
                        res,
                        {
                            name: packageJson.name,
                            version: packageJson.version,
                            account: account,
                            iconBase64:
                                // TODO check file size should be small(< 10kb)

                                // TODO icon can be any format include png

                                "data:image/png;base64, " + readFileSyncFunc(iconPath, "base64")
                        }
                    )
                }))
        })
    }).drain()
        .then(_ => {
            logFunc("publish success")
        })
        .catch(e => {
            errorFunc("error message: ", e)
        })
}

function _getPublishedConfigCollectionName(fileType: "extension" | "contribute") {
    switch (fileType) {
        case "extension":
            return "publishedextensionprotocolconfigs"
        case "contribute":
            return "publishedcontributeprotocolconfigs"
    }
}

export function publishConfig([readFileSyncFunc, logFunc, errorFunc, readJsonFunc, initFunc, hasAccountFunc, getCollectionFunc, isContainFunc, addDataFunc, addDataToBodyFunc]: [any, any, any, any, any, any, any, any, any, any], packageFilePath: string, distFilePath: string, fileType: "extension" | "contribute") {
    return readJsonFunc(packageFilePath).flatMap(packageJson => {
        return initFunc().map(backendInstance => [backendInstance, packageJson])
    }).flatMap(([backendInstance, packageJson]) => {
        let account = packageJson.publisher

        return isPublisherRegistered(hasAccountFunc, backendInstance, account).flatMap(isPublisherRegistered => {
            if (!isPublisherRegistered) {
                _throwError("找不到publishser，请至少登录过一次")
            }

            let collectioName = _getPublishedConfigCollectionName(fileType)

            return fromPromise(
                getCollectionFunc(
                    backendInstance,
                    collectioName
                ).then(res => {
                    return isContainFunc(
                        ({ name, version }) => {
                            return name === packageJson.name && version === packageJson.version
                        },
                        res).then(isContain => [isContain, res])
                }).then(([isContain, res]) => {
                    if (isContain) {
                        _throwError("version: " + packageJson.version + " already exist, please update version")
                    }

                    return addDataFunc(backendInstance,
                        addDataToBodyFunc,
                        collectioName,
                        collectioName,
                        res,
                        {
                            name: packageJson.name,
                            version: packageJson.version,
                            account: packageJson.publisher,
                            configStr:
                                // TODO check file size should be small(< 10kb)

                                readFileSyncFunc(distFilePath, "utf8")
                        }
                    )
                }))
        })
    }).drain()
        .then(_ => {
            logFunc("publish config success")
        })
        .catch(e => {
            errorFunc("error message: ", e)
        })
}