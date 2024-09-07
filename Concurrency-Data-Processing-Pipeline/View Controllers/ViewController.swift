//
//  ViewController.swift
//  Concurrency-Data-Processing-Pipeline
//
//  Created by Space Wizard on 9/6/24.
//

import UIKit

class TestViewController: UIViewController {
    
    private let networkService: NetworkProtocol
    
    init(networkService: NetworkProtocol) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        simulateAsyncDownloadTasks()
    }
}

extension TestViewController {
    
    private func simulateAsyncDownloadTasks() {
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        queue.async { [weak self] in
            Task {
                await self?.networkService.executeDownloadTask(priority: .veryHigh, jobNumber: 1)
            }
        }
        
        queue.async { [weak self] in
            Task {
                await self?.networkService.executeDownloadTask(priority: .veryLow, jobNumber: 2)
            }
        }
     
        queue.async { [weak self] in
            Task {
                await self?.networkService.executeDownloadTask(priority: .normal, jobNumber: 3)
            }
        }
//
//        queue.async { [weak self] in
//            Task {
//                await self?.networkService.executeDownloadTask(priority: .low, jobNumber: 4)
//            }
//        }
//        
//        queue.async { [weak self] in
//            Task {
//                await self?.networkService.executeDownloadTask(priority: .veryHigh, jobNumber: 5)
//            }
//        }
    }
}

