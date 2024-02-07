//
//  File.swift
//  
//
//  Created by Avismara Hugoppalu on 06/02/24.
//

import Foundation

public struct StreamLinks: Codable {
    let playerLink, playerURL: String
    let streamLink, streamURL: String

    enum CodingKeys: String, CodingKey {
        case playerLink = "player_link"
        case playerURL = "player_url"
        case streamLink = "stream_link"
        case streamURL = "stream_url"
    }
}
