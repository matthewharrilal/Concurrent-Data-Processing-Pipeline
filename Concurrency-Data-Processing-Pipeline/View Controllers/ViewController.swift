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
        let highPriorityQueue = DispatchQueue(label: "concurrent.globalQueue", qos: .userInitiated, attributes: .concurrent)
        let lowPriorityQeue = DispatchQueue(label: "concurrent.globalQueue", qos: .background, attributes: .concurrent)
        
        highPriorityQueue.async { [weak self] in
            Task {
                await self?.networkService.executeDownloadTask(priority: .veryLow, jobNumber: 4)
            }
            
            Task {
                await self?.networkService.executeDownloadTask(priority: .veryLow, jobNumber: 5)
            }
            
            Task {
                await self?.networkService.executeDownloadTask(priority: .veryHigh, jobNumber: 6)
            }
        }

        lowPriorityQeue.async { [weak self] in
            Task {
                await self?.networkService.executeDownloadTask(priority: .low, jobNumber: 1)
            }
            
            Task {
                await self?.networkService.executeDownloadTask(priority: .veryHigh, jobNumber: 2)
            }
        }
    }
}

