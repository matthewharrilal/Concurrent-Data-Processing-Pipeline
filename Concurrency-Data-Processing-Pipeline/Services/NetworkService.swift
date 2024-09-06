//
//  NetworkService.swift
//  Concurrency-Data-Processing-Pipeline
//
//  Created by Space Wizard on 9/6/24.
//

import Foundation

protocol NetworkProtocol {
    func executeDownloadTask() async
}

class NetworkService: NetworkProtocol {
    
    private let downloadActor: ConcurrentDownloadActor
    
    init(downloadActor: ConcurrentDownloadActor) {
        self.downloadActor = downloadActor
    }
    
    func executeDownloadTask() async {
        await downloadActor.performDownload()
    }
}
