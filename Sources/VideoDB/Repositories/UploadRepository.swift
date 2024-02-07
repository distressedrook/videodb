//
//  File.swift
//  
//
//  Created by Avismara Hugoppalu on 30/01/24.
//

import Foundation

protocol UploadRepository {
    func uploadVideo(with url: String) async -> Result<Video, VideoDBError>
}

struct UploadRepositoryImp: UploadRepository {
    var apiKey: String
    var apiHeader: [String: String] {
        return ["x-access-token": apiKey]
    }
    var jobRepository: JobRepository
    var videoRepository: VideoRepository

    init(apiKey: String) {
        self.apiKey = apiKey
        self.jobRepository = JobRepositoryImp(apiKey: apiKey, serviceManager: ServiceManagerImp(internetConnectionManager: InternetConnectionManagerImp()))
        self.serviceManager = ServiceManagerImp(internetConnectionManager: InternetConnectionManagerImp())
        self.videoRepository = VideoRepositoryImp(apiKey: apiKey)
    }

    let url: String = "https://api.videodb.io/collection/default/"

    let serviceManager: ServiceManager

    func uploadVideo(with url: String) async -> Result<Video, VideoDBError> {
        let dto = UploadVideoRequestDTO(url: url)
        let response: Result<UploadVideoResponseDTO, VideoDBError> = await serviceManager.request(with: self.url + "upload", method: .post, encodingType: .body, parameters: dto, headers: apiHeader)
        switch response {
        case .success(let responseDto):
            return await getVideo(from: responseDto.data)
        case .failure(let error):
            return .failure(error)
        }
    }

    func getVideo(from job: Job) async -> Result<Video, VideoDBError> {
        let response: Result<Video.Data, VideoDBError> = await jobRepository.getAsyncResponseForJob(with: job.outputUrl)
        switch response {
        case .success(let videoData):
            let video = Video(data: videoData, apiKey: self.apiKey, videoRepository: self.videoRepository)
            return .success(video)
        case .failure:
            return await getVideo(from: job)
        }
    }
}
