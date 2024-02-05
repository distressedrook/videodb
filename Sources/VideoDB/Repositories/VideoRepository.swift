//
//  File.swift
//  
//
//  Created by Avismara Hugoppalu on 30/01/24.
//

import Foundation

protocol VideoRepository {

    var serviceManager: ServiceManager { get set }
    var apiKey: String { get set }

    func getVideoInfo(with id: String) async -> Result<Video, VideoDBError>
//    func listVideos() async -> Result<[Video], VideoDBError>
//    func deleteVideo(with id: String) async -> Result<Void, VideoDBError>
//    func streamVideo(with id: String, timeline: [Int], length: Double) async
//    func thumbnailUrlForVideo(with id: String) async -> Result<String, VideoDBError>
}

struct VideoRepositoryImp: VideoRepository {
    var apiKey: String
    var apiHeader: [String: String] {
        return ["x-access-token": apiKey]
    }
    var serviceManager: ServiceManager = ServiceManagerImp(internetConnectionManager: InternetConnectionManagerImp())

    let url: String = "https://api.videodb.io/video"

    func getVideoInfo(with id: String) async -> Result<Video, VideoDBError> {
        let dto = GetVideoInfoRequestDTO(id: id)
        return await serviceManager.request(with: url, method: .get, encodingType: .parameter, parameters: dto, headers: apiHeader)
    }
}
