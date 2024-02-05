//
//  File.swift
//  
//
//  Created by Avismara Hugoppalu on 05/02/24.
//

import Foundation

struct Video: Codable {
    let collectionId: String
    let id: String
    let length: String
    let name: String
    let playerLink: String
    let playerUrl: String
    let size: String
    let streamLink: String
    let streamUrl: String
    let userId: String

    func indexSpokenWords() {
        
    }

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
