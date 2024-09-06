//
//  ConcurrentDownloadExecutor.swift
//  Concurrency-Data-Processing-Pipeline
//
//  Created by Space Wizard on 9/6/24.
//

import Foundation

final class ConcurrentDownloadExecutor: Executor {

    private let queue = DispatchQueue(label: "concurrent.downloadQueue", attributes: .concurrent)
    
    private var lock: NSLock = NSLock()
    
    private var onCompletion: (() -> Void)?
    
    func enqueue(_ job: UnownedJob) {
        queue.async { [weak self] in
            guard let self = self else { return }
            self.executeJob()
        }
    }
    
    public func executeJob() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) { [weak self] in // 1 second delay
            guard let self = self else { return }
            print("Executing Job")
            
            // MARK: Might be contradicting the nature of the concurrent queue but might be okay since just on one portion
            self.lock.lock()
            onCompletion?()
            self.lock.unlock()
        }
    }
}
