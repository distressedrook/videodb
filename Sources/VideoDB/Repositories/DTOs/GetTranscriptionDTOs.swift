//
//  File.swift
//  
//
//  Created by Avismara Hugoppalu on 06/02/24.
//

import Foundation

struct GetTranscriptionRequestDTO: Encodable { }

struct GetTranscriptionResponseDTO: Decodable {
    let data: Transcription
    let status: String
    let success: Bool
}
