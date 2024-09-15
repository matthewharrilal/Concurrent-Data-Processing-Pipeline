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
    func addToPipeline(typeOfTask: TaskType, jobNumber: Int) async throws -> UIImage
}

class PipelineService: PipelineProtocol {
    private let downloadService: DownloadService
    
    init(downloadService: DownloadService) {
        self.downloadService = downloadService
    }
    
    func addToPipeline(typeOfTask: TaskType, jobNumber: Int) async throws -> UIImage {
        let priority: TaskPriority
        let taskURL: URL
        
        switch typeOfTask {
        case .highPriorityDownload(let url):
            print("URL for high priority download \(url)")
            print("")
            
            taskURL = url
            priority = .userInitiated
            break
        case .standardPriorityDownload(let url):
            print("URL for standard priority download \(url)")
            print("")
            
            taskURL = url
            priority = .medium
            break
        case.backgroundPriorityDownload(let url):
            print("URL for background priority download \(url)")
            print("")
            
            taskURL = url
            priority = .medium
            break
        }
        
        return try await invokeDownloadTask(with: taskURL, priority: priority, jobNumber: jobNumber)
    }
}

private extension PipelineService {
    
    func invokeDownloadTask(with url: URL, priority: TaskPriority, jobNumber: Int) async throws -> UIImage {
        return try await Task(priority: priority) {
            try await downloadService.executeDownloadTask(
                url: url,
                priority: priority.toOperationQueuePriority(),
                jobNumber: jobNumber
            )
        }.value
    }
}
