import Alamofire


struct Connection {
    let apiKey: String
    let videoRepository: VideoRepository

    init(apiKey: String) {
        self.apiKey = apiKey
        self.videoRepository = VideoRepositoryImp(apiKey: apiKey, serviceManager: ServiceManagerImp(internetConnectionManager: InternetConnectionManagerImp()))
    }

    func getVideoInfo(with id: String) async -> Result<Video, VideoDBError> {
        return await videoRepository.getVideoInfo(with: id)
    }

//    func upload(url: String) async -> Video  {
//        return Video()
//    }
//
//    func getVideos() async -> [Video] {
//        return []
//    }
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
            await video.indexSpokenWords()
        }
    }
}
