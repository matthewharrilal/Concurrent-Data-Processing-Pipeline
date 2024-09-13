//
//  DownloadOperation.swift
//  Concurrency-Data-Processing-Pipeline
//
//  Created by Space Wizard on 9/6/24.
//

import Foundation
import UIKit

class DownloadOperation: Operation {
    
    enum Constants {
        static let isExecuting: String = "isExecuting"
        static let isFinished: String = "isFinished"
    }
    
    private var _isExecuting: Bool = false
    private var _isFinished: Bool = false
    
    private let networkService: NetworkProtocol
    private let operationURL: URL
    private let _jobNumber: Int
    
    var jobNumber: Int {
        _jobNumber
    }
        
    var onFinished: (@Sendable (Int) -> Void)?
    
    override var isExecuting: Bool {
        _isExecuting
    }
    
    override var isFinished: Bool {
        _isFinished
    }
    
    init(
        operationURL: URL,
        networkService: NetworkProtocol,
        jobNumber: Int
    ) {
        self.operationURL = operationURL
        self.networkService = networkService
        self._jobNumber = jobNumber
        super.init()
    }
    
    override func start() {
        if isCancelled {
            finish()
            return
        }
        
        willChangeValue(forKey: Constants.isExecuting)
        _isExecuting = true
        didChangeValue(forKey: Constants.isExecuting)
        
        performDownloadTask()
    }
    
    private func performDownloadTask() {
        print("Downloading ... Beep Boop Beep")
        
        Task {
            let image = await networkService.downloadImage(for: operationURL)
            finish()
        }
    }
    
    
    private func finish() {
        willChangeValue(forKey: Constants.isFinished)
        _isFinished = true
        didChangeValue(forKey: Constants.isFinished)
        
        willChangeValue(forKey: Constants.isExecuting)
        _isExecuting = false
        didChangeValue(forKey: Constants.isExecuting)
        onFinished?(jobNumber)
    }
}
