//
//  LoggerService.swift
//  Concurrency-Data-Processing-Pipeline
//
//  Created by Space Wizard on 9/15/24.
//

import Foundation

class LoggerService {
    static func log(_ message: String) {
        let timestamp = Date()
        print("\(timestamp): \(message)")
    }
}
