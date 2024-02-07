//
//  File.swift
//  
//
//  Created by Avismara Hugoppalu on 06/02/24.
//

import Foundation

struct IndexSpokenWordsRequestDTO: Encodable {
    let indexType: Video.IndexType
    enum CodingKeys: String, CodingKey {
        case indexType = "index_type"
    }
}

struct IndexSpokenWordsResponseDTO: Decodable {
    let success: Bool
    let message: String?
}
