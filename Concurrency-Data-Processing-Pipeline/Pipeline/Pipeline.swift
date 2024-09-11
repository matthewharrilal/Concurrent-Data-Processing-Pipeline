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
            await invokeDownloadTask(with: url, priority: .veryHigh, jobNumber: jobNumber)
            break
        case .standardPriorityDownload(let url):
            print("URL for standard priority download \(url)")
            print("")
            await invokeDownloadTask(with: url, priority: .normal, jobNumber: jobNumber)
            break
        case.backgroundPriorityDownload(let url):
            print("URL for background priority download \(url)")
            print("")
            await invokeDownloadTask(with: url, priority: .veryLow, jobNumber: jobNumber)
            break
        }
    }
}

private extension PipelineService {
    
    func invokeDownloadTask(with url: URL, priority: Operation.QueuePriority, jobNumber: Int) async {
        await downloadService.executeDownloadTask(
            url: url,
            priority: priority,
            jobNumber: jobNumber
        )
    }
}
