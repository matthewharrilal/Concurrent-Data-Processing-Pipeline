//
//  Pipeline.swift
//  Concurrency-Data-Processing-Pipeline
//
//  Created by Space Wizard on 9/11/24.
//

import Foundation
import UIKit

enum TaskType {
    case highPriorityDownload(url: URL)
    case standardPriorityDownload(url: URL)
    case backgroundPriorityDownload(url: URL)
}

protocol PipelineProtocol {
    func addToPipeline(typeOfTask: TaskType, jobNumber: Int) async
}

class PipelineService: PipelineProtocol {
    
    private lazy var highPriorityQueue = DispatchQueue(label: "concurrent.highPriority", qos: .userInitiated, attributes: .concurrent)
    private lazy var standardPriorityQueue = DispatchQueue(label: "concurrent.standardPriority", qos: .utility, attributes: .concurrent)
    private lazy var backgroundPriorityQueue = DispatchQueue(label: "concurrent.backgroundPriority", qos: .background, attributes: .concurrent)
    
    private let downloadService: DownloadService
    
    init(downloadService: DownloadService) {
        self.downloadService = downloadService
        
        downloadService.onFinishedDownload = { [weak self] (jobNumber: Int, image: UIImage?) in
            print("")
            print("Here is your image, sir \(image) for job #\(jobNumber)")
        }
    }
    
    func addToPipeline(typeOfTask: TaskType, jobNumber: Int) async {
        switch typeOfTask {
        case .highPriorityDownload(let url):
            print("URL for high priority download \(url)")
            print("")
            
            highPriorityQueue.async { [weak self] in
                self?.invokeDownloadTask(with: url, priority: .veryHigh, jobNumber: jobNumber)
            }
            
            break
        case .standardPriorityDownload(let url):
            print("URL for standard priority download \(url)")
            print("")
            
            standardPriorityQueue.async { [weak self] in
                self?.invokeDownloadTask(with: url, priority: .normal, jobNumber: jobNumber)
            }
            
            break
        case.backgroundPriorityDownload(let url):
            print("URL for background priority download \(url)")
            print("")
            
            backgroundPriorityQueue.async { [weak self] in
                self?.invokeDownloadTask(with: url, priority: .veryLow, jobNumber: jobNumber)
            }
            
            break
        }
    }
}

private extension PipelineService {
    
    func invokeDownloadTask(with url: URL, priority: Operation.QueuePriority, jobNumber: Int) {
        Task {
            await downloadService.executeDownloadTask(
                url: url,
                priority: priority,
                jobNumber: jobNumber
            )
        }
    }
}
