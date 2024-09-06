//
//  ConcurrentDownloadActor.swift
//  Concurrency-Data-Processing-Pipeline
//
//  Created by Space Wizard on 9/6/24.
//

import Foundation

actor ConcurrentDownloadActor {    
    
    private let customExecutor: ConcurrentDownloadExecutor
    
    private let maximumOperations: Int
    private var counter: Int = 0
    
    // Initialize with maximum operations to limit the amount of concurrent operations for this Actor
    init(maximumOperations: Int, customExecutor: ConcurrentDownloadExecutor) {
        self.maximumOperations = maximumOperations
        self.customExecutor = customExecutor
    }
    
    nonisolated var executor: some Executor {
        return ConcurrentDownloadExecutor()
    }
    
    func performDownload() async {
        counter += 1
        guard counter < maximumOperations else {
            print("Reached maximum amount of operations. Please try invoking job after one completes.")
            counter -= 1
            return
        }
        
        print("Downloading ... Beep Boop Beep")
//        customExecutor.enqueue(downloadJob)
    }
}
