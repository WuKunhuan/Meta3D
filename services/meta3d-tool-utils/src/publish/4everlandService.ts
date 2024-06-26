import { S3 } from "@aws-sdk/client-s3";
import { empty, fromPromise, just } from "most";
import * as BackendService from "meta3d-backend-4everland";

export let init = () => {
    const s3 = new S3({
        endpoint: "https://endpoint.4everland.co",
        signatureVersion: "v4",
        credentials: {
            accessKeyId: "P7SHR2MYU5CHLXKXCOG7",
            secretAccessKey: "5yhjyVdcpNNKjZ9X5sBe3738Lh9KftfDHQ6zkZKL",
            // sessionToken,
        },
        region: "us-west-2",
    } as any);

    return just(s3)
}

export let addDataToMarketProtocolCollection = BackendService.addDataToMarketProtocolCollection

export let hasAccount = BackendService.hasAccount

export let isContain = BackendService.isContain

export let getMarketProtocolCollection = BackendService.getMarketProtocolCollection

export let addMarketProtocolDataToDataFromMarketProtocolCollectionData = BackendService.addMarketProtocolDataToDataFromMarketProtocolCollectionData

export let getMarketImplementAccountData = BackendService.getMarketImplementAccountData

export let getDataFromMarketProtocolCollection = BackendService.getDataFromMarketProtocolCollection

export let getDataFromMarketImplementAccountData = BackendService.getDataFromMarketImplementAccountData

export let buildMarketImplementAccountData = BackendService.buildMarketImplementAccountData

export let addMarketImplementDataToDataFromMarketImplementCollectionData = BackendService.addMarketImplementDataToDataFromMarketImplementCollectionData

export let getFileID = BackendService.getFileID

export let updateMarketImplementData = BackendService.updateMarketImplementData

export let uploadFile = BackendService.uploadFile

export let parseMarketCollectionDataBodyForNodejs = BackendService.parseMarketCollectionDataBodyForNodejs