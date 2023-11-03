"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.publishConfig = exports.publish = void 0;
const most_1 = require("most");
const PublishUtils_1 = require("meta3d-tool-utils/src/publish/PublishUtils");
let _throwError = (msg) => {
    throw new Error(msg);
};
let _getPublishedCollectionName = (fileType) => {
    switch (fileType) {
        case "extension":
            return "publishedextensionprotocols";
        case "contribute":
            return "publishedcontributeprotocols";
    }
};
let _isPNG = (iconPath) => {
    return iconPath.match(/\.png$/) !== null;
};
let _isEmpty = (value) => {
    return value === undefined || value === null;
};
let publish = ([readFileSyncFunc, logFunc, errorFunc, readJsonFunc, initFunc, hasAccountFunc, getMarketProtocolCollectionFunc, addDataToMarketProtocolCollectionFunc, addMarketProtocolDataToDataFromMarketProtocolCollectionDataFunc, getDataFromMarketProtocolCollectionFunc, parseMarketCollectionDataBodyFunc], packageFilePath, iconPath, fileType) => {
    return readJsonFunc(packageFilePath).flatMap(packageJson => {
        return initFunc().map(backendInstance => [backendInstance, packageJson]);
    }).flatMap(([backendInstance, packageJson]) => {
        let account = packageJson.publisher;
        return (0, PublishUtils_1.isPublisherRegistered)(hasAccountFunc, backendInstance, account).flatMap(isPublisherRegistered => {
            if (!isPublisherRegistered) {
                _throwError("找不到publishser，请在平台上注册该用户");
            }
            if (!_isPNG(iconPath)) {
                _throwError("icon's format should be png");
            }
            return (0, most_1.fromPromise)(getMarketProtocolCollectionFunc(backendInstance, parseMarketCollectionDataBodyFunc, _getPublishedCollectionName(fileType), (0, PublishUtils_1.getLimitCount)(), 0, {
                name: packageJson.name,
                version: packageJson.version
            }).then(res => {
                let resData = getDataFromMarketProtocolCollectionFunc(res);
                if (resData.length > 0) {
                    _throwError("version: " + packageJson.version + " already exist, please update version");
                }
                return addDataToMarketProtocolCollectionFunc(backendInstance, addMarketProtocolDataToDataFromMarketProtocolCollectionDataFunc, _getPublishedCollectionName(fileType), _getPublishedCollectionName(fileType), resData, {
                    name: packageJson.name,
                    version: packageJson.version,
                    account: account,
                    iconBase64: 
                    // TODO check file size should be small(< 10kb)
                    // TODO icon can be any format include png
                    "data:image/png;base64, " + readFileSyncFunc(iconPath, "base64"),
                    displayName: _isEmpty(packageJson.displayName) ? packageJson.name : packageJson.displayName,
                    repoLink: _isEmpty(packageJson.repoLink) ? "" : packageJson.repoLink,
                    description: _isEmpty(packageJson.description) ? "" : packageJson.description,
                });
            }));
        });
    }).drain()
        .then(_ => {
        logFunc("publish success");
    })
        .catch(e => {
        errorFunc("error message: ", e);
    });
};
exports.publish = publish;
let _getPublishedConfigCollectionName = (fileType) => {
    switch (fileType) {
        case "extension":
            return "publishedextensionprotocolconfigs";
        case "contribute":
            return "publishedcontributeprotocolconfigs";
    }
};
let publishConfig = ([readFileSyncFunc, logFunc, errorFunc, readJsonFunc, initFunc, hasAccountFunc, getMarketProtocolCollectionFunc, addDataToMarketProtocolCollectionFunc, addMarketProtocolDataToDataFromMarketProtocolCollectionDataFunc, getDataFromMarketProtocolCollectionFunc, parseMarketCollectionDataBodyFunc], packageFilePath, distFilePath, fileType) => {
    return readJsonFunc(packageFilePath).flatMap(packageJson => {
        return initFunc().map(backendInstance => [backendInstance, packageJson]);
    }).flatMap(([backendInstance, packageJson]) => {
        let account = packageJson.publisher;
        return (0, PublishUtils_1.isPublisherRegistered)(hasAccountFunc, backendInstance, account).flatMap(isPublisherRegistered => {
            if (!isPublisherRegistered) {
                _throwError("找不到publishser，请在平台上注册该用户");
            }
            let collectioName = _getPublishedConfigCollectionName(fileType);
            return (0, most_1.fromPromise)(getMarketProtocolCollectionFunc(backendInstance, parseMarketCollectionDataBodyFunc, collectioName, (0, PublishUtils_1.getLimitCount)(), 0, {
                name: packageJson.name,
                version: packageJson.version
            }).then(res => {
                let resData = getDataFromMarketProtocolCollectionFunc(res);
                if (resData.length > 0) {
                    _throwError("version: " + packageJson.version + " already exist, please update version");
                }
                return addDataToMarketProtocolCollectionFunc(backendInstance, addMarketProtocolDataToDataFromMarketProtocolCollectionDataFunc, collectioName, collectioName, resData, {
                    name: packageJson.name,
                    version: packageJson.version,
                    account: packageJson.publisher,
                    configStr: 
                    // TODO check file size should be small(< 10kb)
                    readFileSyncFunc(distFilePath, "utf8")
                });
            }));
        });
    }).drain()
        .then(_ => {
        logFunc("publish config success");
    })
        .catch(e => {
        errorFunc("error message: ", e);
    });
};
exports.publishConfig = publishConfig;
//# sourceMappingURL=Publish.js.map