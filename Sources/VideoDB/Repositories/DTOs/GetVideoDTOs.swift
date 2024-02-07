//
//  File.swift
//  
//
//  Created by Avismara Hugoppalu on 05/02/24.
//

import Foundation

struct GetVideoRequestDTO: Encodable { }

struct GetVideoResponseDTO: Decodable {
    let data: Video.Data
    let success: Bool
}
