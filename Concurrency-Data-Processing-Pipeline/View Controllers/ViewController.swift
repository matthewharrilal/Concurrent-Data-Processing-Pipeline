//
//  ViewController.swift
//  Concurrency-Data-Processing-Pipeline
//
//  Created by Space Wizard on 9/6/24.
//

import UIKit

class TestViewController: UIViewController {
    
    private let pipelineService: PipelineProtocol
    
    init(pipelineService: PipelineProtocol) {
        self.pipelineService = pipelineService
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
        Task {
            guard let url = URL(string: "https://via.placeholder.com/150/e13072") else { return }
            
            do {
                let image = try await pipelineService.addToPipeline(typeOfTask: .highPriorityDownload(url: url), jobNumber: 1)
                print("")
                print(image)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        Task {
            guard let url = URL(string: "https://via.placeholder.com/150/e30072") else { return }
            
            do {
                let image = try await pipelineService.addToPipeline(typeOfTask: .backgroundPriorityDownload(url: url), jobNumber: 2)
                print("")
                print(image)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}

