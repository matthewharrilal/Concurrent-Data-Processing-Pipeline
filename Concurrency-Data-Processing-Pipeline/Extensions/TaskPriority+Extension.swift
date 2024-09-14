//
//  TaskPriority+Extension.swift
//  Concurrency-Data-Processing-Pipeline
//
//  Created by Space Wizard on 9/14/24.
//

import Foundation

extension TaskPriority {
    func toOperationQueuePriority() -> Operation.QueuePriority {
        switch self {
        case .userInitiated:
            return .veryHigh
        case .medium:
            return .normal
        case .background:
            return .veryLow
        default:
            return .low
        }
    }
}
