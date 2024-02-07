//
//  File.swift
//  
//
//  Created by Avismara Hugoppalu on 05/02/24.
//

import Foundation

struct Job: Codable {
    let jobId: String
    let outputUrl: String

    enum CodingKeys: String, CodingKey {
        case jobId = "job_id"
        case outputUrl = "output_url"
    }
}
