//
//  File.swift
//  
//
//  Created by Avismara Hugoppalu on 05/02/24.
//

import Foundation

protocol JobRepository {
    var serviceManager: ServiceManager { get set }
    var apiKey: String { get set }
    func getAsyncResponseForJob<T: Decodable>(with callbackUrl: String) async -> Result<T, VideoDBError>
}

struct JobRepositoryImp: JobRepository {
    var apiKey: String
    var serviceManager: ServiceManager
    var apiHeader: [String: String] {
        return ["x-access-token": apiKey]
    }
    func getAsyncResponseForJob<T: Decodable>(with callbackUrl: String) async -> Result<T, VideoDBError> {
        let dto = AsyncResponseRequestDTO()
        let response: Result<AsyncResponseResponseDTO<T>, VideoDBError> =
         await serviceManager.request(with: callbackUrl, method: .get, encodingType: .parameter, parameters: dto, headers: apiHeader)
        switch response {
        case .success(let response):
            return .success(response.response.data)
        case .failure(let error):
            return .failure(error)
        }
    }
}

protocol TimelineRepository {
    var serviceManager: ServiceManager { get set }
    var apiKey: String { get set }
    func createTimeline(of type: TimelineRequestType, timelines: [Timeline]) async -> Result<StreamLinks, VideoDBError>
}

struct TimelineRepositoryImp: TimelineRepository {
    var apiKey: String
    var serviceManager: ServiceManager
    var apiHeader: [String: String] {
        return ["x-access-token": apiKey]
    }

    init(apiKey: String) {
        self.apiKey = apiKey
        self.serviceManager = ServiceManagerImp(internetConnectionManager: InternetConnectionManagerImp())
    }

    let url = "https://api.videodb.io/timeline"

    func createTimeline(of type: TimelineRequestType, timelines: [Timeline]) async -> Result<StreamLinks, VideoDBError> {
        let dto = TimelineRequestDTO(requestType: type, timelines: timelines)
        let response: Result<TimelineResponseDTO, VideoDBError> = await serviceManager.request(with: self.url, method: .post, encodingType: .body, parameters: dto, headers: self.apiHeader)
        switch response {
        case .success(let responseDto):
            if let streamlinks = responseDto.data {
                return .success(streamlinks)
            }
            if let message = responseDto.message {
                let error = VideoDBError(code: .server, message: message)
                return .failure(error)
            }
            let error = VideoDBError(code: .generic)
            return .failure(error)

        case .failure(let error):
            return .failure(error)
        }
    }
}
