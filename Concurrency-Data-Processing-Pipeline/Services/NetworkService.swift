//
//  NetworkService.swift
//  Concurrency-Data-Processing-Pipeline
//
//  Created by Space Wizard on 9/6/24.
//

import Foundation

protocol NetworkProtocol {
    func executeDownloadTask(priority: Operation.QueuePriority, jobNumber: Int) async
}

class NetworkService: NetworkProtocol {
    
    // MARK: Investigation -> Should these be abstracted to the NetworkProtocol?
    private let maxConcurrentDownloadOperations: Int
    private let maxConcurrentTransformationOperations: Int
    private let maxConcurrentSaveOperations: Int
    
    private var pendingDownloadOperations: [DownloadOperation] = []
    
    private var counter: Int = 0
    private let lock = NSLock()
    private lazy var counterQueue = DispatchQueue(label: "serial.counterQueue")
    
    private lazy var downloadOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = maxConcurrentDownloadOperations
        queue.name = "Download Operation Queue"
        return queue
    }()

    init(
        maxConcurrentDownloadOperations: Int = 1,
        maxConcurrentTransformationOperations: Int = 2,
        maxConcurrentSaveOperations: Int = 1
    ) {
        self.maxConcurrentDownloadOperations = maxConcurrentDownloadOperations
        self.maxConcurrentTransformationOperations = maxConcurrentTransformationOperations
        self.maxConcurrentSaveOperations = maxConcurrentSaveOperations
    }
    
    func executeDownloadTask(priority: Operation.QueuePriority, jobNumber: Int) async {
        counterQueue.sync {
            counter += 1
        }
        
        guard counter <= maxConcurrentDownloadOperations else {
            counterQueue.sync { [weak self] in
                guard let self = self else { return }
                self.counter -= 1
                
                print("")
                print("Reached max number of concurrent download operations. We will invoke this pending download task once an existing task completes.")
                
                self.pendingDownloadOperations.append(
                    DownloadOperation(
                        jobNumber: jobNumber, 
                        automaticallyStartDownloadTask: false
                    )
                )
                return
            }
            
            return
        }
        
        print("Starting download operation for job #\(jobNumber)")
        print("")
        let downloadOperation = DownloadOperation(jobNumber: jobNumber)
        downloadOperation.queuePriority = priority
        
        downloadOperation.onFinished = { [weak self] jobNumber in
            guard let self = self else { return }
            
            print("")
            print("Download operation complete for job #\(jobNumber)")

            counterQueue.sync {
                self.counter -= 1
            }
            
            handlePendingDownloadTasks()
        }
        
        downloadOperationQueue.addOperation(downloadOperation)
    }
    
    private func handlePendingDownloadTasks() {
        counterQueue.sync {
            guard pendingDownloadOperations.count > 0 else {
                print("")
                print("No pending download tasks to handle.")
                return
            }

            let pendingOperation = pendingDownloadOperations.removeFirst()
            
            print("")
            print("Re-trying previously pending task job #\(pendingOperation.jobNumber)")
            pendingOperation.startDownloadTask = true
            counter += 1
            
            pendingOperation.onFinished = { jobNumber in
                print("")
                print("Download operation complete for job #\(jobNumber)")
            }
        }
    }
}
