//
//  Pipeline.swift
//  Concurrency-Data-Processing-Pipeline
//
//  Created by Space Wizard on 9/11/24.
//

import Foundation

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
            break
        case .standardPriorityDownload(let url):
            break
        case.backgroundPriorityDownload(let url):
            break
        }
    }
}
