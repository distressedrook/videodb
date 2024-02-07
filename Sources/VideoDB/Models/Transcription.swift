//
//  File.swift
//  
//
//  Created by Avismara Hugoppalu on 06/02/24.
//

import Foundation

import Foundation

public struct Transcription: Codable {
    struct WordTimestamp: Codable {
        let end: String
        let start: String
        let text: String
    }
    let text: String?
    let wordTimestamps: [WordTimestamp]?
    let percentage: Double?
    private enum CodingKeys: String, CodingKey {
        case text
        case wordTimestamps = "word_timestamps"
        case percentage
    }
}


