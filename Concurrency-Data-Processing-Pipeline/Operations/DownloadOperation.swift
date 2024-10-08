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
    private let continuation: CheckedContinuation<UIImage, Error>
    
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
        jobNumber: Int,
        continuation: CheckedContinuation<UIImage, Error>
    ) {
        self.operationURL = operationURL
        self.networkService = networkService
        self._jobNumber = jobNumber
        self.continuation = continuation
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
            do {
                let image = try await networkService.downloadImage(for: operationURL)
                continuation.resume(returning: image)
            }
            catch {
                print("Error: \(error.localizedDescription)")
                continuation.resume(throwing: error)
            }
            
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
