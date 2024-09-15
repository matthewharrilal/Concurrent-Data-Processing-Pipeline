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
    func addToPipeline(typeOfTask: TaskType, jobNumber: Int) async -> AsyncStream<PipelineEvent>
}

enum PipelineEvent {
    case downloadStarted
    case downloaded(UIImage)
    case transformed(UIImage)
    case saved
    case failed(Error)
}

class PipelineService: PipelineProtocol {
    private let downloadService: DownloadService
    
    init(downloadService: DownloadService) {
        self.downloadService = downloadService
    }
    
    func addToPipeline(typeOfTask: TaskType, jobNumber: Int) async -> AsyncStream<PipelineEvent> {
        return AsyncStream { continuation in
            Task { // Switches internal logic to concurrent context allowing parallel execution with other pipeline tasks otherwise would block due to the caller of this method being on the main thread
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
                
                do {
                    continuation.yield(.downloadStarted)
                    let image = try await invokeDownloadTask(with: taskURL, priority: priority, jobNumber: jobNumber)
                    continuation.yield(.downloaded(image))
                }
                catch {
                    continuation.yield(.failed(error))
                }
                
                continuation.finish()
            }
        }
    }
}

private extension PipelineService {
    
    func invokeDownloadTask(with url: URL, priority: TaskPriority, jobNumber: Int) async throws -> UIImage {
        return try await Task(priority: priority) {
            return try await downloadService.executeDownloadTask(
                url: url,
                priority: priority.toOperationQueuePriority(),
                jobNumber: jobNumber
            )
        }.value
    }
}
