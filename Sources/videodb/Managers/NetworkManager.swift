import Alamofire
import Foundation

protocol ServiceManager {
    func request<Request: Encodable, Response: Decodable>(with url: String, method: RequestType, encodingType: RequestEncodingType, parameters: Request?, headers: [String: String]?) async -> Result<Response, VideoDBError>
}

class ServiceManagerImp: ServiceManager {
    let internetConnectionManager: InternetConnectionManager
    
    init(internetConnectionManager: InternetConnectionManager) {
        self.internetConnectionManager = internetConnectionManager
    }

    func request<Request, Response>(with url: String, method: RequestType, encodingType: RequestEncodingType, parameters: Request?, headers: [String : String]?) async -> Result<Response, VideoDBError> where Request : Encodable, Response : Decodable {
        if !internetConnectionManager.isConnectedToNetwork() { return Result.failure(VideoDBError(code: .noNetwork)) }
        var header = HTTPHeaders()
        for (key, value) in headers ?? [:] {
            header.add(name: key, value: value)
        }
        let encoder: ParameterEncoder
        if encodingType == .body {
            encoder = JSONParameterEncoder.default
        } else {
            encoder = URLEncodedFormParameterEncoder.default
        }
        let result = await AF.request(url, method: method.toMethod(), parameters: parameters, encoder: encoder, headers: header)
            .serializingDecodable(Response.self)
            .response
            .result

        switch result {
        case .success(let value):
            return Result.success(value)
        case .failure(let error):
            let vdbError = VideoDBError(code: .system, underlyingError: error)
            return Result.failure(vdbError)
        }
    }
}

enum RequestType {
    case get, put, post, delete, connect, options, patch, query
    func toMethod() -> HTTPMethod {
        switch self {
        case .get:
            return .get
        case .put:
            return .put
        case .post:
            return .post
        case .delete:
            return .delete
        case .connect:
            return  .connect
        case .options:
            return .options
        case .patch:
            return  .patch
        case .query:
            return .query
        }
    }
}

enum RequestEncodingType {
    case parameter, body
}
