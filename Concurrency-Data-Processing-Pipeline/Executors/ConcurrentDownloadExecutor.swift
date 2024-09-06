//
//  ConcurrentDownloadExecutor.swift
//  Concurrency-Data-Processing-Pipeline
//
//  Created by Space Wizard on 9/6/24.
//

import Foundation

final class ConcurrentDownloadExecutor: Executor {
    
    private let queue = DispatchQueue(label: "concurrent.downloadQueue", attributes: .concurrent)
    
    func enqueue(_ job: consuming ExecutorJob) {
        queue.async { [weak self] in
            guard let self = self else { return }
            self.executeJob()
        }
    }
    
    private func executeJob() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) { // 1 second delay
            print("Executing Job")
        }
    }
}
