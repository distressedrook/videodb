//
//  File.swift
//  
//
//  Created by Avismara Hugoppalu on 05/02/24.
//

import Foundation

struct UploadVideoRequestDTO: Encodable { 
    let url: String
}

struct UploadVideoResponseDTO: Decodable {
    let data: Job
    let requestType: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case data
        case requestType = "request_type"
        case status
    }
}
