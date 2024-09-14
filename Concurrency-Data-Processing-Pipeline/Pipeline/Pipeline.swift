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
    private let downloadService: DownloadService
    
    init(downloadService: DownloadService) {
        self.downloadService = downloadService
    }
    
    func addToPipeline(typeOfTask: TaskType, jobNumber: Int) async {
        switch typeOfTask {
        case .highPriorityDownload(let url):
            print("URL for high priority download \(url)")
            print("")
            
            invokeDownloadTask(with: url, priority: .userInitiated, jobNumber: jobNumber)
            
            break
        case .standardPriorityDownload(let url):
            print("URL for standard priority download \(url)")
            print("")
            
            invokeDownloadTask(with: url, priority: .medium, jobNumber: jobNumber)
            
            break
        case.backgroundPriorityDownload(let url):
            print("URL for background priority download \(url)")
            print("")
            
            invokeDownloadTask(with: url, priority: .background, jobNumber: jobNumber)
            
            break
        }
    }
}

private extension PipelineService {
    
    func invokeDownloadTask(with url: URL, priority: TaskPriority, jobNumber: Int) {
        Task(priority: priority) {
            await downloadService.executeDownloadTask(
                url: url,
                priority: priority.toOperationQueuePriority(),
                jobNumber: jobNumber
            )
        }
    }
}
