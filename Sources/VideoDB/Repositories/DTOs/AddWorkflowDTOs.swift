//
//  File.swift
//  
//
//  Created by Avismara Hugoppalu on 06/02/24.
//

import Foundation


struct AddWorkflowRequestDTO: Encodable {
    let type: Video.Workflow
}

struct AddWorkflowResponseDTO: Decodable {
    let data: StreamLinks?
    let message: String?
    let success: Bool
}
