//
//  File.swift
//  
//
//  Created by Avismara Hugoppalu on 05/02/24.
//

import Foundation

struct GetAllVideosRequestDTO: Encodable { }

struct GetAllVideosResponseDTO: Decodable {
    struct Data: Decodable {
        let videos: [Video.Data]
    }
    let data: Data
    let success: Bool
}
