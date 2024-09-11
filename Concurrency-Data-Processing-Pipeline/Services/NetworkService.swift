//
//  NetworkService.swift
//  Concurrency-Data-Processing-Pipeline
//
//  Created by Space Wizard on 9/6/24.
//

import Foundation
import UIKit

protocol NetworkProtocol {
    func downloadImage(for url: URL) async -> UIImage?
}

class NetworkService: NetworkProtocol {
    
    func downloadImage(for url: URL) async -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        }
        catch {
            print("Error downloading UIImage")
            return nil
        }
    }
}
