//
//  File.swift
//  
//
//  Created by Avismara Hugoppalu on 06/02/24.
//

import Foundation

public struct Timeline: Codable {
    let assetId: String
    let overlayStart: Int?
    let start: Int
    let end: Int
    let disableOtherTracks: Bool?
    let fadeInDuration: Int?
    let fadeOutDuration: Int?

    enum CodingKeys: String, CodingKey {
        case assetId = "asset_id"
        case overlayStart = "overlay_start"
        case start, end
        case disableOtherTracks = "disable_other_tracks"
        case fadeInDuration = "fade_in_duration"
        case fadeOutDuration = "fade_out_duration"
    }
}
