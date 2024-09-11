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
    private lazy var counterQueue = DispatchQueue(label: "serial.counterQueue")
    
    private lazy var downloadOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = maxConcurrentDownloadOperations
        queue.name = "Download Operation Queue"
        return queue
    }()

    init(
        maxConcurrentDownloadOperations: Int = 2,
        maxConcurrentTransformationOperations: Int = 2,
        maxConcurrentSaveOperations: Int = 1
    ) {
        self.maxConcurrentDownloadOperations = maxConcurrentDownloadOperations
        self.maxConcurrentTransformationOperations = maxConcurrentTransformationOperations
        self.maxConcurrentSaveOperations = maxConcurrentSaveOperations
    }
    
    func startDownloadTask(_ operation: DownloadOperation) {
        guard !operation.isFinished, !operation.isExecuting else {
            print("Operation for job #\(operation.jobNumber) is already finished or executing. Skipping...")
            return
        }
        
        print("Starting download task for job #\(operation.jobNumber)")
        downloadOperationQueue.addOperation(operation)
        
        operation.onFinished = { [weak self] jobNumber in
            guard let self = self else {
                print("Self has been deallocated")
                return
            }
            
            
            print("Download operation complete for job #\(jobNumber)")
            print("")
            
            self.counterQueue.sync {
                self.counter -= 1 // Decrement counter of current operation since operation has been completed
            }
            
            self.handlePendingDownloadTasks()
        }
    }
    
    func executeDownloadTask(priority: Operation.QueuePriority, jobNumber: Int) async {
        counterQueue.sync { [weak self] in
            guard let self = self else { return }
            self.counter += 1
            
            guard self.counter <= maxConcurrentDownloadOperations else {
                self.counter -= 1
                
                print("")
                print("Couldn't immedieately execute Job #\(jobNumber), will execute it after a task completes")
                print("")
                                
                let pendingOperation = DownloadOperation(jobNumber: jobNumber)

                pendingOperation.queuePriority = priority

                self.pendingDownloadOperations.append(
                    pendingOperation
                )
                
                return
            }
            
            let downloadOperation = DownloadOperation(jobNumber: jobNumber)
            downloadOperation.queuePriority = priority
            startDownloadTask(downloadOperation)
        }
    }
    
    /*
     Nuanced Note:
        - The reason we don't remove the pendingOperation from the array and then execute it is b/c pendingDownloadOperations is the only object bridiging and retaining the pendingOperations inside of it to self. If removed, we would lose access to self and the onFinished completion handler would not be invoked here as it would't know where to send the results upon invocation i.e here.
     */
    private func handlePendingDownloadTasks() {
        var nextPendingOperation: DownloadOperation?
        
        counterQueue.sync {
            guard
                pendingDownloadOperations.count > 0,
                let pendingOperation = pendingDownloadOperations.first
            else {
                print("")
                print("No pending download tasks to handle.")
                return
            }
            
            print("")
            print("Re-trying previously pending task job #\(pendingOperation.jobNumber)")
            print("")
            
            // Need to access the first operation in pending operations before we remove so that we don't lose reference to self when invoking onFinished
            nextPendingOperation = pendingOperation
            pendingDownloadOperations.removeFirst()
            
            counter += 1
        }
        
        if let nextPendingOperation = nextPendingOperation {
            startDownloadTask(nextPendingOperation)
        }
    }
}
