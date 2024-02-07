//
//  File.swift
//  
//
//  Created by Avismara Hugoppalu on 30/01/24.
//

import Foundation

protocol VideoRepository {

    var serviceManager: ServiceManager { get set }
    var jobRepository: JobRepository { get set }
    var apiKey: String { get set }

    func getVideo(with id: String) async -> Result<Video, VideoDBError>
    func getAllVideos() async -> Result<[Video], VideoDBError>
    func getVideoTranscription(with id: String) async -> Result<Transcription, VideoDBError>
    func add(workflow: Video.Workflow, forVideoWith id: String) async -> Result<StreamLinks, VideoDBError>
    func index(of type: Video.IndexType, with id: String) async -> Result<Void, VideoDBError>
    func streamVideo(of id: String, length: Double, timeline: [StreamTimeline]) async -> Result<StreamLinks, VideoDBError>
//    func deleteVideo(with id: String) async -> Result<Void, VideoDBError>
//    func streamVideo(with id: String, timeline: [Int], length: Double) async
//    func thumbnailUrlForVideo(with id: String) async -> Result<String, VideoDBError>
}

struct VideoRepositoryImp: VideoRepository {
    var apiKey: String
    var apiHeader: [String: String] {
        return ["x-access-token": apiKey]
    }
    var jobRepository: JobRepository
    
    init(apiKey: String) {
        self.apiKey = apiKey
        self.jobRepository = JobRepositoryImp(apiKey: apiKey, serviceManager: ServiceManagerImp(internetConnectionManager: InternetConnectionManagerImp()))
    }

    var serviceManager: ServiceManager = ServiceManagerImp(internetConnectionManager: InternetConnectionManagerImp())

    let url: String = "https://api.videodb.io/video"

    func getVideo(with id: String) async -> Result<Video, VideoDBError> {
        let dto = GetVideoRequestDTO()
        let result: Result<GetVideoResponseDTO, VideoDBError> = await serviceManager.request(with: url + "/\(id)", method: .get, encodingType: .parameter, parameters: dto, headers: apiHeader)
        switch result {
        case .success(let success):
            let video = Video(data: success.data, apiKey: self.apiKey, videoRepository: self)
            return Result.success(video)
        case .failure(let failure):
            return Result.failure(failure)
        }
    }

    func getAllVideos() async -> Result<[Video], VideoDBError> {
        let dto = GetAllVideosRequestDTO()
        let result: Result<GetAllVideosResponseDTO, VideoDBError> = await serviceManager.request(with: url, method: .get, encodingType: .parameter, parameters: dto, headers: apiHeader)
        switch result {
        case .success(let success):
            var videos = [Video]()
            for videoData in success.data.videos {
                videos.append(Video(data: videoData, apiKey: self.apiKey, videoRepository: self))
            }
            return Result.success(videos)
        case .failure(let failure):
            return Result.failure(failure)
        }
    }

    func getVideoTranscription(with id: String) async -> Result<Transcription, VideoDBError> {
        let dto = GetTranscriptionRequestDTO()
        let result: Result<GetTranscriptionResponseDTO, VideoDBError> = await serviceManager.request(with: self.url + "/\(id)/transcription", method: .get, encodingType: .parameter, parameters: dto, headers: apiHeader)
        switch result {
        case .success(let success):
            return .success(success.data)
        case .failure(let error):
            return .failure(error)
        }
    }

    func add(workflow: Video.Workflow, forVideoWith id: String) async -> Result<StreamLinks, VideoDBError> {
        let dto = AddWorkflowRequestDTO(type: workflow)
        let result: Result<AddWorkflowResponseDTO, VideoDBError> = await serviceManager.request(with: self.url + "/\(id)/workflow", method: .post, encodingType: .body, parameters: dto, headers: apiHeader)
        switch result {
        case .success(let responseDto):
            if let data = responseDto.data {
                return .success(data)
            }
            if let message = responseDto.message, responseDto.success == false {
                return .failure(VideoDBError(code: .server, message: message))
            }
            return .failure(VideoDBError(code: .generic))
        case .failure(let error):
            return .failure(error)
        }
    }

    func index(of type: Video.IndexType, with id: String) async -> Result<Void, VideoDBError> {
        let dto = IndexSpokenWordsRequestDTO(indexType: type)
        let result: Result<IndexSpokenWordsResponseDTO, VideoDBError> = await serviceManager.request(with: self.url + "/\(id)/index", method: .post, encodingType: .body, parameters: dto, headers: apiHeader)
        switch result {
        case .success(let responseDto):
            if let message = responseDto.message, responseDto.success == false { return .failure(VideoDBError(code: .server, message: message)) }
            if responseDto.success == false { return .failure(VideoDBError(code: .generic)) }
            return .success(Void())
        case .failure(let error):
            return .failure(error)

        }
    }

    func streamVideo(of id: String, length: Double, timeline: [StreamTimeline]) async -> Result<StreamLinks, VideoDBError> {
        let timeline = timeline.map { start, end in
            return [start, end]
        }
        let dto = StreamWithTimelineRequestDTO(length: length, timeline: timeline)
        let result: Result<StreamWithTimelineResponseDTO, VideoDBError> = await serviceManager.request(with: self.url + "/\(id)/stream", method: .post, encodingType: .body, parameters: dto, headers: self.apiHeader)
        switch result {
        case .success(let responseDto):
            if let streamlinks = responseDto.streamlinks { return .success(streamlinks) }
            if let message = responseDto.message, responseDto.success == false { return .failure(VideoDBError(code: .server, message: message)) }
            return .failure(VideoDBError(code: .generic))
        case .failure(let error):
            return .failure(error)
        }
    }
}
