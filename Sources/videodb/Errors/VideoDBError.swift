//
//  File.swift
//  
//
//  Created by Avismara Hugoppalu on 18/01/24.
//

import Foundation

public struct VideoDBError: Error {
    let code: VideoDBErrorCode
    let message: String?
    let underlyingError: Error?

    init(code: VideoDBErrorCode) {
        self.code = code
        self.underlyingError = nil
        self.message = nil
    }

    init(code: VideoDBErrorCode, underlyingError: Error) {
        self.code = code
        self.underlyingError = underlyingError
        self.message = nil
    }

    init(code: VideoDBErrorCode, message: String) {
        self.code = code
        self.underlyingError = nil
        self.message = message
    }

}
