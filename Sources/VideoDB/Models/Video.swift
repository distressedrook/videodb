//
//  File.swift
//  
//
//  Created by Avismara Hugoppalu on 05/02/24.
//

import Foundation
import Combine

public class Video: ObservableObject {
    struct Data: Codable {
        let collectionId: String
        let id: String
        let length: String
        let name: String
        let playerLink: String
        let playerUrl: String
        let size: String
        let streamLink: String
        let streamUrl: String
        let userId: String?
        enum CodingKeys: String, CodingKey {
            case collectionId = "collection_id"
            case id
            case length
            case name
            case playerLink = "player_link"
            case playerUrl = "player_url"
            case size
            case streamLink = "stream_link"
            case streamUrl = "stream_url"
            case userId = "user_id"
        }
    }

    public enum Workflow: String, Encodable {
        case addSubtitle = "add_subtitles"
    }
    public enum IndexType: String, Encodable {
        case semantic
    }

    private let data: Data
    private let videoRepository: VideoRepository

    public var collectionId: String { return data.collectionId }
    public var id: String { return data.id }
    public var length: String { return data.length }
    public var name: String { return data.name }
    public var playerLink: String { return data.playerLink }
    public var playerUrl: String { return data.playerUrl }
    public var size: String { return data.size }
    public var streamLink: String { return data.streamLink }
    public var streamUrl: String { return data.streamUrl }
    public var userId: String? { return data.userId }

    @Published public var transcriptionProgressPublisher: Double? = nil

    init(data: Data, apiKey: String, videoRepository: VideoRepository) {
        self.data = data
        self.videoRepository = videoRepository
    }

    public func index(of type: IndexType) async -> Result<Void, VideoDBError> {
        return await self.videoRepository.index(of: type, with: self.id)
    }

    public func transcribe() async -> Result<Transcription, VideoDBError> {
        let result = await self.videoRepository.getVideoTranscription(with: self.id)
        switch result {
        case .success(let transcription):
            if let percentage = transcription.percentage {
                if transcriptionProgressPublisher != percentage { transcriptionProgressPublisher = percentage }
                return await transcribe()
            } else {
                transcriptionProgressPublisher = nil
                return .success(transcription)
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    public func add(workflow: Workflow) async -> Result<StreamLinks, VideoDBError> {
        return await self.videoRepository.add(workflow: workflow, forVideoWith: self.id)
    }

    public func stream(length: Double, timeline: [StreamTimeline]) async -> Result<StreamLinks, VideoDBError> {
        return await self.videoRepository.streamVideo(of: self.id, length: length, timeline: timeline)
    }
}
