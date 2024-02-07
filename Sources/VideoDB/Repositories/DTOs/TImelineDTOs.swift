//
//  File.swift
//  
//
//  Created by Avismara Hugoppalu on 06/02/24.
//

import Foundation

struct TimelineRequestDTO: Encodable {
    enum CodingKeys: String, CodingKey {
        case requestType = "request_type"
    }
    let requestType: TimelineRequestType
    let timelines: [Timeline]
}

struct TimelineResponseDTO: Decodable {
    let data: StreamLinks?
    let message: String?
    let success: Bool
}
