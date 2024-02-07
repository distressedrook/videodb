//
//  File.swift
//  
//
//  Created by Avismara Hugoppalu on 07/02/24.
//

import Foundation

struct StreamWithTimelineRequestDTO: Encodable {
    let length: Double
    let timeline: [[Int]]
}

struct StreamWithTimelineResponseDTO: Decodable {
    let streamlinks: StreamLinks?
    let message: String?
    let success: Bool
}
