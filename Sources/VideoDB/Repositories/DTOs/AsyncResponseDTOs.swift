//
//  File.swift
//  
//
//  Created by Avismara Hugoppalu on 05/02/24.
//

import Foundation

struct AsyncResponseRequestDTO: Encodable { }

struct AsyncResponseResponseDTO<T: Decodable>: Decodable {
    struct Data: Decodable {
        let data: T
        let success: Bool
    }
    let response: Data
    let status: String
}

