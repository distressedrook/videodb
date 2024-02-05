//
//  File.swift
//  
//
//  Created by Avismara Hugoppalu on 30/01/24.
//

import Foundation

protocol UploadRepository {
    func upload(videoURL: String)
    func upload(audioURL: String)

}
