//
//  DownloadOperation.swift
//  Concurrency-Data-Processing-Pipeline
//
//  Created by Space Wizard on 9/6/24.
//

import Foundation

class DownloadOperation: Operation {
    
    private var _isExecuting: Bool = false
    private var _isFinished: Bool = false
    
    private let _jobNumber: Int
    
    var jobNumber: Int {
        _jobNumber
    }
    
    var startDownloadTask: Bool {
        didSet {
            if startDownloadTask {
                performDownloadTask()
            }
        }
    }
    
    var onFinished: (@Sendable (Int) -> Void)?
    
    override var isExecuting: Bool {
        _isExecuting
    }
    
    override var isFinished: Bool {
        _isFinished
    }
    
    init(jobNumber: Int, automaticallyStartDownloadTask: Bool = true) {
        self._jobNumber = jobNumber
        self.startDownloadTask = automaticallyStartDownloadTask
        super.init()
    }
    
    override func start() {
        if isCancelled {
            finish()
            return
        }
        
        _isExecuting = true
        
        if startDownloadTask {
            performDownloadTask()
        }
    }
    
    private func performDownloadTask() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else {
                print("Self has been deallocated")
                return
            }
            print("Downloading ... Beep Boop Beep")
            self.finish()
        }
    }
    
    private func finish() {
        _isFinished = true
        onFinished?(jobNumber)
    }
}
