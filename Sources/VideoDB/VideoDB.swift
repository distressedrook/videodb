import Alamofire

public struct Connection {
    let apiKey: String
    let videoRepository: VideoRepository
    let uploadRepository: UploadRepository
    let timelineRepository: TimelineRepository

    public init(apiKey: String) {
        self.apiKey = apiKey
        self.videoRepository = VideoRepositoryImp(apiKey: apiKey)
        self.uploadRepository = UploadRepositoryImp(apiKey: apiKey)
        self.timelineRepository = TimelineRepositoryImp(apiKey: apiKey)
    }

    public func getVideo(with id: String) async -> Result<Video, VideoDBError> {
        return await videoRepository.getVideo(with: id)
    }

    public func getVideos() async ->  Result<[Video], VideoDBError> {
        return await videoRepository.getAllVideos()
    }

    public func uploadVideo(with url: String) async -> Result<Video, VideoDBError> {
        return await uploadRepository.uploadVideo(with: url)
    }

    public func generateTimelineStream(with requestType: TimelineRequestType, timelines: [Timeline]) async -> Result<StreamLinks, VideoDBError> {
        return await timelineRepository.createTimeline(of: requestType, timelines: timelines)
    }

//
//    func getCollections() async -> [Collection] {
//        return []
//    }
//
//    func delete(video: Video) async -> Bool {
//        return true
//    }

}

struct Collection {
    var videos: [Video]

    func indexSpokenWords() async {
        for video in videos {
            
        }
    }
}

public enum TimelineRequestType: String, Encodable {
    case compile
}

public typealias StreamTimeline = (start: Int, end: Int)
